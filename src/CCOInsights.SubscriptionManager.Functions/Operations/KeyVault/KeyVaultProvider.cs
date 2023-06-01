using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Helpers;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Newtonsoft.Json;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.KeyVault
{
    public interface IKeyVaultProvider : IProvider<KeyVaultResponse> { }
    public class KeyVaultProvider : IKeyVaultProvider
    {
        private readonly IAuthenticated _authenticated;
        private readonly RestClient _restClient;
        private readonly IHttpClientFactory _httpClientFactory;

        public KeyVaultProvider(IAuthenticated authenticated, RestClient restClient, IHttpClientFactory httpClientFactory)
        {
            _authenticated = authenticated;
            _restClient = restClient;
            _httpClientFactory = httpClientFactory;
        }

        public async Task<IEnumerable<KeyVaultResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
        {
            var result = new List<KeyVaultResponse>();

            var resources = await _authenticated.WithSubscription(subscriptionId).Deployments.Manager.GenericResources.ListAsync(cancellationToken: cancellationToken);
            var keyVaultsResources = resources.Where(r => r.Type.Contains("Microsoft.KeyVault/vaults")).ToList();

            await keyVaultsResources.AsyncParallelForEach(async keyVaultResource =>
            {
                var httpClient = _httpClientFactory.CreateClient("client");

                var response = await GetModelAsync(httpClient, $"https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{keyVaultResource.ResourceGroupName}/providers/Microsoft.KeyVault/vaults/{keyVaultResource.Name}?api-version=2021-10-01", cancellationToken);

                result.Add(response);
            });

            return result;
        }

        private async Task<KeyVaultResponse> GetModelAsync(HttpClient client, string url, CancellationToken cancellationToken = default)
        {
            var request = new HttpRequestMessage(HttpMethod.Get, url);

            await _restClient.Credentials.ProcessHttpRequestAsync(request, cancellationToken);
            var response = await client.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
            var content = await response.Content.ReadAsStringAsync(cancellationToken);

            return JsonConvert.DeserializeObject<KeyVaultResponse>(content);
        }
    }
}
