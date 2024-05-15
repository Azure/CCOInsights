using System.Threading;
using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.ComputeUsage;

[OperationDescriptor(DashboardType.Infrastructure, nameof(ComputeUsageFunction))]
public class ComputeUsageFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IComputeUsageUpdater _updater;

    public ComputeUsageFunction(IAuthenticated authenticatedResourceManager, IComputeUsageUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(ComputeUsageFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }

}
