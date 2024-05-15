using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Entity;

public interface IEntityProvider : IProvider<EntityResponse> { }
public class EntityProvider(RestClient restClient, IHttpClientFactory httpClientFactory)
    : IEntityProvider
{
    public async Task<IEnumerable<EntityResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var result = new List<EntityResponse>();
        var httpClient = httpClientFactory.CreateClient("client");
        var response = await GetModelAsync(httpClient, "https://management.azure.com/providers/Microsoft.Management/getEntities?api-version=2020-05-01", cancellationToken);

        if (response != null && response.Value.Any())
            result.AddRange(response.Value);

        while (!string.IsNullOrEmpty(response?.NextLink))
        {
            response = await GetModelAsync(httpClient, response.NextLink, cancellationToken);
            result.AddRange(response.Value);
        }

        return result;
    }

    private async Task<ProviderResponse<EntityResponse>> GetModelAsync(HttpClient client, string url, CancellationToken cancellationToken = default)
    {
        var request = new HttpRequestMessage(HttpMethod.Post, url);

        await restClient.Credentials.ProcessHttpRequestAsync(request, cancellationToken);
        var response = await client.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
        var content = await response.Content.ReadAsStringAsync(cancellationToken);

        return JsonConvert.DeserializeObject<ProviderResponse<EntityResponse>>(content);
    }
}
