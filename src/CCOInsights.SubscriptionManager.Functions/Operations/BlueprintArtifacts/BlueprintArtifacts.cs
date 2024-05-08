namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintArtifacts;

public class BlueprintArtifacts : BaseEntity<BlueprintArtifactsResponse>
{
    private BlueprintArtifacts(string id, string tenantId, string subscriptionId, string executionId, BlueprintArtifactsResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static BlueprintArtifacts From(string tenantId, string subscriptionId, string executionId, BlueprintArtifactsResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new BlueprintArtifacts(id, tenantId, subscriptionId, executionId, response);
    }
}