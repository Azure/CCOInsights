namespace CCOInsights.SubscriptionManager.Functions.Operations.RoleDefinitions;

public class RoleDefinitions : BaseEntity<RoleDefinitionsResponse>
{
    private RoleDefinitions(string id, string tenantId, string subscriptionId, string executionId, RoleDefinitionsResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static RoleDefinitions From(string tenantId, string subscriptionId, string executionId, RoleDefinitionsResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new RoleDefinitions(id, tenantId, subscriptionId, executionId, response);
    }
}