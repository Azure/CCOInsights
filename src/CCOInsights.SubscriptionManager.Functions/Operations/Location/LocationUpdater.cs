using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Location;

public interface ILocationUpdater : IUpdater { }
public class LocationUpdater(IStorage storage, ILogger<LocationUpdater> logger, ILocationProvider provider)
    : Updater<LocationResponse, Location>(storage, logger, provider), ILocationUpdater
{
    protected override Location Map(string executionId, ISubscription subscription, LocationResponse response) => Location.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}