using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualNetworks;

[OperationDescriptor(DashboardType.Infrastructure, nameof(VirtualNetworksFunction))]
public class VirtualNetworksFunction(IAuthenticated authenticatedResourceManager, IVirtualNetworksUpdater updater)
    : IOperation
{
    [Function(nameof(VirtualNetworksFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
