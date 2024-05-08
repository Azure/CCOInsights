namespace CCOInsights.SubscriptionManager.Functions.Operations.PublicIPs;

public class PublicIPs : BaseEntity<PublicIPsResponse>
{
    private PublicIPs(string id, string tenantId, string subscriptionId, string executionId, PublicIPsResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static PublicIPs From(string tenantId, string subscriptionId, string executionId, PublicIPsResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new PublicIPs(id, tenantId, subscriptionId, executionId, response);
    }
}
