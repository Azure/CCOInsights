using System.Threading;
using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.NetworkSecurityGroups;

[OperationDescriptor(DashboardType.Infrastructure, nameof(NetworkSecurityGroupFunction))]
public class NetworkSecurityGroupFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly INetworkSecurityGroupUpdater _updater;

    public NetworkSecurityGroupFunction(IAuthenticated authenticatedResourceManager, INetworkSecurityGroupUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(NetworkSecurityGroupFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }

}

