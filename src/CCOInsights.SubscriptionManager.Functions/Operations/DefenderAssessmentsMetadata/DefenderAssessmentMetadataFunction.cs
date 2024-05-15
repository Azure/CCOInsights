using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderAssessmentsMetadata;

[OperationDescriptor(DashboardType.Governance, nameof(DefenderAssessmentMetadataFunction))]
public class DefenderAssessmentMetadataFunction(IAuthenticated authenticatedResourceManager,
        IDefenderAssessmentsMetadataUpdater updater)
    : IOperation
{
    [Function(nameof(DefenderAssessmentMetadataFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), subscription, cancellationToken), 1);
    }
}
