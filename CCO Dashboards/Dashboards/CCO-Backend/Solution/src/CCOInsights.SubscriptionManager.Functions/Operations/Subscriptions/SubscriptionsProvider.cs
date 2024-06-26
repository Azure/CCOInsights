using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Subscriptions;

public interface ISubscriptionProvider : IProvider<SubscriptionsResponse> { }

public class SubscriptionsProvider(IHttpClientFactory httpClientFactory, RestClient restClient)
    : ISubscriptionProvider
{
    public async Task<IEnumerable<SubscriptionsResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var request = new HttpRequestMessage(HttpMethod.Get, $"https://management.azure.com/subscriptions?api-version=2020-01-01");
        await restClient.Credentials.ProcessHttpRequestAsync(request, cancellationToken);

        var httpClient = httpClientFactory.CreateClient("client");
        var response = await httpClient.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);

        var content = await response.Content.ReadAsStringAsync(cancellationToken);
        var result = JsonConvert.DeserializeObject<ProviderResponse<SubscriptionsResponse>>(content);

        return result.Value;
    }
}
