using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.NetworkUsages;

[OperationDescriptor(DashboardType.Infrastructure, nameof(NetworkUsagesFunction))]
public class NetworkUsagesFunction(IAuthenticated authenticatedResourceManager, INetworkUsagesUpdater updater)
    : IOperation
{
    [Function(nameof(NetworkUsagesFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
