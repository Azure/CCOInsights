using System.Collections.Generic;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions.Operations.Location;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Newtonsoft.Json;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.NetworkUsages;

public interface INetworkUsagesProvider : IProvider<NetworkUsagesResponse> { }
public class NetworkUsagesProvider : INetworkUsagesProvider
{
    private readonly IAuthenticated _authenticated;
    private readonly RestClient _restClient;
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly ILocationProvider _locationProvider;

    public NetworkUsagesProvider(IAuthenticated authenticated, RestClient restClient, IHttpClientFactory httpClientFactory, ILocationProvider locationProvider)
    {
        _authenticated = authenticated;
        _restClient = restClient;
        _httpClientFactory = httpClientFactory;
        _locationProvider = locationProvider;
    }

    public async Task<IEnumerable<NetworkUsagesResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var httpClient = _httpClientFactory.CreateClient("client");
        var locations = await _locationProvider.GetAsync(subscriptionId, cancellationToken);
        var listOfNetworkUsages = new List<NetworkUsagesResponse>();
        foreach (var location in locations)
        {
            var response = await GetModelAsync(httpClient, $"https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Network/locations/{location.Name}/usages?api-version=2022-05-01", cancellationToken);
            if (response.value != null)
                listOfNetworkUsages.AddRange(response.value);
        }

        return listOfNetworkUsages;
    }

    private async Task<NetworkUsagesResponseList> GetModelAsync(HttpClient client, string url, CancellationToken cancellationToken = default)
    {
        var request = new HttpRequestMessage(HttpMethod.Get, url);

        await _restClient.Credentials.ProcessHttpRequestAsync(request, cancellationToken);
        var response = await client.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
        var content = await response.Content.ReadAsStringAsync(cancellationToken);

        return JsonConvert.DeserializeObject<NetworkUsagesResponseList>(content);
    }
}