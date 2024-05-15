using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.GenericResource;

public interface IResourcesUpdater : IUpdater { }
public class GenericResourceUpdater(IStorage storage, ILogger<GenericResourceUpdater> logger,
        IGenericResourceProvider provider)
    : IResourcesUpdater
{
    public async Task UpdateAsync(string executionId, ISubscription subscription, CancellationToken cancellationToken = default)
    {
        var models = await provider.GetAsync(subscription.SubscriptionId, cancellationToken);

        var entities = models.Select(model => GenericResource.From(subscription.Inner.TenantId, subscription.SubscriptionId, model.GenericResource, model.Inner)).ToList();
        if (!entities.Any()) return;
        await storage.UpdateItemAsync($"{subscription?.SubscriptionId}-{DateTime.UtcNow:yyyyMMdd}", DataLakeContainerProvider.GetContainer(entities.FirstOrDefault().GetType()), entities, cancellationToken);

        logger.LogInformation("{Entity}: Subscription {SubscriptionName} with id {SubscriptionId} processed {Count} resources successfully.",
            nameof(GenericResource),
            subscription.DisplayName,
            subscription.SubscriptionId,
            entities.Count);
    }
}
