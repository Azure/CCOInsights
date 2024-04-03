namespace CCOInsights.SubscriptionManager.Functions.Operations.Blueprint;

public class Blueprint : BaseEntity<BlueprintResponse>
{
    private Blueprint(string id, string tenantId, string subscriptionId, string executionId, BlueprintResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static Blueprint From(string tenantId, string subscriptionId, string executionId, BlueprintResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new Blueprint(id, tenantId, subscriptionId, executionId, response);
    }
}