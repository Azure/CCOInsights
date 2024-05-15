using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Blueprint;

public class BlueprintResponse : AzureResponse
{
    [JsonProperty("description")]
    public string Description { get; set; }

    [JsonProperty("displayName")]
    public string DisplayName { get; set; }

    [JsonProperty("properties")]
    public AzureBlueprintProperties Properties { get; set; }
}

public class AzureBlueprintProperties
{
    [JsonProperty("layout")]
    public string Layout { get; set; }

    [JsonProperty("properties")]
    public IDictionary<string, AzureBlueprintParameterDefinition> Properties { get; set; } = new Dictionary<string, AzureBlueprintParameterDefinition>();

    [JsonProperty("resourceGroups")]
    public IDictionary<string, AzureBlueprintResourceGroupDefinition> ResourceGroups { get; set; } = new Dictionary<string, AzureBlueprintResourceGroupDefinition>();

    [JsonProperty("status")]
    public AzureBlueprintStatus Status { get; set; }

    [JsonProperty("targetScope")]
    public string TargetScope { get; set; }

    [JsonProperty("versions")]
    public string Versions { get; set; }
}

public class AzureBlueprintParameterDefinition
{
    [JsonProperty("allowedValues")]
    public ICollection<string> AllowedValues { get; set; } = new List<string>();

    [JsonProperty("defaultValue")]
    public object DefaultValue { get; set; }

    [JsonProperty("metadata")]
    public AzureBlueprintParameterDefinitionMetadata Metadata { get; set; }

    [JsonProperty("type")]
    public string Type { get; set; }
}

public class AzureBlueprintParameterDefinitionMetadata
{
    [JsonProperty("description")]
    public string Description { get; set; }

    [JsonProperty("displayName")]
    public string DisplayName { get; set; }

    [JsonProperty("strongType")]
    public string StrongType { get; set; }
}

public class AzureBlueprintResourceGroupDefinition
{
    [JsonProperty("dependsOn")]
    public ICollection<string> DependsOn { get; set; } = new List<string>();

    [JsonProperty("location")]
    public string Location { get; set; }

    [JsonProperty("metadata")]
    public AzureBlueprintResourceGroupDefinitionMetadata Metadata { get; set; }
}

public class AzureBlueprintResourceGroupDefinitionMetadata
{
    [JsonProperty("description")]
    public string Description { get; set; }

    [JsonProperty("displayName")]
    public string DisplayName { get; set; }

    [JsonProperty("strongType")]
    public string StrongType { get; set; }
}

public class AzureBlueprintStatus
{
    [JsonProperty("lastModified")]
    public string LastModified { get; set; }

    [JsonProperty("timeCreated")]
    public string TimeCreated { get; set; }
}
