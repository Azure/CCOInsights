using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.AdvisorScore;

[OperationDescriptor(DashboardType.Infrastructure, nameof(AdvisorScoreFunction))]
public class AdvisorScoreFunction(IAuthenticated authenticatedResourceManager, IAdvisorScoreUpdater updater)
    : IOperation
{
    [Function(nameof(AdvisorScoreFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)

    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }

}
