using CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachine;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachineExtensions;

public interface IVirtualMachineExtensionProvider : IProvider<VirtualMachineExtensionsResponse>
{ }

public class VirtualMachineExtensionsProvider(IVirtualMachineProvider vmProvider, IHttpClientFactory httpClientFactory,
        RestClient restClient)
    : IVirtualMachineExtensionProvider
{
    public async Task<IEnumerable<VirtualMachineExtensionsResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var virtualMachines = await vmProvider.GetAsync(subscriptionId, cancellationToken);
        var result = new List<VirtualMachineExtensionsResponse>();

        await virtualMachines.AsyncParallelForEach(async vm =>
        {
            var httpClient = httpClientFactory.CreateClient("client");

            var response = await GetModelAsync(httpClient, $"https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachines/{vm.Name}/extensions?api-version=2022-08-01", cancellationToken);

            if (response is { Value: not null })
            {
                result.AddRange(response.Value);
            }

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

        await restClient.Credentials.ProcessHttpRequestAsync(request, cancellationToken);
        var response = await client.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
        var content = await response.Content.ReadAsStringAsync(cancellationToken);

        return JsonConvert.DeserializeObject<ProviderResponse<VirtualMachineExtensionsResponse>>(content);
    }
}
