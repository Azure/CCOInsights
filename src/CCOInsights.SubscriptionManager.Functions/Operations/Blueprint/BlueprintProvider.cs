using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Blueprint;

public interface IBlueprintProvider : IProvider<BlueprintResponse> { }

public class BlueprintProvider(IHttpClientFactory httpClientFactory, RestClient restClient)
    : Provider<BlueprintResponse>(httpClientFactory, restClient), IBlueprintProvider
{
    public override string Path => "/providers/Microsoft.Blueprint/blueprints?api-version=2018-11-01-preview";
    public override HttpMethod HttpMethod => HttpMethod.Get;
}
