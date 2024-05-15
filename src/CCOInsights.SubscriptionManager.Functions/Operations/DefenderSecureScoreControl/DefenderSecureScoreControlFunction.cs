using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderSecureScoreControl;

[OperationDescriptor(DashboardType.Governance, nameof(DefenderSecureScoreControlFunction))]
public class DefenderSecureScoreControlFunction(IAuthenticated authenticatedResourceManager,
        IDefenderSecureScoreControlUpdater updater)
    : IOperation
{
    [Function(nameof(DefenderSecureScoreControlFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)

    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
