using CCOInsights.SubscriptionManager.Functions.Operations.Blueprint;
using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintPublished;

public class BlueprintPublishedResponse : AzureResponse
{
    [JsonProperty("description")]
    public string Description { get; set; }

    [JsonProperty("displayName")]
    public string DisplayName { get; set; }

    [JsonProperty("properties")]
    public AzureBlueprintPublishedProperties Properties { get; set; }
}

public class AzureBlueprintPublishedProperties
{
    [JsonProperty("blueprintName")]
    public string BlueprintName { get; set; }

    [JsonProperty("changeNotes")]
    public string ChangeNotes { get; set; }

    [JsonProperty("parameters")]
    public IDictionary<string, AzureBlueprintParameterDefinition> Parameters { get; set; } = new Dictionary<string, AzureBlueprintParameterDefinition>();

    [JsonProperty("resourceGroups")]
    public IDictionary<string, AzureBlueprintResourceGroupDefinition> ResourceGroups { get; set; } = new Dictionary<string, AzureBlueprintResourceGroupDefinition>();

    [JsonProperty("status")]
    public AzureBlueprintStatus Status { get; set; }

    [JsonProperty("targetScope")]
    public string TargetScope { get; set; }
}
