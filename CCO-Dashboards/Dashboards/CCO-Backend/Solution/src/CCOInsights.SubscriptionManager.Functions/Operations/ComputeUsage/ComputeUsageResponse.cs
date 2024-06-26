namespace CCOInsights.SubscriptionManager.Functions.Operations.ComputeUsage;

public class ComputeUsageResponse : IAzureResponse
{
    public ComputeUsageName Name { get; set; }
    public string Unit { get; set; }
    public int CurrentValue { get; set; }
    public int Limit { get; set; }
    public string Id { get; set; }
}

public class ComputeUsageName
{
    public string Value { get; set; }
    public string LocalizedValue { get; set; }
}
