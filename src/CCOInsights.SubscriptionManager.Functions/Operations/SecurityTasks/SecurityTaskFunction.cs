using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.SecurityTasks;

[OperationDescriptor(DashboardType.Infrastructure, nameof(SecurityTaskFunction))]
public class SecurityTaskFunction(IAuthenticated authenticatedResourceManager, ISecurityTaskUpdater updater)
    : IOperation
{
    [Function(nameof(SecurityTaskFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }

}
