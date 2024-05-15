using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachine;

[OperationDescriptor(DashboardType.Infrastructure, nameof(VirtualMachineFunction))]
public class VirtualMachineFunction(IAuthenticated authenticatedResourceManager, IVirtualMachineUpdater updater)
    : IOperation
{
    [Function(nameof(VirtualMachineFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
                await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1
        );
    }
}
