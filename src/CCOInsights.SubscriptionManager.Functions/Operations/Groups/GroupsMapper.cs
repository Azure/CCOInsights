using Microsoft.Graph.Models;
using Riok.Mapperly.Abstractions;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Groups;

[Mapper]
public partial class GroupsMapper
{
    public partial GroupsResponse GroupToGroupsResponse(Group group);
}
