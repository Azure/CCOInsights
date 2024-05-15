using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Blueprint;

public interface IBlueprintUpdater : IUpdater { }
public class BlueprintUpdater(IStorage storage, ILogger<BlueprintUpdater> logger, IBlueprintProvider provider)
    : Updater<BlueprintResponse, Blueprint>(storage, logger, provider), IBlueprintUpdater
{
    protected override Blueprint Map(string executionId, ISubscription subscription, BlueprintResponse response) => Blueprint.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}
