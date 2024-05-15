using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Subscriptions;

public class SubscriptionsResponse : AzureResponse
{
    [JsonProperty("authorizationSource")]
    public string AuthorizationSource { get; set; }

    [JsonProperty("displayName")]
    public string DisplayName { get; set; }

    [JsonProperty("managedByTenants")]
    public List<AzureSubscriptionManagedByTenant> ManagedByTenants { get; set; }

    [JsonProperty("state")]
    public string State { get; set; }

    [JsonProperty("subscriptionId")]
    public string SubscriptionId { get; set; }

    [JsonProperty("subscriptionPolicies")]
    public AzureSubscriptionPolicies SubscriptionPolicies { get; set; }

    [JsonProperty("tags")]
    public object Tags { get; set; }

    [JsonProperty("tenantId")]
    public string TenantId { get; set; }
}

public class AzureSubscriptionManagedByTenant
{
    [JsonProperty("tenantId")]
    public string TenantId { get; set; }
}

public class AzureSubscriptionPolicies
{
    [JsonProperty("locationPlacementId")]
    public string LocationPlacementId { get; set; }

    [JsonProperty("quotaId")]
    public string QuotaId { get; set; }

    [JsonProperty("spendingLimit")]
    public string SpendingLimit { get; set; }
}
