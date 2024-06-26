using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PublicIPs;

public interface IPublicIPProvider : IProvider<PublicIPsResponse> { }
public class PublicIPsProvider(IHttpClientFactory httpClientFactory, RestClient restClient)
    : Provider<PublicIPsResponse>(httpClientFactory, restClient), IPublicIPProvider
{
    public override string Path => "/providers/Microsoft.Network/publicIPAddresses?api-version=2022-05-01";
    public override HttpMethod HttpMethod => HttpMethod.Get;
}
