using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.RoleAssignment;

public interface IRoleAssignmentProvider : IProvider<RoleAssignmentResponse> { }

public class RoleAssignmentProvider(IHttpClientFactory httpClientFactory, RestClient restClient)
    : Provider<RoleAssignmentResponse>(httpClientFactory, restClient), IRoleAssignmentProvider
{
    public override string Path => "/providers/Microsoft.Authorization/roleAssignments?api-version=2015-07-01&$filter=atScope()";
    public override HttpMethod HttpMethod => HttpMethod.Get;
}
