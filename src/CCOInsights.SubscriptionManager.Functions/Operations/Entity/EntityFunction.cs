using System.Threading.Tasks;



namespace CCOInsights.SubscriptionManager.Functions.Operations.Entity;

[OperationDescriptor(DashboardType.Common, nameof(EntityFunction))]
public class EntityFunction : IOperation
{
    private readonly IEntitiesUpdater _updater;

    public EntityFunction(IEntitiesUpdater updater)
    {
        _updater = updater;
    }

    [Function(nameof(EntityFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        await _updater.UpdateAsync(executionContext.InvocationId, null, cancellationToken);
    }
}