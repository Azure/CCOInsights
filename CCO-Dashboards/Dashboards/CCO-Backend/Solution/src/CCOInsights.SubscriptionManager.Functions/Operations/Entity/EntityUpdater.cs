using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Entity;

public interface IEntitiesUpdater : IUpdater { }
public class EntityUpdater(IStorage storage, ILogger<EntityUpdater> logger, IEntityProvider provider)
    : Updater<EntityResponse, Entity>(storage, logger, provider), IEntitiesUpdater
{
    protected override Entity Map(string executionId, ISubscription subscription, EntityResponse response) =>
        Entity.From(executionId, response);
}
