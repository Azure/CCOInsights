using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Helpers;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
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

    [FunctionName(nameof(StorageUsageFunction))]
    public async Task Execute([ActivityTrigger] IDurableActivityContext context, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(context.InstanceId, subscription, cancellationToken), 1);
    }

}
