using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Graph;

namespace CCOInsights.SubscriptionManager.Functions.Operations.RoleAssignment
{
    public interface IUsersProvider
    {
        Task<IEnumerable<UserResponse>> GetAsync(string principalId, CancellationToken cancellationToken = default);
    }
    public class UserProvider : IUsersProvider
    {
        private readonly GraphServiceClient _graphServiceClient;

        public UserProvider(GraphServiceClient graphServiceClient)
        {
            _graphServiceClient = graphServiceClient;
        }

        public async Task<IEnumerable<UserResponse>> GetAsync(string principalId, CancellationToken cancellationToken = default)
        {
            var users = new List<UserResponse>();
            try
            {
                var groupAndMembers = await _graphServiceClient.Groups[principalId].Request().Expand("members").GetAsync(cancellationToken);
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
                var graphUser = await _graphServiceClient.Users[principalId].Request().GetAsync(cancellationToken);
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
}
