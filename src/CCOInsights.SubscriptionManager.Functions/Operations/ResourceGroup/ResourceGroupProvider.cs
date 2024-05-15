using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.ResourceGroup;

public interface IResourceGroupProvider : IProvider<ResourceGroupResponse> { }
public class ResourceGroupProvider(IHttpClientFactory httpClientFactory, RestClient restClient)
    : Provider<ResourceGroupResponse>(httpClientFactory, restClient), IResourceGroupProvider
{
    public override string Path => "/resourcegroups?api-version=2021-04-01";
    public override HttpMethod HttpMethod => HttpMethod.Get;
}
