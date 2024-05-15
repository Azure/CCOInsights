using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.SubAssessment;

[OperationDescriptor(DashboardType.Governance, nameof(SubAssessmentFunction))]
public class SubAssessmentFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly ISubAssessmentUpdater _updater;

    public SubAssessmentFunction(IAuthenticated authenticatedResourceManager, ISubAssessmentUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(SubAssessmentFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
