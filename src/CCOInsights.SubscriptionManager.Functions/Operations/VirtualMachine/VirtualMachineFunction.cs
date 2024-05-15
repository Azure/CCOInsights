using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachine;

[OperationDescriptor(DashboardType.Infrastructure, nameof(VirtualMachineFunction))]
public class VirtualMachineFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IVirtualMachineUpdater _updater;

    public VirtualMachineFunction(IAuthenticated authenticatedResourceManager, IVirtualMachineUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(VirtualMachineFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
                await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1
        );
    }
}
