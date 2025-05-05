using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderAssessmentsMetadata;
public interface IDefenderAssessmentsMetadataUpdater : IUpdater { }
public class DefenderAssessmentsMetadataUpdater(IStorage storage, ILogger<DefenderAssessmentsMetadataUpdater> logger, IDefenderAssessmentsMetadataProvider provider)
    : Updater<DefenderAssessmentsMetadataResponse, DefenderAssessmentsMetadata>(storage, logger, provider), IDefenderAssessmentsMetadataUpdater
{
    protected override DefenderAssessmentsMetadata Map(string executionId, ISubscription subscription, DefenderAssessmentsMetadataResponse response) => DefenderAssessmentsMetadata.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);

    protected override bool IsIncremental() => false;
}
