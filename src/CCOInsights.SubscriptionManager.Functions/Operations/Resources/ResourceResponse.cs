using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Resources;

[GeneratedProvider("/resources?api-version=2021-04-01")]
public class ResourceResponse : AzureResponse
{
    [JsonProperty("changedTime")]
    public string ChangedTime { get; set; }
    [JsonProperty("createdTime")]
    public string CreatedTime { get; set; }
    [JsonProperty("extendedLocation")]
    public ResourceExtendedLocation ExtendedLocation { get; set; }
    [JsonProperty("identity")]
    public ResourceIdentity Identity { get; set; }
    [JsonProperty("kind")]
    public string Kind { get; set; }
    [JsonProperty("location")]
    public string Location { get; set; }
    [JsonProperty("managedBy")]
    public string ManagedBy { get; set; }
    [JsonProperty("plan")]
    public ResourcePlan Plan { get; set; }
    [JsonProperty("properties")]
    public object Properties { get; set; }
    [JsonProperty("provisioningState")]
    public string ProvisioningState { get; set; }
    [JsonProperty("sku")]
    public ResourceSku Sku { get; set; }
    [JsonProperty("tags")]
    public object Tags { get; set; }
}

public class ResourceExtendedLocation
{
    [JsonProperty("name")]
    public string Name { get; set; }
    [JsonProperty("type")]
    public string Type { get; set; }
}

public class ResourceIdentity
{
    [JsonProperty("principalId")]
    public string PrincipalId { get; set; }
    [JsonProperty("tenantId")]
    public string TenantId { get; set; }
    [JsonProperty("type")]
    public string Type { get; set; }
    [JsonProperty("userAssignedIdentities")]
    public object UserAssignedIdentities { get; set; } = new();
}

public class ResourcePlan
{
    [JsonProperty("name")]
    public string Name { get; set; }
    [JsonProperty("product")]
    public string Product { get; set; }
    [JsonProperty("promotionCode")]
    public string PromotionCode { get; set; }
    [JsonProperty("publisher")]
    public string Publisher { get; set; }
    [JsonProperty("version")]
    public string Version { get; set; }
}

public class ResourceSku
{
    [JsonProperty("capacity")]
    public int Capacity { get; set; }
    [JsonProperty("family")]
    public string Family { get; set; }
    [JsonProperty("model")]
    public string Model { get; set; }
    [JsonProperty("name")]
    public string Name { get; set; }
    [JsonProperty("size")]
    public string Size { get; set; }
    [JsonProperty("tier")]
    public string Tier { get; set; }
}