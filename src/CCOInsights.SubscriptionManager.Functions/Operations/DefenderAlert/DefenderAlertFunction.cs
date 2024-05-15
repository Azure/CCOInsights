using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderAlert;

[OperationDescriptor(DashboardType.Infrastructure, nameof(DefenderAlertFunction))]
public class DefenderAlertFunction(IAuthenticated authenticatedResourceManager, IDefenderAlertUpdater updater)
    : IOperation
{
    [Function(nameof(DefenderAlertFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
