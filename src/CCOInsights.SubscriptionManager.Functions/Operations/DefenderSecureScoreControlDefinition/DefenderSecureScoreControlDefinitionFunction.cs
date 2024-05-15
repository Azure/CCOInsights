using System.Threading.Tasks;



namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderSecureScoreControlDefinition;

[OperationDescriptor(DashboardType.Governance, nameof(DefenderSecureScoreControlDefinitionFunction))]
public class DefenderSecureScoreControlDefinitionFunction : IOperation
{
    private readonly IDefenderSecureScoreControlDefinitionUpdater _updater;

    public DefenderSecureScoreControlDefinitionFunction(IDefenderSecureScoreControlDefinitionUpdater updater)
    {
        _updater = updater;
    }

    [Function(nameof(DefenderSecureScoreControlDefinitionFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        await _updater.UpdateAsync(executionContext.InvocationId, null, cancellationToken);
    }
}
