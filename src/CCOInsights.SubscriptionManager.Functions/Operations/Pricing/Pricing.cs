namespace CCOInsights.SubscriptionManager.Functions.Operations.Pricing;

public class Pricing : BaseEntity<PricingResponse>
{
    private Pricing(string id, string tenantId, string subscriptionId, string executionId, PricingResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static Pricing From(string tenantId, string subscriptionId, string executionId, PricingResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new Pricing(id, tenantId, subscriptionId, executionId, response);
    }
}
