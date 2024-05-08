using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicySetDefinitions;

public class PolicySetDefinitionsResponse : AzureResponse
{
    [JsonProperty("properties")]
    public PolicySetDefinitionProperties Properties { get; set; }
}

public class PolicySetDefinitionProperties
{
    [JsonProperty("displayName")]
    public string DisplayName { get; set; }

    [JsonProperty("policyType", NullValueHandling = NullValueHandling.Ignore)]
    public string PolicyType { get; set; }

    [JsonProperty("description")]
    public string Description { get; set; }

    [JsonProperty("metadata")]
    public Metadata Metadata { get; set; }

    [JsonProperty("policyDefinitions")]
    public PolicyDefinition[] PolicyDefinitions { get; set; }
}

public class Metadata
{
    [JsonProperty("category")]
    public string Category { get; set; }
}

public class PolicyDefinition
{
    [JsonProperty("policyDefinitionId")]
    public string PolicyDefinitionId { get; set; }

    [JsonProperty("policyDefinitionReferenceId")]
    public string PolicyDefinitionReferenceId { get; set; }
}