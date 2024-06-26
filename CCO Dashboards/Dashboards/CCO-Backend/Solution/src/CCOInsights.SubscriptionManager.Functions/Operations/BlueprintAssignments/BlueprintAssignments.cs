namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintAssignments;

public class BlueprintAssignments : BaseEntity<BlueprintAssignmentsResponse>
{
    private BlueprintAssignments(string id, string tenantId, string subscriptionId, string executionId, BlueprintAssignmentsResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static BlueprintAssignments From(string tenantId, string subscriptionId, string executionId, BlueprintAssignmentsResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new BlueprintAssignments(id, tenantId, subscriptionId, executionId, response);
    }
}