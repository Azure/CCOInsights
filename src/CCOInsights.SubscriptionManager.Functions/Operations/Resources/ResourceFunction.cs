using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Resources;

[OperationDescriptor(DashboardType.Infrastructure, nameof(ResourceFunction))]
public class ResourceFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IResourceUpdater _updater;

    public ResourceFunction(IAuthenticated authenticatedResourceManager, IResourceUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(ResourceFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
