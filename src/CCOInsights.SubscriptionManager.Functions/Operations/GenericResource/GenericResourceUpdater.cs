using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.GenericResource;

public interface IResourcesUpdater : IUpdater { }
public class GenericResourceUpdater : IResourcesUpdater
{
    private readonly IStorage _storage;
    private readonly ILogger<GenericResourceUpdater> _logger;
    private readonly IGenericResourceProvider _provider;

    public GenericResourceUpdater(IStorage storage, ILogger<GenericResourceUpdater> logger, IGenericResourceProvider provider)
    {
        _storage = storage;
        _logger = logger;
        _provider = provider;
    }

    public async Task UpdateAsync(string executionId, ISubscription subscription, CancellationToken cancellationToken = default)
    {
        var models = await _provider.GetAsync(subscription.SubscriptionId, cancellationToken);

        var entities = models.Select(model => GenericResource.From(subscription.Inner.TenantId, subscription.SubscriptionId, model.GenericResource, model.Inner)).ToList();
        if (!entities.Any()) return;
        await _storage.UpdateItemAsync($"{subscription?.SubscriptionId}-{DateTime.UtcNow:yyyyMMdd}", $"{entities.FirstOrDefault().GetType().Name.ToLower()}s", entities, cancellationToken);

        _logger.LogInformation("{Entity}: Subscription {SubscriptionName} with id {SubscriptionId} processed {Count} resources successfully.",
            nameof(GenericResource),
            subscription.DisplayName,
            subscription.SubscriptionId,
            entities.Count);
    }
}
