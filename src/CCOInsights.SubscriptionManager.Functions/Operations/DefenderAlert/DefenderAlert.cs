namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderAlert;

public class DefenderAlert : BaseEntity<DefenderAlertResponse>
{
    private DefenderAlert(string id, string tenantId, string subscriptionId, string executionId, DefenderAlertResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static DefenderAlert From(string tenantId, string subscriptionId, string executionId, DefenderAlertResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new DefenderAlert(id, tenantId, subscriptionId, executionId, response);
    }
}