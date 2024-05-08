using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.ResourceGroup;

public interface IResourceGroupUpdater : IUpdater { }
public class ResourceGroupUpdater : Updater<ResourceGroupResponse, ResourceGroup>, IResourceGroupUpdater
{
    public ResourceGroupUpdater(IStorage storage, ILogger<ResourceGroupUpdater> logger, IResourceGroupProvider provider) : base(storage, logger, provider)
    {
    }

    protected override ResourceGroup Map(string executionId, ISubscription subscription, ResourceGroupResponse response) => ResourceGroup.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}