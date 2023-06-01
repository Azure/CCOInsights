using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Users
{
    [OperationDescriptor(DashboardType.Infrastructure, nameof(UsersFunction))]
    public class UsersFunction : IOperation
    {
        private readonly IUsersUpdater _updater;

        public UsersFunction(IUsersUpdater updater)
        {
            _updater = updater;
        }

        [FunctionName(nameof(UsersFunction))]
        public async Task Execute([ActivityTrigger] IDurableActivityContext context, System.Threading.CancellationToken cancellationToken = default)
        {
            await _updater.UpdateAsync(context.InstanceId, null, cancellationToken);
        }
    }
}
