using System.Collections.Generic;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachine;
using CCOInsights.SubscriptionManager.Helpers;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachineExtensions
{
    public interface IVirtualMachineExtensionProvider : IProvider<VirtualMachineExtensionsResponse>
    { }

    public class VirtualMachineExtensionsProvider : IVirtualMachineExtensionProvider
    {
        private readonly IVirtualMachineProvider _vmProvider;
        private readonly RestClient _restClient;
        private readonly IHttpClientFactory _httpClientFactory;

        public VirtualMachineExtensionsProvider(IVirtualMachineProvider vmProvider, IHttpClientFactory httpClientFactory, RestClient restClient)
        {
            _vmProvider = vmProvider;
            _httpClientFactory = httpClientFactory;
            _restClient = restClient;
        }

        public async Task<IEnumerable<VirtualMachineExtensionsResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
        {
            var virtualMachines = await _vmProvider.GetAsync(subscriptionId, cancellationToken);
            var result = new List<VirtualMachineExtensionsResponse>();

            await virtualMachines.AsyncParallelForEach(async vm =>
            {
                var httpClient = _httpClientFactory.CreateClient("client");

                var response = await GetModelAsync(httpClient, $"https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachines/{vm.Name}/extensions?api-version=2022-08-01", cancellationToken);

                result.AddRange(response.Value);

                while (!string.IsNullOrEmpty(response.NextLink))
                {
                    response = await GetModelAsync(httpClient, response.NextLink, cancellationToken);
                    result.AddRange(response.Value);
                }
            });

            return result;
        }

        private async Task<ProviderResponse<VirtualMachineExtensionsResponse>> GetModelAsync(HttpClient client, string url, CancellationToken cancellationToken = default)
        {
            var request = new HttpRequestMessage(HttpMethod.Get, url);

            await _restClient.Credentials.ProcessHttpRequestAsync(request, cancellationToken);
            var response = await client.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
            var content = await response.Content.ReadAsStringAsync(cancellationToken);

            return JsonConvert.DeserializeObject<ProviderResponse<VirtualMachineExtensionsResponse>>(content);
        }
    }
}
