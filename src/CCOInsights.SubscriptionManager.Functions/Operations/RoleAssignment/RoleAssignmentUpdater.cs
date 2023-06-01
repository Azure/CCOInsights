using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Helpers;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.RoleAssignment
{
    public interface IRoleAssignmentUpdater : IUpdater { }
    public class RoleAssignmentUpdater : IRoleAssignmentUpdater
    {
        private const int MAX_DEGREE_PARALLELISM = 10;

        private readonly IRoleAssignmentProvider _roleAssignmentProvider;
        private readonly IUsersProvider _usersProvider;
        private readonly IStorage _storage;
        private readonly ILogger<RoleAssignmentUpdater> _logger;
        private readonly string _executionId;

        public RoleAssignmentUpdater(IRoleAssignmentProvider roleAssignmentProvider, IUsersProvider usersProvider, IStorage storage, IDurableActivityContext context, ILogger<RoleAssignmentUpdater> logger)
        {
            _roleAssignmentProvider = roleAssignmentProvider;
            _usersProvider = usersProvider;
            _storage = storage;
            _logger = logger;
            _executionId = context.InstanceId;
        }

        public async Task UpdateAsync(string executionId, ISubscription subscription, CancellationToken cancellationToken = default)
        {
            var processed = 0;
            var roleAssignments = await _roleAssignmentProvider.GetAsync(subscription.SubscriptionId, cancellationToken);
            await roleAssignments.AsyncParallelForEach(async roleAssignment =>
            {
                try
                {
                    var users = await _usersProvider.GetAsync(roleAssignment.Properties.PrincipalId, cancellationToken);
                    await users.AsyncParallelForEach(async user =>
                    {
                        var roleAssignmentEntity = RoleAssignment.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, roleAssignment, user);
                        await _storage.UpdateItemAsync(roleAssignmentEntity.Id, roleAssignmentEntity, cancellationToken);
                        _logger.LogInformation($"Resource {roleAssignment.Id} processed successfully.");
                        processed++;
                    });
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, $"Unexpected error processing resource {roleAssignment.Id}: {ex.Message}.");
                }
            }, MAX_DEGREE_PARALLELISM);

            _logger.LogInformation($"{nameof(RoleAssignment)}: Subscription {subscription.DisplayName} with id {subscription.SubscriptionId} processed {processed}/{roleAssignments.Count()} resources successfully.");
        }
    }
}
