using Microsoft.Graph;
using Microsoft.Graph.Models;

namespace CCOInsights.SubscriptionManager.Functions.Operations.ServicePrincipals;

public interface IServicePrincipalProvider : IProvider<ServicePrincipalResponse> { }
public class ServicePrincipalProvider(GraphServiceClient graphServiceClient) : IServicePrincipalProvider
{
    public async Task<IEnumerable<ServicePrincipalResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var resultResponse = await graphServiceClient.ServicePrincipals.GetAsync(null, cancellationToken);

        var responseList = new List<ServicePrincipalResponse>();

        var pageIterator = PageIterator<Microsoft.Graph.Models.ServicePrincipal, ServicePrincipalCollectionResponse>.CreatePageIterator(graphServiceClient, resultResponse, (Microsoft.Graph.Models.ServicePrincipal element) => { responseList.Add(Map(element)); return true; });

        await pageIterator.IterateAsync(cancellationToken);
        return responseList;
    }


    private ServicePrincipalResponse Map(Microsoft.Graph.Models.ServicePrincipal servicePrincipal)
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
            AppRoleAssignments = servicePrincipal.AppRoleAssignments,
            ClaimsMappingPolicies = servicePrincipal.ClaimsMappingPolicies,
            CreatedObjects = servicePrincipal.CreatedObjects,
            DelegatedPermissionClassifications = servicePrincipal.DelegatedPermissionClassifications,
            Endpoints = servicePrincipal.Endpoints,
            FederatedIdentityCredentials = servicePrincipal.FederatedIdentityCredentials,
            HomeRealmDiscoveryPolicies = servicePrincipal.HomeRealmDiscoveryPolicies,
            MemberOf = servicePrincipal.MemberOf,
            Oauth2PermissionGrants = servicePrincipal.Oauth2PermissionGrants,
            OwnedObjects = servicePrincipal.OwnedObjects,
            Owners = servicePrincipal.Owners,
            TokenIssuancePolicies = servicePrincipal.TokenIssuancePolicies,
            TokenLifetimePolicies = servicePrincipal.TokenLifetimePolicies,
            TransitiveMemberOf = servicePrincipal.TransitiveMemberOf
        };
    }
}
