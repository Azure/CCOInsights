namespace CCOInsights.SubscriptionManager.Functions.Operations.SecurityTasks;

public class SecurityTask(string id, string tenantId, string subscriptionId, string executionId,
        SecurityTaskResponse value)
    : BaseEntity<SecurityTaskResponse>(id, tenantId, subscriptionId, executionId, value)
{
    public static SecurityTask From(string tenantId, string subscriptionId, string executionId, SecurityTaskResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new SecurityTask(id, tenantId, subscriptionId, executionId, response);
    }
}