using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintPublished;

public interface IBlueprintPublishedUpdater : IUpdater { }
public class BlueprintPublishedUpdater(IStorage storage, ILogger<BlueprintPublishedUpdater> logger,
        IBlueprintPublishedProvider provider)
    : Updater<BlueprintPublishedResponse, BlueprintPublished>(storage, logger, provider), IBlueprintPublishedUpdater
{
    protected override BlueprintPublished Map(string executionId, ISubscription subscription, BlueprintPublishedResponse response) => BlueprintPublished.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}
