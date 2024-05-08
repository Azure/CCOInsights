namespace CCOInsights.SubscriptionManager.Functions.Operations.NetworkUsages;

public class NetworkUsages : BaseEntity<NetworkUsagesResponse>
{
    private NetworkUsages(string id, string tenantId, string subscriptionId, string executionId, NetworkUsagesResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static NetworkUsages From(string tenantId, string subscriptionId, string executionId, NetworkUsagesResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new NetworkUsages(id, tenantId, subscriptionId, executionId, response);
    }
}