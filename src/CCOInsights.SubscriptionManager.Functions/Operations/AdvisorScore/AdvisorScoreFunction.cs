using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.AdvisorScore;

[OperationDescriptor(DashboardType.Infrastructure, nameof(AdvisorScoreFunction))]
public class AdvisorScoreFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IAdvisorScoreUpdater _updater;

    public AdvisorScoreFunction(IAuthenticated authenticatedResourceManager, IAdvisorScoreUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(AdvisorScoreFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)

    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }

}
