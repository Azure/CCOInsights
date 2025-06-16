using CCOInsights.SubscriptionManager.Functions.Operations.ServicePrincipals;
using Microsoft.DurableTask.Protobuf;
using Microsoft.Graph;
using Microsoft.Graph.Models;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Groups;

public interface IGroupsProvider : IProvider<GroupsResponse> { }
public class GroupsProvider(GraphServiceClient graphServiceClient, GroupsMapper mapper) : IGroupsProvider
{
    public async Task<IEnumerable<GroupsResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var result = await graphServiceClient.Groups.GetAsync(null, cancellationToken);

        var responseList = new List<GroupsResponse>();

        var pageIterator = PageIterator<Microsoft.Graph.Models.Group, GroupCollectionResponse>.CreatePageIterator(graphServiceClient, result, (Microsoft.Graph.Models.Group element) => { responseList.Add(mapper.GroupToGroupsResponse(element)); return true; });

        await pageIterator.IterateAsync(cancellationToken);
        return responseList;

        
    }
}
