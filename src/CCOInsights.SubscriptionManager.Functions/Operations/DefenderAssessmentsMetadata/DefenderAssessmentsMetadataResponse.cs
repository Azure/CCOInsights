using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderAssessmentsMetadata;

[GeneratedProvider("/providers/Microsoft.Security/assessmentMetadata?api-version=2020-01-01")]
public class DefenderAssessmentsMetadataResponse : AzureResponse
{
    [JsonProperty("properties")]
    public DefenderAssessmentMetadataProperties Properties { get; set; }
}

public class DefenderAssessmentMetadataProperties
{
    [JsonProperty("displayName")]
    public string DisplayName { get; set; }

    [JsonProperty("policyDefinitionId")]
    public string PolicyDefinitionId { get; set; }

    [JsonProperty("description")]
    public string Description { get; set; }

    [JsonProperty("remediationDescription")]
    public string RemediationDescription { get; set; }

    [JsonProperty("categories")]
    public string[] Categories { get; set; }

    [JsonProperty("severity")]
    public string Severity { get; set; }

    [JsonProperty("userImpact")]
    public string UserImpact { get; set; }

    [JsonProperty("implementationEffort")]
    public string ImplementationEffort { get; set; }

    [JsonProperty("threats")]
    public string[] Threats { get; set; }

    [JsonProperty("assessmentType")]
    public string AssessmentType { get; set; }

    [JsonProperty("preview", NullValueHandling = NullValueHandling.Ignore)]
    public bool? Preview { get; set; }
}