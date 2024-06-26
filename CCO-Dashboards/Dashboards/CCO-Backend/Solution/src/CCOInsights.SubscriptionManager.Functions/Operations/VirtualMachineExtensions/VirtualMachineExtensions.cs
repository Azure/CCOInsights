namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachineExtensions;

public class VirtualMachineExtensions : BaseEntity<VirtualMachineExtensionsResponse>
{
    private VirtualMachineExtensions(string id, string tenantId, string subscriptionId, string executionId, VirtualMachineExtensionsResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static VirtualMachineExtensions From(string tenantId, string subscriptionId, string executionId, VirtualMachineExtensionsResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new VirtualMachineExtensions(id, tenantId, subscriptionId, executionId, response);
    }
}