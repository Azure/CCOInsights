using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Disks;

[OperationDescriptor(DashboardType.Infrastructure, nameof(DisksFunction))]
public class DisksFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IDisksUpdater _updater;

    public DisksFunction(IAuthenticated authenticatedResourceManager, IDisksUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(DisksFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
