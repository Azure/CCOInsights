namespace CCOInsights.SubscriptionManager.Functions.Operations.Nic;

public class Nic : BaseEntity<NicResponse>
{
    private Nic(string id, string tenantId, string subscriptionId, string executionId, NicResponse azureNicResponse) : base(id, tenantId, subscriptionId, executionId, azureNicResponse)
    {
    }

    public static Nic From(string tenantId, string subscriptionId, string executionId, NicResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new Nic(id, tenantId, subscriptionId, executionId, response);
    }
}