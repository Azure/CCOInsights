using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Helpers;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachineExtensions
{

    [OperationDescriptor(DashboardType.Infrastructure, nameof(VirtualMachineExtensionsFunction))]
    public class VirtualMachineExtensionsFunction : IOperation
    {
        private readonly IAuthenticated _authenticatedResourceManager;
        private readonly IVirtualMachineExtensionUpdater _updater;

        public VirtualMachineExtensionsFunction(IAuthenticated authenticatedResourceManager, IVirtualMachineExtensionUpdater updater)
        {
            _authenticatedResourceManager = authenticatedResourceManager;
            _updater = updater;
        }

        [FunctionName(nameof(VirtualMachineExtensionsFunction))]
        public async Task Execute([ActivityTrigger] IDurableActivityContext context, System.Threading.CancellationToken cancellationToken = default)
        {
            var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
            await subscriptions.AsyncParallelForEach(async subscription =>
                await _updater.UpdateAsync(context.InstanceId, subscription, cancellationToken), 1);
        }
    }
}
