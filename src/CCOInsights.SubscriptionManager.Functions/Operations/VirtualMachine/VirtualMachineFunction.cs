using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Helpers;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachine
{
    [OperationDescriptor(DashboardType.Infrastructure, nameof(VirtualMachineFunction))]
    public class VirtualMachineFunction : IOperation
    {
        private readonly IAuthenticated _authenticatedResourceManager;
        private readonly IVirtualMachineUpdater _updater;

        public VirtualMachineFunction(IAuthenticated authenticatedResourceManager, IVirtualMachineUpdater updater)
        {
            _authenticatedResourceManager = authenticatedResourceManager;
            _updater = updater;
        }

        [FunctionName(nameof(VirtualMachineFunction))]
        public async Task Execute([ActivityTrigger] IDurableActivityContext context, System.Threading.CancellationToken cancellationToken = default)
        {
            var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
            await subscriptions.AsyncParallelForEach(async subscription =>
                await _updater.UpdateAsync(context.InstanceId, subscription, cancellationToken), 1
            );
        }
    }
}
