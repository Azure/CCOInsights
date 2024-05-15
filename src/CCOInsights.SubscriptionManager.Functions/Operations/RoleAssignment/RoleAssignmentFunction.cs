using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.RoleAssignment;

[OperationDescriptor(DashboardType.Infrastructure, nameof(RoleAssignmentFunction))]
public class RoleAssignmentFunction(IAuthenticated authenticatedResourceManager, IRoleAssignmentUpdater updater)
    : IOperation
{
    [Function(nameof(RoleAssignmentFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
                await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1
        );
    }
}
