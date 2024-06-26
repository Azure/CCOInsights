namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachine;

public class VirtualMachine : BaseEntity<VirtualMachineResponse>
{
    private VirtualMachine(string id, string tenantId, string subscriptionId, string executionId, VirtualMachineResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static VirtualMachine From(string tenantId, string subscriptionId, string executionId, VirtualMachineResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new VirtualMachine(id, tenantId, subscriptionId, executionId, response);
    }
}