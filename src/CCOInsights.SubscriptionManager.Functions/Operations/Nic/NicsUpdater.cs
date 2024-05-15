using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Nic;

public interface INicsUpdater : IUpdater { }

public class NicsUpdater(IStorage storage, ILogger<NicsUpdater> logger, INicProvider provider)
    : Updater<NicResponse, Nic>(storage, logger, provider), INicsUpdater
{
    protected override Nic Map(string executionId, ISubscription subscription, NicResponse response) =>
        Nic.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);


    protected override bool ShouldIngest(NicResponse response) =>
        response.NicProperties?.VirtualMachine?.NetworkSecurityGroupId != null;
};
