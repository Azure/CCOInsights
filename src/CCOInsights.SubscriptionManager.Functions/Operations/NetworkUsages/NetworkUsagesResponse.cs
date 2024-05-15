namespace CCOInsights.SubscriptionManager.Functions.Operations.NetworkUsages;

public class NetworkUsagesName
{
    public string localizedValue { get; set; }
    public string value { get; set; }
}

public class NetworkUsagesResponseList
{
    public List<NetworkUsagesResponse> value { get; set; }
}

public class NetworkUsagesResponse : IAzureResponse
{
    public string Id { get; set; }
    public int CurrentValue { get; set; }
    public long Limit { get; set; }
    public NetworkUsagesName Name { get; set; }
    public string unit { get; set; }
}
