using Microsoft.Graph;

namespace CCOInsights.SubscriptionManager.Functions.Operations.ServicePrincipals;

public interface IServicePrincipalProvider : IProvider<ServicePrincipalResponse> { }
public class ServicePrincipalProvider(GraphServiceClient graphServiceClient) : IServicePrincipalProvider
{
    public async Task<IEnumerable<ServicePrincipalResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var result = await graphServiceClient.ServicePrincipals.Request().GetAsync(cancellationToken);

        var response = result.Select(Map).ToList();

        while (result.NextPageRequest != null)
        {
            result = await result.NextPageRequest.GetAsync(cancellationToken);
            response.AddRange(result.Select(Map).ToList());
        }
        return response;
    }


    private ServicePrincipalResponse Map(Microsoft.Graph.ServicePrincipal servicePrincipal)
    {
        return new ServicePrincipalResponse
        {
            AccountEnabled = servicePrincipal.AccountEnabled,
            AddIns = servicePrincipal.AddIns,
            AlternativeNames = servicePrincipal.AlternativeNames,
            AppDescription = servicePrincipal.AppDescription,
            AppDisplayName = servicePrincipal.AppDisplayName,
            AppId = servicePrincipal.AppId,
            ApplicationTemplateId = servicePrincipal.ApplicationTemplateId,
            AppOwnerOrganizationId = servicePrincipal.AppOwnerOrganizationId,
            AppRoleAssignmentRequired = servicePrincipal.AppRoleAssignmentRequired,
            AppRoles = servicePrincipal.AppRoles,
            Description = servicePrincipal.Description,
            DisabledByMicrosoftStatus = servicePrincipal.DisabledByMicrosoftStatus,
            DisplayName = servicePrincipal.DisplayName,
            Homepage = servicePrincipal.Homepage,
            Info = servicePrincipal.Info,
            KeyCredentials = servicePrincipal.KeyCredentials,
            LoginUrl = servicePrincipal.LoginUrl,
            LogoutUrl = servicePrincipal.LogoutUrl,
            Notes = servicePrincipal.Notes,
            NotificationEmailAddresses = servicePrincipal.NotificationEmailAddresses,
            Oauth2PermissionScopes = servicePrincipal.Oauth2PermissionScopes,
            PasswordCredentials = servicePrincipal.PasswordCredentials,
            PreferredSingleSignOnMode = servicePrincipal.PreferredSingleSignOnMode,
            PreferredTokenSigningKeyThumbprint = servicePrincipal.PreferredTokenSigningKeyThumbprint,
            ReplyUrls = servicePrincipal.ReplyUrls,
            ResourceSpecificApplicationPermissions = servicePrincipal.ResourceSpecificApplicationPermissions,
            SamlSingleSignOnSettings = servicePrincipal.SamlSingleSignOnSettings,
            ServicePrincipalNames = servicePrincipal.ServicePrincipalNames,
            ServicePrincipalType = servicePrincipal.ServicePrincipalType,
            SignInAudience = servicePrincipal.SignInAudience,
            Tags = servicePrincipal.Tags,
            TokenEncryptionKeyId = servicePrincipal.TokenEncryptionKeyId,
            VerifiedPublisher = servicePrincipal.VerifiedPublisher,
            AppRoleAssignedTo = servicePrincipal.AppRoleAssignedTo,
            AppRoleAssignedToNextLink = servicePrincipal.AppRoleAssignedToNextLink,
            AppRoleAssignments = servicePrincipal.AppRoleAssignments,
            AppRoleAssignmentsNextLink = servicePrincipal.AppRoleAssignmentsNextLink,
            ClaimsMappingPolicies = servicePrincipal.ClaimsMappingPolicies,
            ClaimsMappingPoliciesNextLink = servicePrincipal.ClaimsMappingPoliciesNextLink,
            CreatedObjects = servicePrincipal.CreatedObjects,
            CreatedObjectsNextLink = servicePrincipal.CreatedObjectsNextLink,
            DelegatedPermissionClassifications = servicePrincipal.DelegatedPermissionClassifications,
            DelegatedPermissionClassificationsNextLink = servicePrincipal.DelegatedPermissionClassificationsNextLink,
            Endpoints = servicePrincipal.Endpoints,
            EndpointsNextLink = servicePrincipal.EndpointsNextLink,
            FederatedIdentityCredentials = servicePrincipal.FederatedIdentityCredentials,
            FederatedIdentityCredentialsNextLink = servicePrincipal.FederatedIdentityCredentialsNextLink,
            HomeRealmDiscoveryPolicies = servicePrincipal.HomeRealmDiscoveryPolicies,
            HomeRealmDiscoveryPoliciesNextLink = servicePrincipal.HomeRealmDiscoveryPoliciesNextLink,
            MemberOf = servicePrincipal.MemberOf,
            MemberOfNextLink = servicePrincipal.MemberOfNextLink,
            Oauth2PermissionGrants = servicePrincipal.Oauth2PermissionGrants,
            Oauth2PermissionGrantsNextLink = servicePrincipal.Oauth2PermissionGrantsNextLink,
            OwnedObjects = servicePrincipal.OwnedObjects,
            OwnedObjectsNextLink = servicePrincipal.OwnedObjectsNextLink,
            Owners = servicePrincipal.Owners,
            OwnersNextLink = servicePrincipal.OwnersNextLink,
            TokenIssuancePolicies = servicePrincipal.TokenIssuancePolicies,
            TokenIssuancePoliciesNextLink = servicePrincipal.TokenIssuancePoliciesNextLink,
            TokenLifetimePolicies = servicePrincipal.TokenLifetimePolicies,
            TokenLifetimePoliciesNextLink = servicePrincipal.TokenLifetimePoliciesNextLink,
            TransitiveMemberOf = servicePrincipal.TransitiveMemberOf,
            TransitiveMemberOfNextLink = servicePrincipal.TransitiveMemberOfNextLink
        };
    }
}
