namespace CCOInsights.SubscriptionManager.Functions.Operations.Location;

public class Location : BaseEntity<LocationResponse>
{
    private Location(string id, string tenantId, string subscriptionId, string executionId, LocationResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static Location From(string tenantId, string subscriptionId, string executionId, LocationResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new Location(id, tenantId, subscriptionId, executionId, response);
    }
}