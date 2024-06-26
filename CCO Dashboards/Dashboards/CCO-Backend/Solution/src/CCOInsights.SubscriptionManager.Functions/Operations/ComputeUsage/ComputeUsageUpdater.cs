using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.ComputeUsage;

public interface IComputeUsageUpdater : IUpdater { }
public class ComputeUsageUpdater(IStorage storage, ILogger<ComputeUsageUpdater> logger, IComputeUsageProvider provider)
    : Updater<ComputeUsageResponse, ComputeUsage>(storage, logger, provider), IComputeUsageUpdater
{
    protected override ComputeUsage Map(string executionId, ISubscription subscription, ComputeUsageResponse response) =>
        ComputeUsage.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}
