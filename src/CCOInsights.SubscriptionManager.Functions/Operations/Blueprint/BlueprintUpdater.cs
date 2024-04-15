using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Blueprint;

public interface IBlueprintUpdater : IUpdater { }
public class BlueprintUpdater : Updater<BlueprintResponse, Blueprint>, IBlueprintUpdater
{
    public BlueprintUpdater(IStorage storage, ILogger<BlueprintUpdater> logger, IBlueprintProvider provider) : base(storage, logger, provider)
    {
    }

    protected override Blueprint Map(string executionId, ISubscription subscription, BlueprintResponse response) => Blueprint.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}