using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Location;

[OperationDescriptor(DashboardType.Common, nameof(LocationFunction))]
public class LocationFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly ILocationUpdater _updater;

    public LocationFunction(IAuthenticated authenticatedResourceManager, ILocationUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(LocationFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)

    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
