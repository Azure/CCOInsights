using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderAssessment;

[OperationDescriptor(DashboardType.Governance, nameof(DefenderAssessmentFunction))]
public class DefenderAssessmentFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IDefenderAssessmentUpdater _updater;

    public DefenderAssessmentFunction(IAuthenticated authenticatedResourceManager, IDefenderAssessmentUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(DefenderAssessmentFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}