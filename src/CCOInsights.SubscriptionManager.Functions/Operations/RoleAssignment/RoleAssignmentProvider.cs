using System.Net.Http;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.RoleAssignment
{
    public interface IRoleAssignmentProvider : IProvider<RoleAssignmentResponse> { }

    public class RoleAssignmentProvider : Provider<RoleAssignmentResponse>, IRoleAssignmentProvider
    {
        public override string Path => "/providers/Microsoft.Authorization/roleAssignments?api-version=2015-07-01&$filter=atScope()";
        public override HttpMethod HttpMethod => HttpMethod.Get;

        public RoleAssignmentProvider(IHttpClientFactory httpClientFactory, RestClient restClient) : base(httpClientFactory, restClient)
        {
        }
    }
}
