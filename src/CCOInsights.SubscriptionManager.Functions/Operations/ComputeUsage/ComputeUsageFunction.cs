using static Microsoft.Azure.Management.Fluent.Azure;
using System.Text.Json.Nodes;

namespace CCOInsights.SubscriptionManager.Functions.Operations.ComputeUsage;

[OperationDescriptor(DashboardType.Infrastructure, nameof(ComputeUsageFunction))]
public class ComputeUsageFunction(IAuthenticated authenticatedResourceManager, IComputeUsageUpdater updater)
    : IOperation
{
    [Function(nameof(ComputeUsageFunction))]
    public async Task Execute([ActivityTrigger] 
    JsonObject input, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }

}
