using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.RoleAssignment;

public class RoleAssignmentResponse : AzureResponse
{
    [JsonProperty("properties")]
    public RoleAssignmentProperties Properties { get; set; }
}

public class RoleAssignmentProperties
{
    [JsonProperty("roleDefinitionId")]
    public string RoleDefinitionId { get; set; }

    [JsonProperty("principalId")]
    public string PrincipalId { get; set; }

    [JsonProperty("scope")]
    public string Scope { get; set; }

    [JsonProperty("upn")]
    public string Upn { get; set; }

    [JsonProperty("userName")]
    public string UserName { get; set; }

    [JsonProperty("userSurname")]
    public string UserSurname { get; set; }
}