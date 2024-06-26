using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Blueprint;

[OperationDescriptor(DashboardType.Governance, nameof(BlueprintFunction))]
public class BlueprintFunction(IAuthenticated authenticatedResourceManager, IBlueprintUpdater updater)
    : IOperation
{
    [Function(nameof(BlueprintFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
