using CCOInsights.SubscriptionManager.Functions.Operations.Blueprint;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintPublished;

public interface IBlueprintPublishedProvider : IProvider<BlueprintPublishedResponse> { }
public class BlueprintPublishedProvider(IBlueprintProvider blueprintProvider, IHttpClientFactory httpClientFactory,
        RestClient restClient)
    : IBlueprintPublishedProvider
{
    public async Task<IEnumerable<BlueprintPublishedResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var bluePrints = await blueprintProvider.GetAsync(subscriptionId, cancellationToken);
        var result = new List<BlueprintPublishedResponse>();

        await bluePrints.AsyncParallelForEach(async bluePrint =>
        {
            var httpClient = httpClientFactory.CreateClient("client");

            var response = await GetModelAsync(httpClient, $"https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Blueprint/blueprints/{bluePrint.Name}/versions?api-version=2018-11-01-preview", cancellationToken);

            result.AddRange(response.Value);

            while (!string.IsNullOrEmpty(response.NextLink))
            {
                response = await GetModelAsync(httpClient, response.NextLink, cancellationToken);
                result.AddRange(response.Value);
            }
        });

        return result;
    }

    private async Task<ProviderResponse<BlueprintPublishedResponse>> GetModelAsync(HttpClient client, string url, CancellationToken cancellationToken = default)
    {
        var request = new HttpRequestMessage(HttpMethod.Get, url);

        await restClient.Credentials.ProcessHttpRequestAsync(request, cancellationToken);
        var response = await client.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
        var content = await response.Content.ReadAsStringAsync(cancellationToken);

        return JsonConvert.DeserializeObject<ProviderResponse<BlueprintPublishedResponse>>(content);
    }
}
