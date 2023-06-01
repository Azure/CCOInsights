namespace CCOInsights.SubscriptionManager.Functions.Operations.AdvisorScore
{
    public class AdvisorScore : BaseEntity<AdvisorScoreResponse>
    {
        public AdvisorScore(string id, string tenantId, string subscriptionId, string executionId, AdvisorScoreResponse value) : base(id, tenantId, subscriptionId, executionId, value)
        {
        }

        public static AdvisorScore From(string tenantId, string subscriptionId, string executionId, AdvisorScoreResponse response)
        {
            var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
            var id = Convert.ToBase64String(plainTextBytes);

            return new AdvisorScore(id, tenantId, subscriptionId, executionId, response);
        }
    }
}
