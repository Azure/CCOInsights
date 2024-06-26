using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicyState;

public interface IPolicyStateProvider : IProvider<AzurePolicyStateResponseValue> { }
public class PolicyStateProvider(RestClient restClient, IHttpClientFactory httpClientFactory)
    : IPolicyStateProvider
{
    public async Task<IEnumerable<AzurePolicyStateResponseValue>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var result = new List<AzurePolicyStateResponseValue>();
        var httpClient = httpClientFactory.CreateClient("client");
        var response = await GetResponseAsync(httpClient, $"https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/policyStates/latest/queryResults?api-version=2019-10-01", cancellationToken);

        if (response?.Value != null)
            result.AddRange(response.Value);

        while (!string.IsNullOrEmpty(response?.OdataNextLink))
        {
            response = await GetResponseAsync(httpClient, response.OdataNextLink, cancellationToken);
            result.AddRange(response.Value);
        }

        return result;
    }

    private async Task<PolicyStateResponse> GetResponseAsync(HttpClient httpClient, string url, CancellationToken cancellationToken = default)
    {
        var request = new HttpRequestMessage(HttpMethod.Post, url);

        await restClient.Credentials.ProcessHttpRequestAsync(request, cancellationToken);
        var response = await httpClient.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
        var content = await response.Content.ReadAsStringAsync(cancellationToken);

        return JsonConvert.DeserializeObject<PolicyStateResponse>(content);
    }
}
