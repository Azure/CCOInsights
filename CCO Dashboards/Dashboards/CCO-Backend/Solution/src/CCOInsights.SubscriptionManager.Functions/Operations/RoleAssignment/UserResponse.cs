namespace CCOInsights.SubscriptionManager.Functions.Operations.RoleAssignment;

public class UserResponse : AzureResponse
{
    public string Name { get; init; }
    public string Surname { get; init; }
    public string Upn { get; init; }
}