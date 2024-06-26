using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachinePatch;

public interface IVirtualMachinePatchUpdater : IUpdater { }

public class VirtualMachinePatchUpdater(IStorage storage, ILogger<VirtualMachinePatchUpdater> logger,
        IVirtualMachinePatchProvider provider)
    : Updater<VirtualMachinePatchResponse, VirtualMachinePatch>(storage, logger, provider), IVirtualMachinePatchUpdater
{
    protected override VirtualMachinePatch Map(string executionId, ISubscription subscription, VirtualMachinePatchResponse response) =>
        VirtualMachinePatch.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}