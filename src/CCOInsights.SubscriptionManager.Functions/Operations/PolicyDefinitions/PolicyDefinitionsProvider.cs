using System.Net.Http;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicyDefinitions
{
    public interface IPolicyDefinitionProvider : IProvider<PolicyDefinitionResponse> { }
    public class PolicyDefinitionsProvider : Provider<PolicyDefinitionResponse>, IPolicyDefinitionProvider
    {
        public override string Path => "/providers/Microsoft.Authorization/policyDefinitions?api-version=2021-06-01";
        public override HttpMethod HttpMethod => HttpMethod.Get;

        public PolicyDefinitionsProvider(IHttpClientFactory httpClientFactory, RestClient restClient) : base(httpClientFactory, restClient)
        {
        }
    }
}
