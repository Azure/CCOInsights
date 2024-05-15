using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PublicIPs;

[OperationDescriptor(DashboardType.Infrastructure, nameof(PublicIPsFunction))]
public class PublicIPsFunction(IAuthenticated authenticatedResourceManager, IPublicIPUpdater updater)
    : IOperation
{
    [Function(nameof(PublicIPsFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
