using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Nic;

[OperationDescriptor(DashboardType.Infrastructure, nameof(NicFunction))]
public class NicFunction(IAuthenticated authenticatedResourceManager, INicsUpdater updater)
    : IOperation
{
    [Function(nameof(NicFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
                await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1
        );
    }
}
