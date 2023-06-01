using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Subscriptions
{
    [OperationDescriptor(DashboardType.Governance, nameof(SubscriptionsFunction))]
    internal class SubscriptionsFunction : IOperation
    {
        private readonly ISubscriptionsUpdater _updater;

        public SubscriptionsFunction(ISubscriptionsUpdater updater)
        {
            _updater = updater;
        }

        [FunctionName(nameof(SubscriptionsFunction))]
        public async Task Execute([ActivityTrigger] IDurableActivityContext context, System.Threading.CancellationToken cancellationToken = default)
        {
            await _updater.UpdateAsync(context.InstanceId, null, cancellationToken: cancellationToken);
        }
    }
}
