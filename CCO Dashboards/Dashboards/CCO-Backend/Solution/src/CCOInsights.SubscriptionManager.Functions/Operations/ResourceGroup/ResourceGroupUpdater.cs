using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.ResourceGroup;

public interface IResourceGroupUpdater : IUpdater { }
public class ResourceGroupUpdater(IStorage storage, ILogger<ResourceGroupUpdater> logger,
        IResourceGroupProvider provider)
    : Updater<ResourceGroupResponse, ResourceGroup>(storage, logger, provider), IResourceGroupUpdater
{
    protected override ResourceGroup Map(string executionId, ISubscription subscription, ResourceGroupResponse response) => ResourceGroup.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}