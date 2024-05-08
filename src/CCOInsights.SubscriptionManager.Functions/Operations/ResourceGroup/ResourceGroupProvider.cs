using System.Net.Http;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.ResourceGroup;

public interface IResourceGroupProvider : IProvider<ResourceGroupResponse> { }
public class ResourceGroupProvider : Provider<ResourceGroupResponse>, IResourceGroupProvider
{
    public override string Path => "/resourcegroups?api-version=2021-04-01";
    public override HttpMethod HttpMethod => HttpMethod.Get;

    public ResourceGroupProvider(IHttpClientFactory httpClientFactory, RestClient restClient) : base(httpClientFactory, restClient)
    {
    }
}