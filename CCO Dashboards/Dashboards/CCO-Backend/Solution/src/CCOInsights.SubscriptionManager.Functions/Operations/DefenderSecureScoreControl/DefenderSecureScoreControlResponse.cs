using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderSecureScoreControl;

[GeneratedProvider("/providers/Microsoft.Security/secureScoreControls?api-version=2020-01-01")]
public class DefenderSecureScoreControlResponse : AzureResponse
{
    [JsonProperty("properties")]
    public DefenderSecureScoreControlProperties Properties { get; set; }
}

public class DefenderSecureScoreControlProperties
{
    [JsonProperty("displayName")]
    public string DisplayName { get; set; }

    [JsonProperty("healthyResourceCount")]
    public long HealthyResourceCount { get; set; }

    [JsonProperty("unhealthyResourceCount")]
    public long UnhealthyResourceCount { get; set; }

    [JsonProperty("notApplicableResourceCount")]
    public long NotApplicableResourceCount { get; set; }

    [JsonProperty("score")]
    public DefenderSecureScoreControlScore Score { get; set; }

    [JsonProperty("weight")]
    public long Weight { get; set; }
}

public class DefenderSecureScoreControlScore
{
    [JsonProperty("max")]
    public long Max { get; set; }

    [JsonProperty("current")]
    public double Current { get; set; }

    [JsonProperty("percentage")]
    public double Percentage { get; set; }
}