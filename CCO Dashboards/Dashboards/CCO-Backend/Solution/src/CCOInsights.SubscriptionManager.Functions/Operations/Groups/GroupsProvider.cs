using Microsoft.Graph;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Groups;

public interface IGroupsProvider : IProvider<GroupsResponse> { }
public class GroupsProvider(GraphServiceClient graphServiceClient, GroupsMapper mapper) : IGroupsProvider
{
    public async Task<IEnumerable<GroupsResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var result = await graphServiceClient.Groups.Request().GetAsync(cancellationToken);

        var response = result.Select(x => mapper.GroupToGroupsResponse(x)).ToList();

        while (result.NextPageRequest != null)
        {
            result = await result.NextPageRequest.GetAsync(cancellationToken);
            response.AddRange(result.Select(x => mapper.GroupToGroupsResponse(x)).ToList());
        }
        return response;
    }
}
