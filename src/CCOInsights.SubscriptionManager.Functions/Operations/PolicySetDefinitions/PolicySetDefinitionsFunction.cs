using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicySetDefinitions;

[OperationDescriptor(DashboardType.Governance, nameof(PolicySetDefinitionsFunction))]
public class PolicySetDefinitionsFunction(IAuthenticated authenticatedResourceManager,
        IPolicySetDefinitionsUpdater updater)
    : IOperation
{
    [Function(nameof(PolicySetDefinitionsFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
