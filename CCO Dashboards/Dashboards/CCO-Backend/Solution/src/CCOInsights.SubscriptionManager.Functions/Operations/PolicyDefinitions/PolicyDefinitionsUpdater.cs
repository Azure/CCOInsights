using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicyDefinitions;

public interface IPolicyDefinitionsUpdater : IUpdater { }
public class PolicyDefinitionsUpdater(IStorage storage, ILogger<PolicyDefinitionsUpdater> logger,
        IPolicyDefinitionProvider provider)
    : Updater<PolicyDefinitionResponse, PolicyDefinitions>(storage, logger, provider), IPolicyDefinitionsUpdater
{
    protected override PolicyDefinitions Map(string executionId, ISubscription subscription, PolicyDefinitionResponse response) =>
        PolicyDefinitions.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}