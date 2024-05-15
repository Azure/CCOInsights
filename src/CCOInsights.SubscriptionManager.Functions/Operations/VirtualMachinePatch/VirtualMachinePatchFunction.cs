using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachinePatch;

[OperationDescriptor(DashboardType.Infrastructure, nameof(VirtualMachinePatchFunction))]
public class VirtualMachinePatchFunction(IAuthenticated authenticatedResourceManager,
        IVirtualMachinePatchUpdater updater)
    : IOperation
{
    [Function(nameof(VirtualMachinePatchFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
                await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1
        );
    }
}
