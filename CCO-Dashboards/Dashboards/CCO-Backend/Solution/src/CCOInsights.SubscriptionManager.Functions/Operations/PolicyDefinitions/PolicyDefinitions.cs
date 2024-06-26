namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicyDefinitions;

public class PolicyDefinitions : BaseEntity<PolicyDefinitionResponse>
{
    private PolicyDefinitions(string id, string tenantId, string subscriptionId, string executionId, PolicyDefinitionResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static PolicyDefinitions From(string tenantId, string subscriptionId, string executionId, PolicyDefinitionResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new PolicyDefinitions(id, tenantId, subscriptionId, executionId, response);
    }
}