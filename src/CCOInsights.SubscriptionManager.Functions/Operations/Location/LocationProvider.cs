using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Location;

public interface ILocationProvider : IProvider<LocationResponse> { }
public class LocationProvider(IHttpClientFactory httpClientFactory, RestClient restClient)
    : Provider<LocationResponse>(httpClientFactory, restClient), ILocationProvider
{
    public override string Path => "/locations?api-version=2020-01-01";
    public override HttpMethod HttpMethod => HttpMethod.Get;
}
