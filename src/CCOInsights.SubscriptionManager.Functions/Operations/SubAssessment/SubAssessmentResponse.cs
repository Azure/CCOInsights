using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.SubAssessment;

public class SubAssessmentResponse : AzureResponse
{
    [JsonProperty("properties")]
    public SubAssessmentsProperties Properties { get; set; }
}

public partial class SubAssessmentsProperties
{
    [JsonProperty("displayName")]
    public string DisplayName { get; set; }

    [JsonProperty("id")]
    public string Id { get; set; }

    [JsonProperty("status")]
    public Status Status { get; set; }

    [JsonProperty("resourceDetails")]
    public ResourceDetails ResourceDetails { get; set; }

    [JsonProperty("remediation")]
    public string Remediation { get; set; }

    [JsonProperty("impact")]
    public string Impact { get; set; }

    [JsonProperty("category")]
    public string Category { get; set; }

    [JsonProperty("description")]
    public string Description { get; set; }

    [JsonProperty("timeGenerated")]
    public DateTimeOffset TimeGenerated { get; set; }

    [JsonProperty("additionalData")]
    public AdditionalData AdditionalData { get; set; }
}

public partial class AdditionalData
{
    [JsonProperty("assessedResourceType")]
    public string AssessedResourceType { get; set; }

    [JsonProperty("imageDigest", NullValueHandling = NullValueHandling.Ignore)]
    public string ImageDigest { get; set; }

    [JsonProperty("repositoryName", NullValueHandling = NullValueHandling.Ignore)]
    public string RepositoryName { get; set; }

    [JsonProperty("type")]
    public string Type { get; set; }

    [JsonProperty("patchable", NullValueHandling = NullValueHandling.Ignore)]
    public bool? Patchable { get; set; }

    [JsonProperty("cve", NullValueHandling = NullValueHandling.Ignore)]
    public Cve[] Cve { get; set; }

    [JsonProperty("publishedTime", NullValueHandling = NullValueHandling.Ignore)]
    public DateTimeOffset? PublishedTime { get; set; }

    [JsonProperty("vendorReferences", NullValueHandling = NullValueHandling.Ignore)]
    public Cve[] VendorReferences { get; set; }

    [JsonProperty("query", NullValueHandling = NullValueHandling.Ignore)]
    public string Query { get; set; }

    [JsonProperty("benchmarks", NullValueHandling = NullValueHandling.Ignore)]
    public object[] Benchmarks { get; set; }
}

public partial class Cve
{
    [JsonProperty("title")]
    public string Title { get; set; }

    [JsonProperty("link")]
    public string Link { get; set; }
}

public partial class ResourceDetails
{
    [JsonProperty("source")]
    public string Source { get; set; }

    [JsonProperty("id")]
    public string Id { get; set; }
}

public partial class Status
{
    [JsonProperty("code")]
    public string Code { get; set; }

    [JsonProperty("cause")]
    public string Cause { get; set; }

    [JsonProperty("severity")]
    public string Severity { get; set; }

    [JsonProperty("description", NullValueHandling = NullValueHandling.Ignore)]
    public string Description { get; set; }
}