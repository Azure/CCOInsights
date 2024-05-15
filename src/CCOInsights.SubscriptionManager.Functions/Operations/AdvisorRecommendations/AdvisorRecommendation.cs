namespace CCOInsights.SubscriptionManager.Functions.Operations.AdvisorRecommendations;

public class AdvisorRecommendation(string id, string tenantId, string subscriptionId, string executionId,
        AdvisorRecommendationResponse value)
    : BaseEntity<AdvisorRecommendationResponse>(id, tenantId, subscriptionId, executionId, value)
{
    public static AdvisorRecommendation From(string tenantId, string subscriptionId, string executionId, AdvisorRecommendationResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new AdvisorRecommendation(id, tenantId, subscriptionId, executionId, response);
    }
}
