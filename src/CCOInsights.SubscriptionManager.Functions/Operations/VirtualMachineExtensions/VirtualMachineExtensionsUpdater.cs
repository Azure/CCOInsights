using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachineExtensions;

public interface IVirtualMachineExtensionUpdater : IUpdater { }

public class VirtualMachineExtensionsUpdater(IStorage storage, ILogger<VirtualMachineExtensionsUpdater> logger,
        IVirtualMachineExtensionProvider provider)
    : Updater<VirtualMachineExtensionsResponse, VirtualMachineExtensions>(storage, logger, provider),
        IVirtualMachineExtensionUpdater
{
    protected override VirtualMachineExtensions Map(string executionId, ISubscription subscription, VirtualMachineExtensionsResponse response) =>
        VirtualMachineExtensions.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}