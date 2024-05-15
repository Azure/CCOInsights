using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.RoleAssignment;

public interface IRoleAssignmentUpdater : IUpdater { }
public class RoleAssignmentUpdater(IRoleAssignmentProvider roleAssignmentProvider, IUsersProvider usersProvider,
        IStorage storage, ILogger<RoleAssignmentUpdater> logger)
    : IRoleAssignmentUpdater
{
    public async Task UpdateAsync(string executionId, ISubscription subscription, CancellationToken cancellationToken = default)
    {
        var roleAssignments = await roleAssignmentProvider.GetAsync(subscription.SubscriptionId, cancellationToken);
        var entities = new List<RoleAssignment>();
        foreach (var roleAssignment in roleAssignments)
        {
            var users = await usersProvider.GetAsync(roleAssignment.Properties.PrincipalId, cancellationToken);
            entities.AddRange(users.Select(user => RoleAssignment.From(subscription.Inner.TenantId, subscription.SubscriptionId, executionId, roleAssignment, user)));
        }
        if (!entities.Any()) return;
        await storage.UpdateItemAsync($"{subscription?.SubscriptionId}-{DateTime.UtcNow:yyyyMMdd}", DataLakeContainerProvider.GetContainer(entities.FirstOrDefault().GetType()), entities, cancellationToken);

        logger.LogInformation("{Entity}: Subscription {SubscriptionName} with id {SubscriptionId} processed {Count} resources successfully.",
            nameof(RoleAssignment),
            subscription.DisplayName,
            subscription.SubscriptionId,
            entities.Count);
    }
}
