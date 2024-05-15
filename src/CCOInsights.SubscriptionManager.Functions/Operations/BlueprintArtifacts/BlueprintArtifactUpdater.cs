using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintArtifacts;

public interface IBlueprintArtifactUpdater : IUpdater { }
public class BlueprintArtifactUpdater(IStorage storage, ILogger<BlueprintArtifactUpdater> logger,
        IBlueprintArtifactProvider provider)
    : Updater<BlueprintArtifactsResponse, BlueprintArtifacts>(storage, logger, provider), IBlueprintArtifactUpdater
{
    protected override BlueprintArtifacts Map(string executionId, ISubscription subscription, BlueprintArtifactsResponse response) => BlueprintArtifacts.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}
