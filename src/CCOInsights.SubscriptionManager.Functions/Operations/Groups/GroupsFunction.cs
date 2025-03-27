namespace CCOInsights.SubscriptionManager.Functions.Operations.Groups;

[OperationDescriptor(DashboardType.Infrastructure, nameof(GroupsFunction))]
public class GroupsFunction(IGroupsUpdater updater) : IOperation
{
    [Function(nameof(GroupsFunction))]
        public async Task Execute([ActivityTrigger] JsonObject input, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), null, cancellationToken);
    }
}
