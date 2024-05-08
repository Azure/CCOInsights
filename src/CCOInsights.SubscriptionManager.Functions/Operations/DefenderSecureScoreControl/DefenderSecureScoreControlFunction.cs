using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Helpers;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderSecureScoreControl;

[OperationDescriptor(DashboardType.Governance, nameof(DefenderSecureScoreControlFunction))]
public class DefenderSecureScoreControlFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IDefenderSecureScoreControlUpdater _updater;

    public DefenderSecureScoreControlFunction(IAuthenticated authenticatedResourceManager, IDefenderSecureScoreControlUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [FunctionName(nameof(DefenderSecureScoreControlFunction))]
    public async Task Execute([ActivityTrigger] IDurableActivityContext context, System.Threading.CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(context.InstanceId, subscription, cancellationToken), 1);
    }
}