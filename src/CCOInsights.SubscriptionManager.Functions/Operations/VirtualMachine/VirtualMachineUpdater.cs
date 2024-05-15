using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachine;

public interface IVirtualMachineUpdater : IUpdater { }
public class VirtualMachineUpdater(IStorage storage, ILogger<VirtualMachineUpdater> logger,
        IVirtualMachineProvider provider)
    : Updater<VirtualMachineResponse, VirtualMachine>(storage, logger, provider), IVirtualMachineUpdater
{
    protected override VirtualMachine Map(string executionId, ISubscription subscription, VirtualMachineResponse response) =>
        VirtualMachine.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}