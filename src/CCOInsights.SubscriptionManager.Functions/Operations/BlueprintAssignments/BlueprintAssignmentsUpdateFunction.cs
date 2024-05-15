using Microsoft.Azure.Functions.Worker;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintAssignments;

[OperationDescriptor(DashboardType.Governance, nameof(BlueprintAssignmentsUpdateFunction))]
public class BlueprintAssignmentsUpdateFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IBlueprintAssignmentsUpdater _updater;

    public BlueprintAssignmentsUpdateFunction(IAuthenticated authenticatedResourceManager, IBlueprintAssignmentsUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(BlueprintAssignmentsUpdateFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
