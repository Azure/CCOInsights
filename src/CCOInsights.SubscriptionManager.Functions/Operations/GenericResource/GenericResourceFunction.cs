using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.GenericResource;

[OperationDescriptor(DashboardType.Common, nameof(GenericResourceFunction))]
public class GenericResourceFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IResourcesUpdater _updater;

    public GenericResourceFunction(IAuthenticated authenticatedResourceManager, IResourcesUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(GenericResourceFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1
        );
    }
}
