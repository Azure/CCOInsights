using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderAssessment;

[OperationDescriptor(DashboardType.Governance, nameof(DefenderAssessmentFunction))]
public class DefenderAssessmentFunction(IAuthenticated authenticatedResourceManager, IDefenderAssessmentUpdater updater)
    : IOperation
{
    [Function(nameof(DefenderAssessmentFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
