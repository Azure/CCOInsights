using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicySetDefinitions;

public interface IPolicySetDefinitionsUpdater : IUpdater { }
public class PolicySetDefinitionsUpdater(IStorage storage, ILogger<PolicySetDefinitionsUpdater> logger,
        IPolicySetDefinitionProvider provider)
    : Updater<PolicySetDefinitionsResponse, PolicySetDefinitions>(storage, logger, provider),
        IPolicySetDefinitionsUpdater
{
    protected override PolicySetDefinitions Map(string executionId, ISubscription subscription, PolicySetDefinitionsResponse response) =>
        PolicySetDefinitions.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}
