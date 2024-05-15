using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.NetworkSecurityGroups;

[OperationDescriptor(DashboardType.Infrastructure, nameof(NetworkSecurityGroupFunction))]
public class NetworkSecurityGroupFunction(IAuthenticated authenticatedResourceManager,
        INetworkSecurityGroupUpdater updater)
    : IOperation
{
    [Function(nameof(NetworkSecurityGroupFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }

}

