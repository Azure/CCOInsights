using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachinePatch;

[OperationDescriptor(DashboardType.Infrastructure, nameof(VirtualMachinePatchFunction))]
public class VirtualMachinePatchFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IVirtualMachinePatchUpdater _updater;

    public VirtualMachinePatchFunction(IAuthenticated authenticatedResourceManager, IVirtualMachinePatchUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(VirtualMachinePatchFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
                await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1
        );
    }
}
