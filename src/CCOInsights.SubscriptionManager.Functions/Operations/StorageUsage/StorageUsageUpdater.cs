using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.StorageUsage;

public interface IStorageUsageUpdater : IUpdater { }
public class StorageUsageUpdater : Updater<StorageUsageResponse, StorageUsage>, IStorageUsageUpdater
{
    public StorageUsageUpdater(IStorage storage, ILogger<StorageUsageUpdater> logger, IStorageUsageProvider provider) : base(storage, logger, provider)
    {
    }

    protected override StorageUsage Map(string executionId, ISubscription subscription, StorageUsageResponse response) =>
        StorageUsage.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}
