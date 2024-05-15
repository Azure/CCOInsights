using Microsoft.Graph;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Users;

public interface IUsersProvider : IProvider<UsersResponse> { }
public class UsersProvider(GraphServiceClient graphServiceClient, UsersMapper mapper) : IUsersProvider
{
    public async Task<IEnumerable<UsersResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var result = await graphServiceClient.Users.Request().GetAsync(cancellationToken);

        var response = result.Select(x => mapper.UserToUsersResponse(x)).ToList();

        while (result.NextPageRequest != null)
        {
            result = await result.NextPageRequest.GetAsync(cancellationToken);
            response.AddRange(result.Select(x => mapper.UserToUsersResponse(x)).ToList());
        }
        return response;
    }


    private UsersResponse Map(Microsoft.Graph.User user)
    {
        return (UsersResponse)user;
    }
}
