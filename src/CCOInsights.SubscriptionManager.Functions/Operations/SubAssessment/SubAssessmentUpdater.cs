using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.SubAssessment
{
    public interface ISubAssessmentUpdater : IUpdater { }
    public class SubAssessmentUpdater : Updater<SubAssessmentResponse, SubAssessment>, ISubAssessmentUpdater
    {
        public SubAssessmentUpdater(IStorage storage, ILogger<SubAssessmentUpdater> logger, ISubAssessmentProvider provider) : base(storage, logger, provider)
        {
        }

        protected override SubAssessment Map(string executionId, ISubscription subscription, SubAssessmentResponse response) =>
            SubAssessment.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, response);
    }
}
