namespace CCOInsights.SubscriptionManager.Functions.Operations.ServicePrincipals;

public class ServicePrincipalResponse : Microsoft.Graph.Models.ServicePrincipal, IAzureResponse
{
    //These properties are used to store the next links for pagination of related resources
    // With the new version of graph api sdk are not included in the model, but
    // we need to maintain them for compatibility with existing code
    // if they didn't exists, the powerbi reports might break.
    public string AppRoleAssignedToNextLink { get;set; } = string.Empty;
    public string AppRoleAssignmentsNextLink { get; set; } = string.Empty;
    public string OwnersNextLink { get; set; } = string.Empty;
    public string TokenIssuancePoliciesNextLink { get; set; } = string.Empty;
    public string TokenLifetimePoliciesNextLink { get; set; } = string.Empty;
    public string TransitiveMemberOfNextLink { get; set; } = string.Empty;
    public string OwnedObjectsNextLink  { get; set; } = string.Empty;
    public string MemberOfNextLink { get; set; } = string.Empty;
    public string Oauth2PermissionGrantsNextLink { get; set; } = string.Empty;
    public string ClaimsMappingPoliciesNextLink { get; set; } = string.Empty;
    public string CreatedObjectsNextLink { get; set; } = string.Empty;
    public string EndpointsNextLink { get; set; } = string.Empty;
    public string FederatedIdentityCredentialsNextLink { get; set; } = string.Empty;
    public string HomeRealmDiscoveryPoliciesNextLink { get; set; } = string.Empty;
    public string DelegatedPermissionClassificationsNextLink { get; set; } = string.Empty;

}
