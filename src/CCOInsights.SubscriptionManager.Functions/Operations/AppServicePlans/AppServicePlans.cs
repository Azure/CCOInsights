namespace CCOInsights.SubscriptionManager.Functions.Operations.AppServicePlans;

public class AppServicePlans : BaseEntity<AppServicePlansResponse>
{
    private AppServicePlans(string id, string tenantId, string subscriptionId, string executionId, AppServicePlansResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static AppServicePlans From(string tenantId, string subscriptionId, string executionId, AppServicePlansResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new AppServicePlans(id, tenantId, subscriptionId, executionId, response);
    }
}