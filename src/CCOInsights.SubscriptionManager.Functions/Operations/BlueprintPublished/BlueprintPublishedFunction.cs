using static Microsoft.Azure.Management.Fluent.Azure;
using System.Text.Json.Nodes;

namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintPublished;

[OperationDescriptor(DashboardType.Governance, nameof(BlueprintPublishedFunction))]
public class BlueprintPublishedFunction(IAuthenticated authenticatedResourceManager, IBlueprintPublishedUpdater updater)
    : IOperation
{
    [Function(nameof(BlueprintPublishedFunction))]
    public async Task Execute([ActivityTrigger] JsonObject input, FunctionContext executionContext, CancellationToken cancellationToken = default)

    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
