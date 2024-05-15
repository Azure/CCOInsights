using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Nic;

[OperationDescriptor(DashboardType.Infrastructure, nameof(NicFunction))]
public class NicFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly INicsUpdater _updater;

    public NicFunction(IAuthenticated authenticatedResourceManager, INicsUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(NicFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
                await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1
        );
    }
}
