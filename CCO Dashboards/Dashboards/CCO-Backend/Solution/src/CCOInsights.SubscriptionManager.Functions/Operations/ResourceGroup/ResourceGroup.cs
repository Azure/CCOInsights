namespace CCOInsights.SubscriptionManager.Functions.Operations.ResourceGroup;

public class ResourceGroup : BaseEntity<ResourceGroupResponse>
{
    private ResourceGroup(string id, string tenantId, string subscriptionId, string executionId, ResourceGroupResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static ResourceGroup From(string tenantId, string subscriptionId, string executionId, ResourceGroupResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new ResourceGroup(id, tenantId, subscriptionId, executionId, response);
    }
}