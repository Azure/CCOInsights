using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Helpers;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintArtifacts;

[OperationDescriptor(DashboardType.Governance, nameof(BlueprintArtifactsFunction))]
public class BlueprintArtifactsFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IBlueprintArtifactUpdater _updater;

    public BlueprintArtifactsFunction(IAuthenticated authenticatedResourceManager, IBlueprintArtifactUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;

    }

    [FunctionName(nameof(BlueprintArtifactsFunction))]
    public async Task Execute([ActivityTrigger] IDurableActivityContext context, System.Threading.CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(context.InstanceId, subscription, cancellationToken), 1);
    }
}