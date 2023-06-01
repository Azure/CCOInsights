using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Helpers;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.ResourceGroup
{
    [OperationDescriptor(DashboardType.Common, nameof(ResourceGroupFunction))]
    public class ResourceGroupFunction
    {
        private readonly IAuthenticated _authenticatedResourceManager;
        private readonly IResourceGroupUpdater _updater;

        public ResourceGroupFunction(IAuthenticated authenticatedResourceManager, IResourceGroupUpdater updater)
        {
            _authenticatedResourceManager = authenticatedResourceManager;
            _updater = updater;
        }

        [FunctionName(nameof(ResourceGroupFunction))]
        public async Task RegularResourceGroupsUpdate([ActivityTrigger] IDurableActivityContext context, System.Threading.CancellationToken cancellationToken = default)
        {
            var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
            await subscriptions.AsyncParallelForEach(async subscription =>
                await _updater.UpdateAsync(context.InstanceId, subscription, cancellationToken), 1);
        }
    }
}
