using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Pricing;

[OperationDescriptor(DashboardType.Governance, nameof(PricingFunction))]
public class PricingFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IPricingUpdater _updater;

    public PricingFunction(IAuthenticated authenticatedResourceManager, IPricingUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(PricingFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
