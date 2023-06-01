using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.KeyVault
{
    public interface IKeyVaultUpdater : IUpdater { }
    public class KeyVaultUpdater : Updater<KeyVaultResponse, KeyVault>, IKeyVaultUpdater
    {
        public KeyVaultUpdater(IStorage storage, ILogger<KeyVaultUpdater> logger, IKeyVaultProvider provider) : base(storage, logger, provider)
        {
        }

        protected override KeyVault Map(string executionId, ISubscription subscription, KeyVaultResponse response) => KeyVault.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);

        protected override bool ShouldIngest(KeyVaultResponse response) =>
            response != null;
    }
}
