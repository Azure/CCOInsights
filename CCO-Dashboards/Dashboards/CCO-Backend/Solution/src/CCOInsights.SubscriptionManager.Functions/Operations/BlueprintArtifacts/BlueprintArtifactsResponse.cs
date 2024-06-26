namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintArtifacts;

public class BlueprintArtifactsResponse : AzureResponse
{
    public string Kind { get; set; }
    public BlueprintArtifactProperties Properties { get; set; }
}

public class BlueprintArtifactProperties
{
    public string Description { get; set; }
    public string DisplayName { get; set; }
    public string[] DependsOn { get; set; }
    public string PolicyDefinitionId { get; set; }
    public string ResourceGroup { get; set; }
    public string PrincipalIds { get; set; }
    public string RoleDefinitionId { get; set; }
    public object Template { get; set; }
}
