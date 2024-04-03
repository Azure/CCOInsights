using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Helpers;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintAssignments;

[OperationDescriptor(DashboardType.Governance, nameof(BlueprintAssignmentsUpdateFunction))]
public class BlueprintAssignmentsUpdateFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IBlueprintAssignmentsUpdater _updater;

    public BlueprintAssignmentsUpdateFunction(IAuthenticated authenticatedResourceManager, IBlueprintAssignmentsUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [FunctionName(nameof(BlueprintAssignmentsUpdateFunction))]
    public async Task Execute([ActivityTrigger] IDurableActivityContext context, System.Threading.CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(context.InstanceId, subscription, cancellationToken), 1);
    }
}