using System.Threading.Tasks;



namespace CCOInsights.SubscriptionManager.Functions.Operations.Users;

[OperationDescriptor(DashboardType.Infrastructure, nameof(UsersFunction))]
public class UsersFunction : IOperation
{
    private readonly IUsersUpdater _updater;

    public UsersFunction(IUsersUpdater updater)
    {
        _updater = updater;
    }

    [Function(nameof(UsersFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        await _updater.UpdateAsync(executionContext.InvocationId, null, cancellationToken);
    }
}