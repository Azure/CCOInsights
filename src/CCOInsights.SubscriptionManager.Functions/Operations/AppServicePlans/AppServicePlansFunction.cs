using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.AppServicePlans;

[OperationDescriptor(DashboardType.Infrastructure, nameof(AppServicePlansFunction))]
public class AppServicePlansFunction(IAuthenticated authenticatedResourceManager, IAppServicePlansUpdater updater)
    : IOperation
{
    [Function(nameof(AppServicePlansFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
