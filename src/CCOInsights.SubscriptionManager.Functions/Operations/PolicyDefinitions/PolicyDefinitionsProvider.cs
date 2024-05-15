using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicyDefinitions;

public interface IPolicyDefinitionProvider : IProvider<PolicyDefinitionResponse> { }
public class PolicyDefinitionsProvider(IHttpClientFactory httpClientFactory, RestClient restClient)
    : Provider<PolicyDefinitionResponse>(httpClientFactory, restClient), IPolicyDefinitionProvider
{
    public override string Path => "/providers/Microsoft.Authorization/policyDefinitions?api-version=2021-06-01";
    public override HttpMethod HttpMethod => HttpMethod.Get;
}
