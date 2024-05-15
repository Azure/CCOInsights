using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Nic;

public interface INicProvider : IProvider<NicResponse>
{

}

public class NicProvider(IHttpClientFactory httpClientFactory, RestClient restClient)
    : Provider<NicResponse>(httpClientFactory, restClient), INicProvider
{
    public override string Path => "/providers/Microsoft.Network/networkInterfaces?api-version=2021-05-01";
    public override HttpMethod HttpMethod => HttpMethod.Get;
}
