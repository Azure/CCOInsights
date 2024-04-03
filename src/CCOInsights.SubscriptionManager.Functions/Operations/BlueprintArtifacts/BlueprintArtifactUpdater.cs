using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintArtifacts;

public interface IBlueprintArtifactUpdater : IUpdater { }
public class BlueprintArtifactUpdater : Updater<BlueprintArtifactsResponse, BlueprintArtifacts>, IBlueprintArtifactUpdater
{
    public BlueprintArtifactUpdater(IStorage storage, ILogger<BlueprintArtifactUpdater> logger, IBlueprintArtifactProvider provider) : base(storage, logger, provider)
    {
    }

    protected override BlueprintArtifacts Map(string executionId, ISubscription subscription, BlueprintArtifactsResponse response) => BlueprintArtifacts.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}