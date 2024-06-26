using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PublicIPs;

public interface IPublicIPUpdater : IUpdater { }

public class PublicIPsUpdater(IStorage storage, ILogger<PublicIPsUpdater> logger, IPublicIPProvider provider)
    : Updater<PublicIPsResponse, PublicIPs>(storage, logger, provider), IPublicIPUpdater
{
    protected override PublicIPs Map(string executionId, ISubscription subscription, PublicIPsResponse response) => PublicIPs.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}