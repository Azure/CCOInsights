namespace CCOInsights.SubscriptionManager.Functions.Operations.Resources;

public class Resource : BaseEntity<ResourceResponse>
{
    private Resource(string id, string tenantId, string subscriptionId, string executionId, ResourceResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static Resource From(string tenantId, string subscriptionId, string executionId, ResourceResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new Resource(id, tenantId, subscriptionId, executionId, response);
    }
}