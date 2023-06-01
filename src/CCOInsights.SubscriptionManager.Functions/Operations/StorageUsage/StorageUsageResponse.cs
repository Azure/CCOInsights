namespace CCOInsights.SubscriptionManager.Functions.Operations.StorageUsage;

public class StorageUsageResponse : IAzureResponse
{
    public StorageUsageName Name { get; set; }
    public string Unit { get; set; }
    public int CurrentValue { get; set; }
    public int Limit { get; set; }
    public string Id { get; set; }
}

public class StorageUsageName
{
    public string Value { get; set; }
    public string LocalizedValue { get; set; }
}
