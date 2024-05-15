using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderSecureScoreControlDefinition;

public interface IDefenderSecureScoreControlDefinitionUpdater : IUpdater { }
public class DefenderSecureScoreControlDefinitionUpdater(IStorage storage,
        ILogger<DefenderSecureScoreControlDefinitionUpdater> logger,
        IDefenderSecureScoreControlDefinitionProvider provider)
    : Updater<DefenderSecureScoreControlDefinitionResponse, DefenderSecureScoreControlDefinition>(storage, logger,
        provider), IDefenderSecureScoreControlDefinitionUpdater
{
    protected override DefenderSecureScoreControlDefinition Map(string executionId, ISubscription subscription, DefenderSecureScoreControlDefinitionResponse response) =>
        DefenderSecureScoreControlDefinition.From(executionId, response);

    protected override bool ShouldIngest(DefenderSecureScoreControlDefinitionResponse? response) =>
        response != null;
}