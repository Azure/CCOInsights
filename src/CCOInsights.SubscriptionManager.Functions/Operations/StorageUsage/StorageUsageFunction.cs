using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.StorageUsage;

[OperationDescriptor(DashboardType.Infrastructure, nameof(StorageUsageFunction))]
public class StorageUsageFunction(IAuthenticated authenticatedResourceManager, IStorageUsageUpdater updater)
    : IOperation
{
    [Function(nameof(StorageUsageFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }

}
