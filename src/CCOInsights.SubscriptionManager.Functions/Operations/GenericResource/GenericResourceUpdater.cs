using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Helpers;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.GenericResource
{
    public interface IResourcesUpdater : IUpdater { }
    public class GenericResourceUpdater : IResourcesUpdater
    {
        private const int MAX_DEGREE_PARALLELISM = 10;

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
            var processed = 0;
            var models = await _provider.GetAsync(subscription.SubscriptionId, cancellationToken);
            await models.AsyncParallelForEach(async model =>
            {
                try
                {
                    var azureEntity = GenericResource.From(subscription.Inner.TenantId, subscription.SubscriptionId, model.GenericResource, model.Inner);
                    await _storage.UpdateItemAsync(azureEntity.Id, azureEntity, cancellationToken);
                    _logger.LogInformation($"Resource {model.GenericResource.Id} processed successfully.");
                    processed++;
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, $"Unexpected error processing resource {model.GenericResource.Id}: {ex.Message}.");
                }
            }, MAX_DEGREE_PARALLELISM);

            _logger.LogInformation($"{nameof(GenericResource)}: Subscription {subscription.DisplayName} with id {subscription.SubscriptionId} processed {processed}/{models.Count()} resources successfully.");
        }
    }
}
