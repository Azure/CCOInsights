using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Subscriptions;

public interface ISubscriptionsUpdater : IUpdater { }
public class SubscriptionsUpdater : Updater<SubscriptionsResponse, Subscriptions>, ISubscriptionsUpdater
{
    public SubscriptionsUpdater(IStorage storage, ILogger<SubscriptionsUpdater> logger, ISubscriptionProvider provider) : base(storage, logger, provider)
    {
    }

    protected override Subscriptions Map(string executionId, ISubscription subscription, SubscriptionsResponse response) =>
        Subscriptions.From(executionId, response);
}