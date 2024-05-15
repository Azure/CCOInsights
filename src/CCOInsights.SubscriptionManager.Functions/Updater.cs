using CCOInsights.SubscriptionManager.Functions.Operations;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions;

public interface IUpdater
{
    Task UpdateAsync(string executionId, ISubscription subscription, CancellationToken cancellationToken = default);
}

public abstract class Updater<TResponse, TEntity>(IStorage storage, ILogger logger, IProvider<TResponse> provider)
    : IUpdater
    where TResponse : IAzureResponse
    where TEntity : BaseEntity<TResponse>
{
    public async Task UpdateAsync(string executionId, ISubscription subscription, CancellationToken cancellationToken = default)
    {
        var models = await provider.GetAsync(subscription?.SubscriptionId, cancellationToken);

        var entities = models.Where(ShouldIngest).Select(model => Map(executionId, subscription, model)).ToList();
        if (!entities.Any()) return;
        await storage.UpdateItemAsync($"{subscription?.SubscriptionId}-{DateTime.UtcNow:yyyyMMdd}", DataLakeContainerProvider.GetContainer(entities.FirstOrDefault().GetType()), entities, cancellationToken);

        logger.LogInformation("{Entity}: Subscription {SubscriptionName} with id {SubscriptionId} processed {Count} resources successfully.", 
            typeof(TEntity).Name, 
            subscription?.DisplayName,
            subscription?.SubscriptionId,
            entities.Count);
    }

    protected abstract TEntity Map(string executionId, ISubscription subscription, TResponse response);

    protected virtual bool ShouldIngest(TResponse response) => true;
}
