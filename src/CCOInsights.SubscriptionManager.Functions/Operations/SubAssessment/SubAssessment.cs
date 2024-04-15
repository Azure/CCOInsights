namespace CCOInsights.SubscriptionManager.Functions.Operations.SubAssessment;

public class SubAssessment : BaseEntity<SubAssessmentResponse>
{
    private SubAssessment(string id, string tenantId, string subscriptionId, string executionId, SubAssessmentResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static SubAssessment From(string tenantId, string subscriptionId, string executionId, SubAssessmentResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new SubAssessment(id, tenantId, subscriptionId, executionId, response);
    }
}