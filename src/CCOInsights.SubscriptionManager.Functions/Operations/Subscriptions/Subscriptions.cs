namespace CCOInsights.SubscriptionManager.Functions.Operations.Subscriptions;

public class Subscriptions : BaseEntity<SubscriptionsResponse>
{
    private Subscriptions(string id, string tenantId, string subscriptionId, string executionId, SubscriptionsResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static Subscriptions From(string executionId, SubscriptionsResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new Subscriptions(id, response.TenantId, response.SubscriptionId, executionId, response);
    }
}