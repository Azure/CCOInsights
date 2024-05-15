using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.AdvisorRecommendations;

[OperationDescriptor(DashboardType.Infrastructure, nameof(AdvisorRecommendationFunction))]
public class AdvisorRecommendationFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IAdvisorRecommendationUpdater _updater;

    public AdvisorRecommendationFunction(IAuthenticated authenticatedResourceManager, IAdvisorRecommendationUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater; 
    }

    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
