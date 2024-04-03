using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions.Operations;
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
        var models = await _provider.GetAsync(subscription?.SubscriptionId, cancellationToken);

        var entities = models.Where(ShouldIngest).Select(model => Map(executionId, subscription, model)).ToList();
        if (!entities.Any()) return;
        await _storage.UpdateItemAsync($"{subscription?.SubscriptionId}-{DateTime.UtcNow:yyyyMMdd}", $"{entities.FirstOrDefault().GetType().Name.ToLower()}s", entities, cancellationToken);

        _logger.LogInformation("{Entity}: Subscription {SubscriptionName} with id {SubscriptionId} processed {Count} resources successfully.", 
            typeof(TEntity).Name, 
            subscription?.DisplayName,
            subscription?.SubscriptionId,
            entities.Count);
    }

    protected abstract TEntity Map(string executionId, ISubscription subscription, TResponse response);

    protected virtual bool ShouldIngest(TResponse response) => true;
}
