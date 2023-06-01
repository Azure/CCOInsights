using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachineExtensions
{
    public interface IVirtualMachineExtensionUpdater : IUpdater { }

    public class VirtualMachineExtensionsUpdater : Updater<VirtualMachineExtensionsResponse, VirtualMachineExtensions>, IVirtualMachineExtensionUpdater
    {
        public VirtualMachineExtensionsUpdater(IStorage storage, ILogger<VirtualMachineExtensionsUpdater> logger, IVirtualMachineExtensionProvider provider) : base(storage, logger, provider)
        {
        }

        protected override VirtualMachineExtensions Map(string executionId, ISubscription subscription, VirtualMachineExtensionsResponse response) =>
            VirtualMachineExtensions.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
    }
}
