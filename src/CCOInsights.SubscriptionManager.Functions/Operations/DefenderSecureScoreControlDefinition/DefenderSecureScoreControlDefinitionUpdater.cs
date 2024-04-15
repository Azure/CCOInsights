using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderSecureScoreControlDefinition;

public interface IDefenderSecureScoreControlDefinitionUpdater : IUpdater { }
public class DefenderSecureScoreControlDefinitionUpdater : Updater<DefenderSecureScoreControlDefinitionResponse, DefenderSecureScoreControlDefinition>, IDefenderSecureScoreControlDefinitionUpdater
{
    public DefenderSecureScoreControlDefinitionUpdater(IStorage storage, ILogger<DefenderSecureScoreControlDefinitionUpdater> logger, IDefenderSecureScoreControlDefinitionProvider provider) : base(storage, logger, provider)
    {
    }

    protected override DefenderSecureScoreControlDefinition Map(string executionId, ISubscription subscription, DefenderSecureScoreControlDefinitionResponse response) =>
        DefenderSecureScoreControlDefinition.From(executionId, response);

    protected override bool ShouldIngest(DefenderSecureScoreControlDefinitionResponse? response) =>
        response != null;
}