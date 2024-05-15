using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderAssessmentsMetadata;

[OperationDescriptor(DashboardType.Governance, nameof(DefenderAssessmentMetadataFunction))]
public class DefenderAssessmentMetadataFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IDefenderAssessmentsMetadataUpdater _updater;

    public DefenderAssessmentMetadataFunction(IAuthenticated authenticatedResourceManager, IDefenderAssessmentsMetadataUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(DefenderAssessmentMetadataFunction))]
    public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
