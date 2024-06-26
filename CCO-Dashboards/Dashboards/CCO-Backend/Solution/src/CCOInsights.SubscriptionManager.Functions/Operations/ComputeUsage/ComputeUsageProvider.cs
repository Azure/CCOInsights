using CCOInsights.SubscriptionManager.Functions.Operations.Location;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.ComputeUsage;

public interface IComputeUsageProvider : IProvider<ComputeUsageResponse> { }

public class ComputeUsageProvider(RestClient restClient, IHttpClientFactory httpClientFactory,
        ILocationProvider locationProvider)
    : IComputeUsageProvider
{
    public async Task<IEnumerable<ComputeUsageResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var locations = await locationProvider.GetAsync(subscriptionId, cancellationToken);
        var result = new List<ComputeUsageResponse>();
        foreach (var location in locations)
        {
            var httpClient = httpClientFactory.CreateClient("client");
            var response = await GetModelAsync(httpClient, $"https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location.Name}/usages?api-version=2022-11-01", cancellationToken);
            if (response.Value != null)
            {
                result.AddRange(response.Value);
            }

            while (!string.IsNullOrEmpty(response.NextLink))
            {
                response = await GetModelAsync(httpClient, response.NextLink, cancellationToken);
                if (response.Value != null)
                {
                    result.AddRange(response.Value);
                }
            }
        }

        return result;
    }

    private async Task<ProviderResponse<ComputeUsageResponse>> GetModelAsync(HttpClient client, string url, CancellationToken cancellationToken = default)
    {
        var request = new HttpRequestMessage(HttpMethod.Get, url);

        await restClient.Credentials.ProcessHttpRequestAsync(request, cancellationToken);
        var response = await client.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
        var content = await response.Content.ReadAsStringAsync(cancellationToken);

        return JsonConvert.DeserializeObject<ProviderResponse<ComputeUsageResponse>>(content);
    }
}
