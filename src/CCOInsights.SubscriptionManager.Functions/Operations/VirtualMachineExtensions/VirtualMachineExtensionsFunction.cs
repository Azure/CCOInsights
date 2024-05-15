using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachineExtensions;

[OperationDescriptor(DashboardType.Infrastructure, nameof(VirtualMachineExtensionsFunction))]
public class VirtualMachineExtensionsFunction(IAuthenticated authenticatedResourceManager,
        IVirtualMachineExtensionUpdater updater)
    : IOperation
{
    [Function(nameof(VirtualMachineExtensionsFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
