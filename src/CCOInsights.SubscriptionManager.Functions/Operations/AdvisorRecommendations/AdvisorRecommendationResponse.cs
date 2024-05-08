using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.AdvisorRecommendations;

[GeneratedProvider("/providers/Microsoft.Advisor/recommendations?api-version=2020-01-01")]
public class AdvisorRecommendationResponse : AzureResponse
{
    [JsonProperty("properties")]
    public AdvisorRecommendationProperties Properties { get; set; }
}

public class AdvisorRecommendationProperties
{
    [JsonProperty("actions")]
    public object[] Actions { get; set; }

    [JsonProperty("category")]
    public string Category { get; set; }

    [JsonProperty("description")]
    public string Description { get; set; }

    [JsonProperty("exposedMetadataProperties")]
    public object ExposedMetadataProperties { get; set; }

    [JsonProperty("extendedProperties")]
    public object ExtendedProperties { get; set; }

    [JsonProperty("impact")]
    public string Impact { get; set; }

    [JsonProperty("impactedField")]
    public string ImpactedField { get; set; }

    [JsonProperty("impactedValue")]
    public string ImpactedValue { get; set; }

    [JsonProperty("label")]
    public string Label { get; set; }

    [JsonProperty("lastUpdated")]
    public string LastUpdated { get; set; }

    [JsonProperty("learnMoreLink")]
    public string LearnMoreLink { get; set; }

    [JsonProperty("metadata")]
    public object Metadata { get; set; }

    [JsonProperty("potentialBenefits")]
    public string PotentialBenefits { get; set; }

    [JsonProperty("recommendationTypeId")]
    public string RecommendationTypeId { get; set; }

    [JsonProperty("remediation")]
    public object Remediation { get; set; }

    [JsonProperty("resourceMetadata")]
    public AdvisorRecommendationResourceMetadata ResourceMetadata { get; set; }

    [JsonProperty("shortDescription")]
    public AdvisorRecommendationShortDescription ShortDescription { get; set; }

    [JsonProperty("suppressionIds")]
    public string[] SuppressionIds { get; set; }
}

public class AdvisorRecommendationResourceMetadata
{
    [JsonProperty("action")]
    public object Action { get; set; }

    [JsonProperty("plural")]
    public string Plural { get; set; }

    [JsonProperty("resourceId")]
    public string ResourceId { get; set; }

    [JsonProperty("singular")]
    public string Singular { get; set; }

    [JsonProperty("source")]
    public string Source { get; set; }
}

public class AdvisorRecommendationShortDescription
{
    [JsonProperty("problem")]
    public string Problem { get; set; }

    [JsonProperty("solution")]
    public string Solution { get; set; }
}