using System.Threading.Tasks;



namespace CCOInsights.SubscriptionManager.Functions.Operations.Groups;

[OperationDescriptor(DashboardType.Infrastructure, nameof(GroupsFunction))]
public class GroupsFunction : IOperation
{
    private readonly IGroupsUpdater _updater;

    public GroupsFunction(IGroupsUpdater updater)
    {
        _updater = updater;
    }

    [Function(nameof(GroupsFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        await _updater.UpdateAsync(executionContext.InvocationId, null, cancellationToken);
    }
}