using Microsoft.Azure.Functions.Worker;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Blueprint;

[OperationDescriptor(DashboardType.Governance, nameof(BlueprintFunction))]
public class BlueprintFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IBlueprintUpdater _updater;

    public BlueprintFunction(IAuthenticated authenticatedResourceManager, IBlueprintUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;

    }

    [Function(nameof(BlueprintFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
