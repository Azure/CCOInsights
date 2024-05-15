using System.Threading;
using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.StorageUsage;

[OperationDescriptor(DashboardType.Infrastructure, nameof(StorageUsageFunction))]
public class StorageUsageFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IStorageUsageUpdater _updater;

    public StorageUsageFunction(IAuthenticated authenticatedResourceManager, IStorageUsageUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(StorageUsageFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }

}
