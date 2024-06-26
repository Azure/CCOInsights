namespace CCOInsights.SubscriptionManager.Functions.Operations.AdvisorScore;

public class AdvisorScore(string id, string tenantId, string subscriptionId, string executionId,
        AdvisorScoreResponse value)
    : BaseEntity<AdvisorScoreResponse>(id, tenantId, subscriptionId, executionId, value)
{
    public static AdvisorScore From(string tenantId, string subscriptionId, string executionId, AdvisorScoreResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new AdvisorScore(id, tenantId, subscriptionId, executionId, response);
    }
}
