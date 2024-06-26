using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Subscriptions;

public interface ISubscriptionsUpdater : IUpdater { }
public class SubscriptionsUpdater(IStorage storage, ILogger<SubscriptionsUpdater> logger,
        ISubscriptionProvider provider)
    : Updater<SubscriptionsResponse, Subscriptions>(storage, logger, provider), ISubscriptionsUpdater
{
    protected override Subscriptions Map(string executionId, ISubscription subscription, SubscriptionsResponse response) =>
        Subscriptions.From(executionId, response);
}