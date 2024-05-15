namespace CCOInsights.SubscriptionManager.Functions.Operations.Users;

[OperationDescriptor(DashboardType.Infrastructure, nameof(UsersFunction))]
public class UsersFunction(IUsersUpdater updater) : IOperation
{
    [Function(nameof(UsersFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), null, cancellationToken);
    }
}
