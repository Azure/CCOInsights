using System.Threading.Tasks;
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

    [Function(nameof(DefenderSecureScoreControlFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)

    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
