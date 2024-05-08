namespace CCOInsights.SubscriptionManager.Functions.Operations.Disks;

public class Disks : BaseEntity<DisksResponse>
{
    private Disks(string id, string tenantId, string subscriptionId, string executionId, DisksResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static Disks From(string tenantId, string subscriptionId, string executionId, DisksResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new Disks(id, tenantId, subscriptionId, executionId, response);
    }
}