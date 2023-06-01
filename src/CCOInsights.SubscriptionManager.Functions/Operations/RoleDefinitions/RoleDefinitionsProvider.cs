using System.Collections.Generic;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Newtonsoft.Json;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.RoleDefinitions
{


    public interface IRoleDefinitionsProvider : IProvider<RoleDefinitionsResponse> { }
    public class RoleDefinitionsProvider : IRoleDefinitionsProvider
    {
        private readonly IAuthenticated _authenticated;
        private readonly RestClient _restClient;
        private readonly IHttpClientFactory _httpClientFactory;

        public RoleDefinitionsProvider(IAuthenticated authenticated, RestClient restClient, IHttpClientFactory httpClientFactory)
        {
            _authenticated = authenticated;
            _restClient = restClient;
            _httpClientFactory = httpClientFactory;
        }

        public async Task<IEnumerable<RoleDefinitionsResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
        {
            var httpClient = _httpClientFactory.CreateClient("client");
            var response = await GetModelAsync(httpClient, $"https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/roleDefinitions?api-version=2018-07-01", cancellationToken);
            return response.Value;
        }

        private async Task<RoleDefinitionsResponseList> GetModelAsync(HttpClient client, string url, CancellationToken cancellationToken = default)
        {
            var request = new HttpRequestMessage(HttpMethod.Get, url);

            await _restClient.Credentials.ProcessHttpRequestAsync(request, cancellationToken);
            var response = await client.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
            var content = await response.Content.ReadAsStringAsync(cancellationToken);

            return JsonConvert.DeserializeObject<RoleDefinitionsResponseList>(content);
        }
    }
}
