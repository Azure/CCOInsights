using CCOInsights.SubscriptionManager.Functions.Operations.Location;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.StorageUsage;

public interface IStorageUsageProvider : IProvider<StorageUsageResponse> { }

public class StorageUsageProvider(RestClient restClient, IHttpClientFactory httpClientFactory,
        ILocationProvider locationProvider)
    : IStorageUsageProvider
{
    public async Task<IEnumerable<StorageUsageResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var locations = await locationProvider.GetAsync(subscriptionId, cancellationToken);
        var result = new List<StorageUsageResponse>();
        foreach (var location in locations)
        {
            var httpClient = httpClientFactory.CreateClient("client");
            var response = await GetModelAsync(httpClient, $"https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Storage/locations/{location.Name}/usages?api-version=2022-09-01", cancellationToken);
            if (response.Value != null)
            {
                result.AddRange(response.Value);
            }
        }

        return result;
    }

    private async Task<ProviderResponse<StorageUsageResponse>> GetModelAsync(HttpClient client, string url, CancellationToken cancellationToken = default)
    {
        var request = new HttpRequestMessage(HttpMethod.Get, url);

        await restClient.Credentials.ProcessHttpRequestAsync(request, cancellationToken);
        var response = await client.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
        var content = await response.Content.ReadAsStringAsync(cancellationToken);

        return JsonConvert.DeserializeObject<ProviderResponse<StorageUsageResponse>>(content);
    }
}
