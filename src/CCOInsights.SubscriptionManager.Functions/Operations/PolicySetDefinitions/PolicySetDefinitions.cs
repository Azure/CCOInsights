namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicySetDefinitions;

public class PolicySetDefinitions : BaseEntity<PolicySetDefinitionsResponse>
{
    private PolicySetDefinitions(string id, string tenantId, string subscriptionId, string executionId, PolicySetDefinitionsResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static PolicySetDefinitions From(string tenantId, string subscriptionId, string executionId, PolicySetDefinitionsResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new PolicySetDefinitions(id, tenantId, subscriptionId, executionId, response);
    }
}
