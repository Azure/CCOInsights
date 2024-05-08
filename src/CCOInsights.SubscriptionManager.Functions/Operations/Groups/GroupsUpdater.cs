using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Groups;

public interface IGroupsUpdater : IUpdater { }
public class GroupsUpdater : Updater<GroupsResponse, Groups>, IGroupsUpdater
{
    public GroupsUpdater(IStorage storage, ILogger<GroupsUpdater> logger, IGroupsProvider provider) : base(storage, logger, provider)
    {
    }

    protected override Groups Map(string executionId, ISubscription subscription, GroupsResponse response) =>
        Groups.From(executionId, response);
}