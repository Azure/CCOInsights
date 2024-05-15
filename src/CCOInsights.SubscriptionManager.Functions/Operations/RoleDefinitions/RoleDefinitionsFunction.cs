using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.RoleDefinitions;

[OperationDescriptor(DashboardType.Infrastructure, nameof(RoleDefinitionsFunction))]
public class RoleDefinitionsFunction(IAuthenticated authenticatedResourceManager, IRoleDefinitionsUpdater updater)
    : IOperation
{
    [Function(nameof(RoleDefinitionsFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
