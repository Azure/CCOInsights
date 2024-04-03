using System.Net.Http;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Nic;

public interface INicProvider : IProvider<NicResponse>
{

}

public class NicProvider : Provider<NicResponse>, INicProvider
{
    public override string Path => "/providers/Microsoft.Network/networkInterfaces?api-version=2021-05-01";
    public override HttpMethod HttpMethod => HttpMethod.Get;

    public NicProvider(IHttpClientFactory httpClientFactory, RestClient restClient) : base(httpClientFactory, restClient)
    {
    }
}