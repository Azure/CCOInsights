using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachineExtensions;

[OperationDescriptor(DashboardType.Infrastructure, nameof(VirtualMachineExtensionsFunction))]
public class VirtualMachineExtensionsFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IVirtualMachineExtensionUpdater _updater;

    public VirtualMachineExtensionsFunction(IAuthenticated authenticatedResourceManager, IVirtualMachineExtensionUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(VirtualMachineExtensionsFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
