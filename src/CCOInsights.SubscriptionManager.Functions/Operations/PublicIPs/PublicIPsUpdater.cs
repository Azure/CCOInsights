using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PublicIPs;

public interface IPublicIPUpdater : IUpdater { }

public class PublicIPsUpdater : Updater<PublicIPsResponse, PublicIPs>, IPublicIPUpdater
{
    public PublicIPsUpdater(IStorage storage, ILogger<PublicIPsUpdater> logger, IPublicIPProvider provider) : base(storage, logger, provider)
    {
    }

    protected override PublicIPs Map(string executionId, ISubscription subscription, PublicIPsResponse response) => PublicIPs.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}