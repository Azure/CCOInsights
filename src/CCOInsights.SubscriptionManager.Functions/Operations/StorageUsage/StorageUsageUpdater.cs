using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.StorageUsage;

public interface IStorageUsageUpdater : IUpdater { }
public class StorageUsageUpdater(IStorage storage, ILogger<StorageUsageUpdater> logger, IStorageUsageProvider provider)
    : Updater<StorageUsageResponse, StorageUsage>(storage, logger, provider), IStorageUsageUpdater
{
    protected override StorageUsage Map(string executionId, ISubscription subscription, StorageUsageResponse response) =>
        StorageUsage.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}
