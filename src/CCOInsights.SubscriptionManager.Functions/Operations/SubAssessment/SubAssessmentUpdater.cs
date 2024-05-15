using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.SubAssessment;

public interface ISubAssessmentUpdater : IUpdater { }
public class SubAssessmentUpdater(IStorage storage, ILogger<SubAssessmentUpdater> logger,
        ISubAssessmentProvider provider)
    : Updater<SubAssessmentResponse, SubAssessment>(storage, logger, provider), ISubAssessmentUpdater
{
    protected override SubAssessment Map(string executionId, ISubscription subscription, SubAssessmentResponse response) =>
        SubAssessment.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
}