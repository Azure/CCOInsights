namespace CCOInsights.SubscriptionManager.Functions.Operations.Groups;

public class Groups : BaseEntity<GroupsResponse>
{
    protected Groups(string id, string executionId, GroupsResponse value) : base(id, executionId, value)
    {
    }

    public static Groups From(string executionId, GroupsResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new Groups(id, executionId, response);
    }
}