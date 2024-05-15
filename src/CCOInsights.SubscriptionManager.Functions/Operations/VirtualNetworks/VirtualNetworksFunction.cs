using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualNetworks;

[OperationDescriptor(DashboardType.Infrastructure, nameof(VirtualNetworksFunction))]
public class VirtualNetworksFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IVirtualNetworksUpdater _updater;

    public VirtualNetworksFunction(IAuthenticated authenticatedResourceManager, IVirtualNetworksUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(VirtualNetworksFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
