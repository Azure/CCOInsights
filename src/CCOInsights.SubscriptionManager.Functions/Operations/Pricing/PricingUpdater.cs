using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Pricing
{
    public interface IPricingUpdater : IUpdater { }

    public class PricingUpdater : Updater<PricingResponse, Pricing>, IPricingUpdater
    {
        public PricingUpdater(IStorage storage, ILogger<PricingUpdater> logger, IPricingProvider provider) : base(storage, logger, provider)
        {
        }

        protected override Pricing Map(string executionId, ISubscription subscription, PricingResponse response) => Pricing.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
    }
}
