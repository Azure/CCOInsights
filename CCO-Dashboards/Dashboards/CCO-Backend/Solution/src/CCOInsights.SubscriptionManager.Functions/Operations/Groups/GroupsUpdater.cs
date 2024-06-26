using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Groups;

public interface IGroupsUpdater : IUpdater { }
public class GroupsUpdater(IStorage storage, ILogger<GroupsUpdater> logger, IGroupsProvider provider)
    : Updater<GroupsResponse, Groups>(storage, logger, provider), IGroupsUpdater
{
    protected override Groups Map(string executionId, ISubscription subscription, GroupsResponse response) =>
        Groups.From(executionId, response);
}