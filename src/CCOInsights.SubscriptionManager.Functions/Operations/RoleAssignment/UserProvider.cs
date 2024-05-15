using Microsoft.Graph;

namespace CCOInsights.SubscriptionManager.Functions.Operations.RoleAssignment;

public interface IUsersProvider
{
    Task<IEnumerable<UserResponse>> GetAsync(string principalId, CancellationToken cancellationToken = default);
}
public class UserProvider(GraphServiceClient graphServiceClient) : IUsersProvider
{
    public async Task<IEnumerable<UserResponse>> GetAsync(string principalId, CancellationToken cancellationToken = default)
    {
        var users = new List<UserResponse>();
        try
        {
            var groupAndMembers = await graphServiceClient.Groups[principalId].Request().Expand("members").GetAsync(cancellationToken);
            var usersInGroup = groupAndMembers.Members.ToList();
            usersInGroup.ForEach(user =>
                {
                    var graphUser = (User)user;
                    var model = new UserResponse
                    {
                        Name = graphUser.GivenName,
                        Surname = graphUser.Surname,
                        Upn = graphUser.UserPrincipalName,
                    };
                    users.Add(model);
                }
            );
        }
        catch (Exception)
        {
            var graphUser = await graphServiceClient.Users[principalId].Request().GetAsync(cancellationToken);
            var model = new UserResponse
            {
                Name = graphUser.GivenName,
                Surname = graphUser.Surname,
                Upn = graphUser.UserPrincipalName,
            };
            users.Add(model);
        }
        return users;
    }
}
