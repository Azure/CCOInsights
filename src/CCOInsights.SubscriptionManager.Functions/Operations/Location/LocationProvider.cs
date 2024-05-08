using System.Net.Http;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Location;

public interface ILocationProvider : IProvider<LocationResponse> { }
public class LocationProvider : Provider<LocationResponse>, ILocationProvider
{
    public override string Path => "/locations?api-version=2020-01-01";
    public override HttpMethod HttpMethod => HttpMethod.Get;

    public LocationProvider(IHttpClientFactory httpClientFactory, RestClient restClient) : base(httpClientFactory, restClient)
    {
    }
}