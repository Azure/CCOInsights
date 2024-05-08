using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Graph;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Users;

public interface IUsersProvider : IProvider<UsersResponse> { }
public class UsersProvider : IUsersProvider
{
    private readonly GraphServiceClient _graphServiceClient;
    private readonly UsersMapper _mapper;

    public UsersProvider(GraphServiceClient graphServiceClient, UsersMapper mapper)
    {
        _graphServiceClient = graphServiceClient;
        _mapper = mapper;
    }

    public async Task<IEnumerable<UsersResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var result = await _graphServiceClient.Users.Request().GetAsync(cancellationToken);

        var response = result.Select(x => _mapper.UserToUsersResponse(x)).ToList();

        while (result.NextPageRequest != null)
        {
            result = await result.NextPageRequest.GetAsync(cancellationToken);
            response.AddRange(result.Select(x => _mapper.UserToUsersResponse(x)).ToList());
        }
        return response;
    }


    private UsersResponse Map(Microsoft.Graph.User user)
    {
        return (UsersResponse)user;
    }
}