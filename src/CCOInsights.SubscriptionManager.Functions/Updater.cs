using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions.Operations;
using CCOInsights.SubscriptionManager.Helpers;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions;

public interface IUpdater
{
    Task UpdateAsync(string executionId, ISubscription subscription, CancellationToken cancellationToken = default);
}

public abstract class Updater<TResponse, TEntity> : IUpdater
    where TResponse : IAzureResponse
    where TEntity : BaseEntity<TResponse>
{
    private const int MAX_DEGREE_PARALLELISM = 10;

    private readonly IStorage _storage;
    private readonly ILogger _logger;
    private readonly IProvider<TResponse> _provider;

    protected Updater(IStorage storage, ILogger logger, IProvider<TResponse> provider)
    {
        _storage = storage;
        _logger = logger;
        _provider = provider;
    }

    public async Task UpdateAsync(string executionId, ISubscription subscription, CancellationToken cancellationToken = default)
    {
        var processed = 0;
        var models = await _provider.GetAsync(subscription?.SubscriptionId, cancellationToken);

        //await models.AsyncParallelForEach(async model =>
        //{
        //    try
        //    {
        //        if (ShouldIngest(model))
        //        {
        //            var azureEntity = Map(executionId, subscription, model);
        //            await _storage.UpdateItemAsync(azureEntity.Id, azureEntity, cancellationToken);
        //            _logger.LogInformation($"Resource {model.Id} processed successfully. Subscription {subscription?.DisplayName} with id {subscription?.SubscriptionId} ");
        //            processed++;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        _logger.LogError(ex, $"Unexpected error processing resource {model.Id}: {ex.Message}.");
        //    }
        //}, MAX_DEGREE_PARALLELISM);

        var entities = models.Select(model => Map(executionId, subscription, model)).ToList();
        await _storage.UpdateItemAsync($"{subscription?.SubscriptionId}-{DateTime.UtcNow}", entities, cancellationToken);

        _logger.LogInformation($"{typeof(TEntity).Name}: Subscription {subscription?.DisplayName} with id {subscription?.SubscriptionId} processed {processed}/{models.Count()} resources successfully.");
    }

    protected abstract TEntity Map(string executionId, ISubscription subscription, TResponse response);

    protected virtual bool ShouldIngest(TResponse response) => true;
}
