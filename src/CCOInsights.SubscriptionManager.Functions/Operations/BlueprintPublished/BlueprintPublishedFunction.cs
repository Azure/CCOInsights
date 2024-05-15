using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintPublished;

[OperationDescriptor(DashboardType.Governance, nameof(BlueprintPublishedFunction))]
public class BlueprintPublishedFunction(IAuthenticated authenticatedResourceManager, IBlueprintPublishedUpdater updater)
    : IOperation
{
    [Function(nameof(BlueprintPublishedFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)

    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
