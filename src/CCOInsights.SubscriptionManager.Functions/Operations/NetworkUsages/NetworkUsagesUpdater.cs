using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.NetworkUsages;

public interface INetworkUsagesUpdater : IUpdater { }
public class NetworkUsagesUpdater(IStorage storage, ILogger<NetworkUsagesUpdater> logger,
        INetworkUsagesProvider provider)
    : Updater<NetworkUsagesResponse, NetworkUsages>(storage, logger, provider), INetworkUsagesUpdater
{
    protected override NetworkUsages Map(string executionId, ISubscription subscription, NetworkUsagesResponse response) => NetworkUsages.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);

    protected override bool ShouldIngest(NetworkUsagesResponse? response) =>
        response != null;
}