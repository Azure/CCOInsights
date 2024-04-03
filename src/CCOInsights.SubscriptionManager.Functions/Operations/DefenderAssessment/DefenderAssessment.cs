namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderAssessment;

public class DefenderAssessment : BaseEntity<DefenderAssessmentResponse>
{
    private DefenderAssessment(string id, string tenantId, string subscriptionId, string executionId, DefenderAssessmentResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static DefenderAssessment From(string tenantId, string subscriptionId, string executionId, DefenderAssessmentResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new DefenderAssessment(id, tenantId, subscriptionId, executionId, response);
    }
}