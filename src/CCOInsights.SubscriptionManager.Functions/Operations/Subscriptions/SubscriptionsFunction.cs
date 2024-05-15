namespace CCOInsights.SubscriptionManager.Functions.Operations.Subscriptions;

[OperationDescriptor(DashboardType.Governance, nameof(SubscriptionsFunction))]
internal class SubscriptionsFunction(ISubscriptionsUpdater updater) : IOperation
{
    [Function(nameof(SubscriptionsFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), null, cancellationToken: cancellationToken);
    }
}
