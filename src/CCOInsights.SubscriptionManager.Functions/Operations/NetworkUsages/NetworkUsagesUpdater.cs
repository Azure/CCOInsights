using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.NetworkUsages
{

    public interface INetworkUsagesUpdater : IUpdater { }
    public class NetworkUsagesUpdater : Updater<NetworkUsagesResponse, NetworkUsages>, INetworkUsagesUpdater
    {
        public NetworkUsagesUpdater(IStorage storage, ILogger<NetworkUsagesUpdater> logger, INetworkUsagesProvider provider) : base(storage, logger, provider)
        {
        }

        protected override NetworkUsages Map(string executionId, ISubscription subscription, NetworkUsagesResponse response) => NetworkUsages.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);

        protected override bool ShouldIngest(NetworkUsagesResponse? response) =>
            response != null;
    }
}
