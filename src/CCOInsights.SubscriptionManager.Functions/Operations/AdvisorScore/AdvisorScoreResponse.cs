namespace CCOInsights.SubscriptionManager.Functions.Operations.AdvisorScore;

[GeneratedProvider("/providers/Microsoft.Advisor/advisorScore?api-version=2020-07-01-preview")]
public class AdvisorScoreResponse : AzureResponse
{
    public string Same { get; set; }
    public AdvisorScoreProperties Properties { get; set; }
}

public class AdvisorScoreProperties
{
    public Lastrefreshedscore lastRefreshedScore { get; set; }
    public Timesery[] timeSeries { get; set; }
}

public class Lastrefreshedscore
{
    public DateTime date { get; set; }
    public float score { get; set; }
    public float consumptionUnits { get; set; }
    public int impactedResourceCount { get; set; }
    public float potentialScoreIncrease { get; set; }
    public int categoryCount { get; set; }
}

public class Timesery
{
    public string aggregationLevel { get; set; }
    public Scorehistory[] scoreHistory { get; set; }
}

public class Scorehistory
{
    public DateTime date { get; set; }
    public float score { get; set; }
    public float consumptionUnits { get; set; }
    public int impactedResourceCount { get; set; }
    public float potentialScoreIncrease { get; set; }
}