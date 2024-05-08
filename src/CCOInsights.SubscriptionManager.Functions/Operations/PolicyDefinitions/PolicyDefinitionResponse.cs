using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicyDefinitions;

public class PolicyDefinitionResponse : AzureResponse
{
    [JsonProperty("properties")]
    public PolicyDefinitionProperties Properties { get; set; }
}

public class PolicyDefinitionProperties
{
    [JsonProperty("mode")]
    public string Mode { get; set; }

    [JsonProperty("displayName")]
    public string DisplayName { get; set; }

    [JsonProperty("policyType")]
    public string PolicyType { get; set; }

    [JsonProperty("description")]
    public string Description { get; set; }

    [JsonProperty("metadata", NullValueHandling = NullValueHandling.Ignore)]
    public PropertiesMetadata Metadata { get; set; }
}

public class PropertiesMetadata
{
    [JsonProperty("category")]
    public string Category { get; set; }
}