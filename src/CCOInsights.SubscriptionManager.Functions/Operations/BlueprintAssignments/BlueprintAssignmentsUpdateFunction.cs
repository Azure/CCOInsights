using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintAssignments;

[OperationDescriptor(DashboardType.Governance, nameof(BlueprintAssignmentsUpdateFunction))]
public class BlueprintAssignmentsUpdateFunction(IAuthenticated authenticatedResourceManager,
        IBlueprintAssignmentsUpdater updater)
    : IOperation
{
    [Function(nameof(BlueprintAssignmentsUpdateFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
