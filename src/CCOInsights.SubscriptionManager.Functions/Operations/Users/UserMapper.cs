using Microsoft.Graph.Models;
using Riok.Mapperly.Abstractions;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Users;

[Mapper]
public partial class UsersMapper
{
    public partial UsersResponse UserToUsersResponse(User user);
}
