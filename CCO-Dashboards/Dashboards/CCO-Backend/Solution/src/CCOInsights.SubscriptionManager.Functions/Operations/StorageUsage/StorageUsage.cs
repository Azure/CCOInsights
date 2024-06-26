namespace CCOInsights.SubscriptionManager.Functions.Operations.StorageUsage;

public class StorageUsage : BaseEntity<StorageUsageResponse>
{
    private StorageUsage(string id, string tenantId, string subscriptionId, string executionId, StorageUsageResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static StorageUsage From(string tenantId, string subscriptionId, string executionId, StorageUsageResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + subscriptionId + response.Name.Value);
        var id = Convert.ToBase64String(plainTextBytes);

        return new StorageUsage(id, tenantId, subscriptionId, executionId, response);
    }
}
