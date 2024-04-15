using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintPublished;

public interface IBlueprintPublishedUpdater : IUpdater { }
public class BlueprintPublishedUpdater : Updater<BlueprintPublishedResponse, BlueprintPublished>, IBlueprintPublishedUpdater
{
    public BlueprintPublishedUpdater(IStorage storage, ILogger<BlueprintPublishedUpdater> logger, IBlueprintPublishedProvider provider) : base(storage, logger, provider)
    {
    }

    protected override BlueprintPublished Map(string executionId, ISubscription subscription, BlueprintPublishedResponse response) => BlueprintPublished.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}