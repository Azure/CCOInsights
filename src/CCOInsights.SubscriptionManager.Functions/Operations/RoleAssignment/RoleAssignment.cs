namespace CCOInsights.SubscriptionManager.Functions.Operations.RoleAssignment;

public class RoleAssignment : BaseEntity<RoleAssignmentResponse>
{
    private RoleAssignment(string id, string tenantId, string subscriptionId, string executionId, RoleAssignmentResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static RoleAssignment From(string tenantId, string subscriptionId, string executionId, RoleAssignmentResponse roleAssignmentResponse, UserResponse userResponse)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(roleAssignmentResponse.Id + userResponse.Upn);
        var id = Convert.ToBase64String(plainTextBytes);

        roleAssignmentResponse.Properties.Upn = userResponse.Upn;
        roleAssignmentResponse.Properties.UserName = userResponse.Name;
        roleAssignmentResponse.Properties.UserSurname = userResponse.Surname;

        return new RoleAssignment(id, tenantId, subscriptionId, executionId, roleAssignmentResponse);
    }
}