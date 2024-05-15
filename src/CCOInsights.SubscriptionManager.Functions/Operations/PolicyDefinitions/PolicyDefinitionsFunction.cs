using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicyDefinitions;

[OperationDescriptor(DashboardType.Governance, nameof(PolicyDefinitionsFunction))]
public class PolicyDefinitionsFunction(IAuthenticated authenticatedResourceManager, IPolicyDefinitionsUpdater updater)
    : IOperation
{
    [Function(nameof(PolicyDefinitionsFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
