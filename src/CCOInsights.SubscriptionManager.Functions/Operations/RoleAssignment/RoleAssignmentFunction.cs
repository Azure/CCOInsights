using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.RoleAssignment;

[OperationDescriptor(DashboardType.Infrastructure, nameof(RoleAssignmentFunction))]
public class RoleAssignmentFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IRoleAssignmentUpdater _updater;

    public RoleAssignmentFunction(IAuthenticated authenticatedResourceManager, IRoleAssignmentUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(RoleAssignmentFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
                await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1
        );
    }
}
