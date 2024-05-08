using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicyState;

public class PolicyStateResponse
{
    [JsonProperty("@odata.nextLink")]
    public string OdataNextLink { get; set; }

    [JsonProperty("value")]
    public AzurePolicyStateResponseValue[] Value { get; set; }
}

public class AzurePolicyStateResponseValue : AzureResponse
{
    [JsonProperty("@odata.id")]
    public object OdataId { get; set; }

    [JsonProperty("@odata.context")]
    public Uri OdataContext { get; set; }

    [JsonProperty("timestamp")]
    public DateTimeOffset Timestamp { get; set; }

    [JsonProperty("resourceId")]
    public string ResourceId { get; set; }

    [JsonProperty("policyAssignmentId")]
    public string PolicyAssignmentId { get; set; }

    [JsonProperty("policyDefinitionId")]
    public string PolicyDefinitionId { get; set; }

    [JsonProperty("effectiveParameters")]
    public object EffectiveParameters { get; set; }

    [JsonProperty("isCompliant")]
    public bool IsCompliant { get; set; }

    [JsonProperty("subscriptionId")]
    public Guid SubscriptionId { get; set; }

    [JsonProperty("resourceType")]
    public string ResourceType { get; set; }

    [JsonProperty("resourceLocation")]
    public string ResourceLocation { get; set; }

    [JsonProperty("resourceGroup")]
    public string ResourceGroup { get; set; }

    [JsonProperty("resourceTags")]
    public string ResourceTags { get; set; }

    [JsonProperty("policyAssignmentName")]
    public string PolicyAssignmentName { get; set; }

    [JsonProperty("policyAssignmentOwner")]
    public string PolicyAssignmentOwner { get; set; }

    [JsonProperty("policyAssignmentParameters")]
    public string PolicyAssignmentParameters { get; set; }

    [JsonProperty("policyAssignmentScope")]
    public string PolicyAssignmentScope { get; set; }

    [JsonProperty("policyDefinitionName")]
    public string PolicyDefinitionName { get; set; }

    [JsonProperty("policyDefinitionAction")]
    public string PolicyDefinitionAction { get; set; }

    [JsonProperty("policyDefinitionCategory")]
    public string PolicyDefinitionCategory { get; set; }

    [JsonProperty("policySetDefinitionId")]
    public string PolicySetDefinitionId { get; set; }

    [JsonProperty("policySetDefinitionName")]
    public string PolicySetDefinitionName { get; set; }

    [JsonProperty("policySetDefinitionOwner")]
    public object PolicySetDefinitionOwner { get; set; }

    [JsonProperty("policySetDefinitionCategory")]
    public object PolicySetDefinitionCategory { get; set; }

    [JsonProperty("policySetDefinitionParameters")]
    public object PolicySetDefinitionParameters { get; set; }

    [JsonProperty("managementGroupIds")]
    public string ManagementGroupIds { get; set; }

    [JsonProperty("policyDefinitionReferenceId")]
    public object PolicyDefinitionReferenceId { get; set; }

    [JsonProperty("complianceState")]
    public string ComplianceState { get; set; }

    [JsonProperty("policyDefinitionGroupNames")]
    public string[] PolicyDefinitionGroupNames { get; set; }

    [JsonProperty("policyDefinitionVersion")]
    public string PolicyDefinitionVersion { get; set; }

    [JsonProperty("policySetDefinitionVersion")]
    public string PolicySetDefinitionVersion { get; set; }

    [JsonProperty("policyAssignmentVersion")]
    public string PolicyAssignmentVersion { get; set; }
}