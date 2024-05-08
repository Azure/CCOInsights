using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Groups;

[OperationDescriptor(DashboardType.Infrastructure, nameof(GroupsFunction))]
public class GroupsFunction : IOperation
{
    private readonly IGroupsUpdater _updater;

    public GroupsFunction(IGroupsUpdater updater)
    {
        _updater = updater;
    }

    [FunctionName(nameof(GroupsFunction))]
    public async Task Execute([ActivityTrigger] IDurableActivityContext context, System.Threading.CancellationToken cancellationToken = default)
    {
        await _updater.UpdateAsync(context.InstanceId, null, cancellationToken);
    }
}