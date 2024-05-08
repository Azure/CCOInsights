namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualNetworks;

public class VirtualNetworks : BaseEntity<VirtualNetworksResponse>
{
    private VirtualNetworks(string id, string tenantId, string subscriptionId, string executionId, VirtualNetworksResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static VirtualNetworks From(string tenantId, string subscriptionId, string executionId, VirtualNetworksResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new VirtualNetworks(id, tenantId, subscriptionId, executionId, response);
    }
}