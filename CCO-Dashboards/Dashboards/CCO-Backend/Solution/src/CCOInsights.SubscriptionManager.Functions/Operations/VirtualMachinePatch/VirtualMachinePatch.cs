namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachinePatch;

public class VirtualMachinePatch : BaseEntity<VirtualMachinePatchResponse>
{
    private VirtualMachinePatch(string id, string tenantId, string subscriptionId, string executionId, VirtualMachinePatchResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static VirtualMachinePatch From(string tenantId, string subscriptionId, string executionId, VirtualMachinePatchResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new VirtualMachinePatch(id, tenantId, subscriptionId, executionId, response);
    }
}