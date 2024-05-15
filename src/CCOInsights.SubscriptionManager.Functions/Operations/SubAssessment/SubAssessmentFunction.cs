using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.SubAssessment;

[OperationDescriptor(DashboardType.Governance, nameof(SubAssessmentFunction))]
public class SubAssessmentFunction(IAuthenticated authenticatedResourceManager, ISubAssessmentUpdater updater)
    : IOperation
{
    [Function(nameof(SubAssessmentFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
