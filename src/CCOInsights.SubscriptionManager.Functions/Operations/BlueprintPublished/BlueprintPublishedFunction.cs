using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintPublished;

[OperationDescriptor(DashboardType.Governance, nameof(BlueprintPublishedFunction))]
public class BlueprintPublishedFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IBlueprintPublishedUpdater _updater;

    public BlueprintPublishedFunction(IAuthenticated authenticatedResourceManager, IBlueprintPublishedUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(BlueprintPublishedFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)

    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
