using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicySetDefinitions;

public interface IPolicySetDefinitionProvider : IProvider<PolicySetDefinitionsResponse> { }

public class PolicySetDefinitionsProvider(IHttpClientFactory httpClientFactory, RestClient restClient)
    : Provider<PolicySetDefinitionsResponse>(httpClientFactory, restClient), IPolicySetDefinitionProvider
{
    public override string Path => "/providers/Microsoft.Authorization/policySetDefinitions?api-version=2021-06-01";
    public override HttpMethod HttpMethod => HttpMethod.Get;
}
