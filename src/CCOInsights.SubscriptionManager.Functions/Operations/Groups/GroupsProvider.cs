using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Graph;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Groups;

public interface IGroupsProvider : IProvider<GroupsResponse> { }
public class GroupsProvider : IGroupsProvider
{
    private readonly GraphServiceClient _graphServiceClient;
    private readonly GroupsMapper _mapper;

    public GroupsProvider(GraphServiceClient graphServiceClient, GroupsMapper mapper)
    {
        _graphServiceClient = graphServiceClient;
        _mapper = mapper;
    }

    public async Task<IEnumerable<GroupsResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var result = await _graphServiceClient.Groups.Request().GetAsync(cancellationToken);

        var response = result.Select(x => _mapper.GroupToGroupsResponse(x)).ToList();

        while (result.NextPageRequest != null)
        {
            result = await result.NextPageRequest.GetAsync(cancellationToken);
            response.AddRange(result.Select(x => _mapper.GroupToGroupsResponse(x)).ToList());
        }
        return response;
    }
}