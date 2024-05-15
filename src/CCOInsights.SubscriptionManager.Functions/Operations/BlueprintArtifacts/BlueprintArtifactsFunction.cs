using Microsoft.Azure.Functions.Worker;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintArtifacts;

[OperationDescriptor(DashboardType.Governance, nameof(BlueprintArtifactsFunction))]
public class BlueprintArtifactsFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IBlueprintArtifactUpdater _updater;

    public BlueprintArtifactsFunction(IAuthenticated authenticatedResourceManager, IBlueprintArtifactUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;

    }

    [Function(nameof(BlueprintArtifactsFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
