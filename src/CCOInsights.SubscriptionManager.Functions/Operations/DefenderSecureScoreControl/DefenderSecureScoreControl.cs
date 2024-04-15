namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderSecureScoreControl;

public class DefenderSecureScoreControl : BaseEntity<DefenderSecureScoreControlResponse>
{
    private DefenderSecureScoreControl(string id, string tenantId, string subscriptionId, string executionId, DefenderSecureScoreControlResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static DefenderSecureScoreControl From(string tenantId, string subscriptionId, string executionId, DefenderSecureScoreControlResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new DefenderSecureScoreControl(id, tenantId, subscriptionId, executionId, response);
    }
}