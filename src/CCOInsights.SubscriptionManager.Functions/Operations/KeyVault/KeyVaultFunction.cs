using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.KeyVault;

[OperationDescriptor(DashboardType.Infrastructure, nameof(KeyVaultFunction))]
public class KeyVaultFunction(IAuthenticated authenticatedResourceManager, IKeyVaultUpdater updater)
    : IOperation
{
    [Function(nameof(KeyVaultFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
                await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1
        );
    }
}
