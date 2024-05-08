using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Helpers;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
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

    [FunctionName(nameof(AdvisorRecommendationFunction))]
    public async Task Execute([ActivityTrigger] IDurableActivityContext context, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(context.InstanceId, subscription, cancellationToken), 1);
    }

}