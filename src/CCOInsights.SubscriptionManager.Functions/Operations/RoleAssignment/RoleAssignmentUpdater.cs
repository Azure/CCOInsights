using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.RoleAssignment;

public interface IRoleAssignmentUpdater : IUpdater { }
public class RoleAssignmentUpdater : IRoleAssignmentUpdater
{
    private readonly IRoleAssignmentProvider _roleAssignmentProvider;
    private readonly IUsersProvider _usersProvider;
    private readonly IStorage _storage;
    private readonly ILogger<RoleAssignmentUpdater> _logger;

    public RoleAssignmentUpdater(IRoleAssignmentProvider roleAssignmentProvider, IUsersProvider usersProvider, IStorage storage, ILogger<RoleAssignmentUpdater> logger)
    {
        _roleAssignmentProvider = roleAssignmentProvider;
        _usersProvider = usersProvider;
        _storage = storage;
        _logger = logger;
    }

    public async Task UpdateAsync(string executionId, ISubscription subscription, CancellationToken cancellationToken = default)
    {
        var roleAssignments = await _roleAssignmentProvider.GetAsync(subscription.SubscriptionId, cancellationToken);
        var entities = new List<RoleAssignment>();
        foreach (var roleAssignment in roleAssignments)
        {
            var users = await _usersProvider.GetAsync(roleAssignment.Properties.PrincipalId, cancellationToken);
            entities.AddRange(users.Select(user => RoleAssignment.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, roleAssignment, user)));
        }
        if (!entities.Any()) return;
        await _storage.UpdateItemAsync($"{subscription?.SubscriptionId}-{DateTime.UtcNow:yyyyMMdd}", DataLakeContainerProvider.GetContainer(entities.FirstOrDefault().GetType()), entities, cancellationToken);

        _logger.LogInformation("{Entity}: Subscription {SubscriptionName} with id {SubscriptionId} processed {Count} resources successfully.",
            nameof(RoleAssignment),
            subscription.DisplayName,
            subscription.SubscriptionId,
            entities.Count);
    }
}
