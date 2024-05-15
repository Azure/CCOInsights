using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.RoleDefinitions;

public interface IRoleDefinitionsUpdater : IUpdater { }
public class RoleDefinitionsUpdater(IStorage storage, ILogger<RoleDefinitionsUpdater> logger,
        IRoleDefinitionsProvider provider)
    : Updater<RoleDefinitionsResponse, RoleDefinitions>(storage, logger, provider), IRoleDefinitionsUpdater
{
    protected override RoleDefinitions Map(string executionId, ISubscription subscription, RoleDefinitionsResponse response) =>
        RoleDefinitions.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);

    protected override bool ShouldIngest(RoleDefinitionsResponse? response) =>
        response != null;
}