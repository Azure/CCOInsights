namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintPublished;

public class BlueprintPublished : BaseEntity<BlueprintPublishedResponse>
{
    private BlueprintPublished(string id, string tenantId, string subscriptionId, string executionId, BlueprintPublishedResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static BlueprintPublished From(string tenantId, string subscriptionId, string executionId, BlueprintPublishedResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new BlueprintPublished(id, tenantId, subscriptionId, executionId, response);
    }
}