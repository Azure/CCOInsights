using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicyState;

public interface IPolicyStateUpdater : IUpdater { }
public class PolicyStateUpdater : Updater<AzurePolicyStateResponseValue, PolicyState>, IPolicyStateUpdater
{
    public PolicyStateUpdater(IStorage storage, ILogger<PolicyStateUpdater> logger, IPolicyStateProvider provider) : base(storage, logger, provider)
    {
    }

    protected override PolicyState Map(string executionId, ISubscription subscription, AzurePolicyStateResponseValue response) =>
        PolicyState.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}