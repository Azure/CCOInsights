using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicyState;

[OperationDescriptor(DashboardType.Governance, nameof(PolicyStateFunction))]
public class PolicyStateFunction(IAuthenticated authenticatedResourceManager, IPolicyStateUpdater updater)
    : IOperation
{
    [Function(nameof(PolicyStateFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
