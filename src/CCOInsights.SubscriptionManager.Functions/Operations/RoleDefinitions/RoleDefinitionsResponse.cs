namespace CCOInsights.SubscriptionManager.Functions.Operations.RoleDefinitions;

public class RoleDefinitionsPermission
{
    public List<string> Actions { get; set; }
    public List<string> NotActions { get; set; }
    public List<string> DataActions { get; set; }
    public List<object> NotDataActions { get; set; }
}

public class RoleDefinitionsProperties
{
    public string RoleName { get; set; }
    public string Type { get; set; }
    public string Description { get; set; }
    public List<string> AssignableScopes { get; set; }
    public List<RoleDefinitionsPermission> Permissions { get; set; }
    public DateTime CreatedOn { get; set; }
    public DateTime UpdatedOn { get; set; }
    public object CreatedBy { get; set; }
    public string UpdatedBy { get; set; }
}

public class RoleDefinitionsResponseList
{
    public List<RoleDefinitionsResponse> Value { get; set; }
}

public class RoleDefinitionsResponse : AzureResponse
{
    public RoleDefinitionsProperties Properties { get; set; }
}
