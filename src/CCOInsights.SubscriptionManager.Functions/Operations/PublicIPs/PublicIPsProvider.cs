using System.Net.Http;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PublicIPs;

public interface IPublicIPProvider : IProvider<PublicIPsResponse> { }
public class PublicIPsProvider : Provider<PublicIPsResponse>, IPublicIPProvider
{
    public override string Path => "/providers/Microsoft.Network/publicIPAddresses?api-version=2022-05-01";
    public override HttpMethod HttpMethod => HttpMethod.Get;

    public PublicIPsProvider(IHttpClientFactory httpClientFactory, RestClient restClient) : base(httpClientFactory, restClient)
    {
    }
}
