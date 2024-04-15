using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Helpers;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.AppServicePlans;

[OperationDescriptor(DashboardType.Infrastructure, nameof(AppServicePlansFunction))]
public class AppServicePlansFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IAppServicePlansUpdater _updater;

    public AppServicePlansFunction(IAuthenticated authenticatedResourceManager, IAppServicePlansUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [FunctionName(nameof(AppServicePlansFunction))]
    public async Task Execute([ActivityTrigger] IDurableActivityContext context, System.Threading.CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(context.InstanceId, subscription, cancellationToken), 1);
    }
}