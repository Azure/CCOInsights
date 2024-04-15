using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Entity;

public class EntityResponse : AzureResponse
{
    [JsonProperty("properties")]
    public EntityProperties Properties { get; set; }
}

public class EntityProperties
{
    [JsonProperty("tenantId")]
    public string TenantId { get; set; }

    [JsonProperty("displayName")]
    public string DisplayName { get; set; }

    [JsonProperty("parent")]
    public Parent Parent { get; set; }

    [JsonProperty("permissions")]
    public string Permissions { get; set; }

    [JsonProperty("inheritedPermissions")]
    public string InheritedPermissions { get; set; }

    [JsonProperty("parentDisplayNameChain")]
    public string[] ParentDisplayNameChain { get; set; }

    [JsonProperty("parentNameChain")]
    public string[] ParentNameChain { get; set; }

    [JsonProperty("numberOfDescendants")]
    public long NumberOfDescendants { get; set; }

    [JsonProperty("numberOfChildren")]
    public long NumberOfChildren { get; set; }

    [JsonProperty("numberOfChildGroups")]
    public long NumberOfChildGroups { get; set; }
}

public class Parent
{
    [JsonProperty("id")]
    public string Id { get; set; }
}
