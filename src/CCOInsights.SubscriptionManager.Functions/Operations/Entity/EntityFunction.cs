namespace CCOInsights.SubscriptionManager.Functions.Operations.Entity;

[OperationDescriptor(DashboardType.Common, nameof(EntityFunction))]
public class EntityFunction(IEntitiesUpdater updater) : IOperation
{
    [Function(nameof(EntityFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), null, cancellationToken);
    }
}
