using CCOInsights.SubscriptionManager.Functions.Operations.ServicePrincipals;
using Microsoft.DurableTask.Protobuf;
using Microsoft.Graph;
using Microsoft.Graph.Models;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Users;

public interface IUsersProvider : IProvider<UsersResponse> { }
public class UsersProvider(GraphServiceClient graphServiceClient, UsersMapper mapper) : IUsersProvider
{
    public async Task<IEnumerable<UsersResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var resultResponse = await graphServiceClient.Users.GetAsync(null, cancellationToken);

        var responseList = new List<UsersResponse>();

        var pageIterator = PageIterator<User, UserCollectionResponse>.CreatePageIterator(graphServiceClient, resultResponse, (Microsoft.Graph.Models.User element) => { responseList.Add(mapper.UserToUsersResponse(element)); return true; });

        await pageIterator.IterateAsync(cancellationToken);

        return responseList;
    }


    private UsersResponse Map(Microsoft.Graph.Models.User user)
    {
        return (UsersResponse)user;
    }
}
