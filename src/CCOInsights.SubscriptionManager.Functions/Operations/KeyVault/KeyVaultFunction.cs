using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.KeyVault;

[OperationDescriptor(DashboardType.Infrastructure, nameof(KeyVaultFunction))]
public class KeyVaultFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IKeyVaultUpdater _updater;

    public KeyVaultFunction(IAuthenticated authenticatedResourceManager, IKeyVaultUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(KeyVaultFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
                await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1
        );
    }
}
