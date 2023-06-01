using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicyDefinitions
{
    public interface IPolicyDefinitionsUpdater : IUpdater { }
    public class PolicyDefinitionsUpdater : Updater<PolicyDefinitionResponse, PolicyDefinitions>, IPolicyDefinitionsUpdater
    {
        public PolicyDefinitionsUpdater(IStorage storage, ILogger<PolicyDefinitionsUpdater> logger, IPolicyDefinitionProvider provider) : base(storage, logger, provider)
        {
        }

        protected override PolicyDefinitions Map(string executionId, ISubscription subscription, PolicyDefinitionResponse response) =>
            PolicyDefinitions.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
    }
}
