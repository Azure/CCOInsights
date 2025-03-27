using static Microsoft.Azure.Management.Fluent.Azure;
using System.Text.Json.Nodes;

namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintAssignments;

[OperationDescriptor(DashboardType.Governance, nameof(BlueprintAssignmentsUpdateFunction))]
public class BlueprintAssignmentsUpdateFunction(IAuthenticated authenticatedResourceManager,
        IBlueprintAssignmentsUpdater updater)
    : IOperation
{
    [Function(nameof(BlueprintAssignmentsUpdateFunction))]
    public async Task Execute([ActivityTrigger] JsonObject input, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
