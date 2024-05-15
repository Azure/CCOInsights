using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderAlert;

[OperationDescriptor(DashboardType.Infrastructure, nameof(DefenderAlertFunction))]
public class DefenderAlertFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IDefenderAlertUpdater _updater;

    public DefenderAlertFunction(IAuthenticated authenticatedResourceManager, IDefenderAlertUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(DefenderAlertFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
