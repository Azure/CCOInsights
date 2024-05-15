using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.NetworkUsages;

[OperationDescriptor(DashboardType.Infrastructure, nameof(NetworkUsagesFunction))]
public class NetworkUsagesFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly INetworkUsagesUpdater _updater;

    public NetworkUsagesFunction(IAuthenticated authenticatedResourceManager, INetworkUsagesUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(NetworkUsagesFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
