using System.Collections.Generic;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Subscriptions;

public interface ISubscriptionProvider : IProvider<SubscriptionsResponse> { }

public class SubscriptionsProvider : ISubscriptionProvider
{
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly RestClient _restClient;

    public SubscriptionsProvider(IHttpClientFactory httpClientFactory, RestClient restClient)
    {
        _httpClientFactory = httpClientFactory;
        _restClient = restClient;
    }

    public async Task<IEnumerable<SubscriptionsResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var request = new HttpRequestMessage(HttpMethod.Get, $"https://management.azure.com/subscriptions?api-version=2020-01-01");
        await _restClient.Credentials.ProcessHttpRequestAsync(request, cancellationToken);

        var httpClient = _httpClientFactory.CreateClient("client");
        var response = await httpClient.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);

        var content = await response.Content.ReadAsStringAsync(cancellationToken);
        var result = JsonConvert.DeserializeObject<ProviderResponse<SubscriptionsResponse>>(content);

        return result.Value;
    }
}