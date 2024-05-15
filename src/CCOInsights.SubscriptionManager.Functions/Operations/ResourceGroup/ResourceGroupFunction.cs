using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.ResourceGroup;

[OperationDescriptor(DashboardType.Common, nameof(ResourceGroupFunction))]
public class ResourceGroupFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IResourceGroupUpdater _updater;

    public ResourceGroupFunction(IAuthenticated authenticatedResourceManager, IResourceGroupUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(ResourceGroupFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
