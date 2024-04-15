using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderAssessment;

[GeneratedProvider("/providers/Microsoft.Security/assessments?api-version=2020-01-01")]
public class DefenderAssessmentResponse : AzureResponse
{
    [JsonProperty("properties")]
    public DefenderAssessmentProperties Properties { get; set; }
}

public class DefenderAssessmentProperties
{
    [JsonProperty("resourceDetails")]
    public DefenderAssessmentResourceDetails ResourceDetails { get; set; }

    [JsonProperty("displayName")]
    public string DisplayName { get; set; }

    [JsonProperty("status")]
    public DefenderAssessmentStatus Status { get; set; }

    [JsonProperty("additionalData", NullValueHandling = NullValueHandling.Ignore)]
    public DefenderAssessmentAdditionalData AdditionalData { get; set; }
}

public class DefenderAssessmentAdditionalData
{
    [JsonProperty("linkedWorkspaceId")]
    public string LinkedWorkspaceId { get; set; }
}

public class DefenderAssessmentResourceDetails
{
    [JsonProperty("source")]
    public string Source { get; set; }

    [JsonProperty("id")]
    public string Id { get; set; }
}

public class DefenderAssessmentStatus
{
    [JsonProperty("code")]
    public string Code { get; set; }

    [JsonProperty("cause", NullValueHandling = NullValueHandling.Ignore)]
    public string Cause { get; set; }

    [JsonProperty("description", NullValueHandling = NullValueHandling.Ignore)]
    public string Description { get; set; }
}