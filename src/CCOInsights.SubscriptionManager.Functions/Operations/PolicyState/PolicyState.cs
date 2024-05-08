namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicyState;

public class PolicyState : BaseEntity<AzurePolicyStateResponseValue>
{
    private PolicyState(string id, string tenantId, string subscriptionId, string executionId, AzurePolicyStateResponseValue value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static PolicyState From(string tenantId, string subscriptionId, string executionId, AzurePolicyStateResponseValue response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.PolicyDefinitionId + response.ResourceId);
        var id = Convert.ToBase64String(plainTextBytes);

        return new PolicyState(id, tenantId, subscriptionId, executionId, response);
    }
}