using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderSecureScoreControlDefinition;

public class DefenderSecureScoreControlDefinitionResponseList
{
    public IEnumerable<DefenderSecureScoreControlDefinitionResponse> Value { get; set; }
}

public class DefenderSecureScoreControlDefinitionResponse : AzureResponse
{
    [JsonProperty("properties")]
    public DefenderSecureScoreControlDefinitionProperties Properties { get; set; }
}

public class DefenderSecureScoreControlDefinitionProperties
{
    [JsonProperty("assessmentDefinitions")]
    public List<DefenderSecureScoreControlDefinitionResourceLink> AssessmentDefinitions { get; set; }

    [JsonProperty("description")]
    public string Description { get; set; }

    [JsonProperty("displayName")]
    public string DisplayName { get; set; }

    [JsonProperty("maxScore")]
    public int MaxScore { get; set; }

    [JsonProperty("source")]
    public DefenderSecureScoreControlDefinitionSource Source { get; set; }
}

public class DefenderSecureScoreControlDefinitionResourceLink
{
    [JsonProperty("id")]
    public string Id { get; set; }
}

public class DefenderSecureScoreControlDefinitionSource
{
    [JsonProperty("sourceType")]
    public string SourceType { get; set; }
}
