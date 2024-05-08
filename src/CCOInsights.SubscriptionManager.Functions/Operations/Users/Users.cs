namespace CCOInsights.SubscriptionManager.Functions.Operations.Users;

public class Users : BaseEntity<UsersResponse>
{
    protected Users(string id, string executionId, UsersResponse value) : base(id, executionId, value)
    {
    }

    public static Users From(string executionId, UsersResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new Users(id, executionId, response);
    }
}