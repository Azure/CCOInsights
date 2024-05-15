using System.Threading.Tasks;



namespace CCOInsights.SubscriptionManager.Functions.Operations.Subscriptions;

[OperationDescriptor(DashboardType.Governance, nameof(SubscriptionsFunction))]
internal class SubscriptionsFunction : IOperation
{
    private readonly ISubscriptionsUpdater _updater;

    public SubscriptionsFunction(ISubscriptionsUpdater updater)
    {
        _updater = updater;
    }

    [Function(nameof(SubscriptionsFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        await _updater.UpdateAsync(executionContext.InvocationId, null, cancellationToken: cancellationToken);
    }
}