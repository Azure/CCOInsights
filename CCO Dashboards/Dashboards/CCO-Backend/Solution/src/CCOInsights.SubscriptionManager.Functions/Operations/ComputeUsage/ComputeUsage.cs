namespace CCOInsights.SubscriptionManager.Functions.Operations.ComputeUsage;

public class ComputeUsage : BaseEntity<ComputeUsageResponse>
{
    private ComputeUsage(string id, string tenantId, string subscriptionId, string executionId, ComputeUsageResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static ComputeUsage From(string tenantId, string subscriptionId, string executionId, ComputeUsageResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + subscriptionId + response.Name.Value);
        var id = Convert.ToBase64String(plainTextBytes);

        return new ComputeUsage(id, tenantId, subscriptionId, executionId, response);
    }
}
