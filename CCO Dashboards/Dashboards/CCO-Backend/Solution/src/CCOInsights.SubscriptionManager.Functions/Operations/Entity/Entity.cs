namespace CCOInsights.SubscriptionManager.Functions.Operations.Entity;

public class Entity : BaseEntity<EntityResponse>
{
    private Entity(string id, string executionId, EntityResponse value) : base(id, executionId, value)
    {
    }

    public static Entity From(string executionId, EntityResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new Entity(id, executionId, response);
    }
}
