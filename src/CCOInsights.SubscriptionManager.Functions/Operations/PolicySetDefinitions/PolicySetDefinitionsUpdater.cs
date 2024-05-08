using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicySetDefinitions;

public interface IPolicySetDefinitionsUpdater : IUpdater { }
public class PolicySetDefinitionsUpdater : Updater<PolicySetDefinitionsResponse, PolicySetDefinitions>, IPolicySetDefinitionsUpdater
{
    public PolicySetDefinitionsUpdater(IStorage storage, ILogger<PolicySetDefinitionsUpdater> logger, IPolicySetDefinitionProvider provider) : base(storage, logger, provider)
    {
    }

    protected override PolicySetDefinitions Map(string executionId, ISubscription subscription, PolicySetDefinitionsResponse response) =>
        PolicySetDefinitions.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}
