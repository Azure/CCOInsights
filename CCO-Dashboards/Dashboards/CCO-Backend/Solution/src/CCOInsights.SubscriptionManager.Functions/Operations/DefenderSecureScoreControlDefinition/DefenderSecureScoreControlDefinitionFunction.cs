namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderSecureScoreControlDefinition;

[OperationDescriptor(DashboardType.Governance, nameof(DefenderSecureScoreControlDefinitionFunction))]
public class DefenderSecureScoreControlDefinitionFunction
    (IDefenderSecureScoreControlDefinitionUpdater updater) : IOperation
{
    [Function(nameof(DefenderSecureScoreControlDefinitionFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), null, cancellationToken);
    }
}
