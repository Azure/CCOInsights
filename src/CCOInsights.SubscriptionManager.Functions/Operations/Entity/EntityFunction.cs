using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Entity;

[OperationDescriptor(DashboardType.Common, nameof(EntityFunction))]
public class EntityFunction : IOperation
{
    private readonly IEntitiesUpdater _updater;

    public EntityFunction(IEntitiesUpdater updater)
    {
        _updater = updater;
    }

    [FunctionName(nameof(EntityFunction))]
    public async Task Execute([ActivityTrigger] IDurableActivityContext context, System.Threading.CancellationToken cancellationToken = default)
    {
        await _updater.UpdateAsync(context.InstanceId, null, cancellationToken);
    }
}