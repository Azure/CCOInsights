using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.ResourceGroup;

[OperationDescriptor(DashboardType.Common, nameof(ResourceGroupFunction))]
public class ResourceGroupFunction(IAuthenticated authenticatedResourceManager, IResourceGroupUpdater updater)
    : IOperation
{
    [Function(nameof(ResourceGroupFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
