using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.PolicyState;

[OperationDescriptor(DashboardType.Governance, nameof(PolicyStateFunction))]
public class PolicyStateFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IPolicyStateUpdater _updater;

    public PolicyStateFunction(IAuthenticated authenticatedResourceManager, IPolicyStateUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(PolicyStateFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
