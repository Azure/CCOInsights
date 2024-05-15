using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.AppServicePlans;

[OperationDescriptor(DashboardType.Infrastructure, nameof(AppServicePlansFunction))]
public class AppServicePlansFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IAppServicePlansUpdater _updater;

    public AppServicePlansFunction(IAuthenticated authenticatedResourceManager, IAppServicePlansUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(AppServicePlansFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
