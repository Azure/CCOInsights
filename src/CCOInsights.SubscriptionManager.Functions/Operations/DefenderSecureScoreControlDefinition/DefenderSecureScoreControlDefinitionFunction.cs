using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderSecureScoreControlDefinition;

[OperationDescriptor(DashboardType.Governance, nameof(DefenderSecureScoreControlDefinitionFunction))]
public class DefenderSecureScoreControlDefinitionFunction : IOperation
{
    private readonly IDefenderSecureScoreControlDefinitionUpdater _updater;

    public DefenderSecureScoreControlDefinitionFunction(IDefenderSecureScoreControlDefinitionUpdater updater)
    {
        _updater = updater;
    }

    [FunctionName(nameof(DefenderSecureScoreControlDefinitionFunction))]
    public async Task Execute([ActivityTrigger] IDurableActivityContext context, System.Threading.CancellationToken cancellationToken = default)
    {
        await _updater.UpdateAsync(context.InstanceId, null, cancellationToken);
    }
}