namespace CCOInsights.SubscriptionManager.Functions;

public static class DataLakeContainerProvider
{
    private static readonly IDictionary<Type, string> ContainerNames = new Dictionary<Type, string>
    {
        { typeof(Operations.AdvisorRecommendations.AdvisorRecommendation), "advisorrecommendations" },
        { typeof(Operations.AdvisorScore.AdvisorScore), "advisorscores" },
        { typeof(Operations.AppServicePlans.AppServicePlans), "appserviceplans" },
        { typeof(Operations.Blueprint.Blueprint), "blueprints" },
        { typeof(Operations.BlueprintArtifacts.BlueprintArtifacts), "blueprintartifacts" },
        { typeof(Operations.BlueprintAssignments.BlueprintAssignments), "blueprintassignments" },
        { typeof(Operations.BlueprintPublished.BlueprintPublished), "blueprintpublisheds" },
        { typeof(Operations.ComputeUsage.ComputeUsage), "computeusages" },
        { typeof(Operations.DefenderAlert.DefenderAlert), "defenderalerts" },
        { typeof(Operations.DefenderAssessment.DefenderAssessment), "defenderassessments" },
        { typeof(Operations.DefenderAssessmentsMetadata.DefenderAssessmentsMetadata), "defenderassessmentsmetadatas" },
        { typeof(Operations.DefenderSecureScoreControl.DefenderSecureScoreControl), "defendersecurescorecontrols" },
        { typeof(Operations.DefenderSecureScoreControlDefinition.DefenderSecureScoreControlDefinition), "defendersecurescorecontroldefinitions" },
        { typeof(Operations.Disks.Disks), "disks" },
        { typeof(Operations.Entity.Entity), "entities" },
        { typeof(Operations.GenericResource.GenericResource), "genericresources" },
        { typeof(Operations.Groups.Groups), "groups" },
        { typeof(Operations.KeyVault.KeyVault), "keyvaults" },
        { typeof(Operations.Location.Location), "locations" },
        { typeof(Operations.NetworkSecurityGroups.NetworkSecurityGroup), "networksecuritygroups" },
        { typeof(Operations.NetworkUsages.NetworkUsages), "networkusages" },
        { typeof(Operations.Nic.Nic), "nics" },
        { typeof(Operations.PolicyDefinitions.PolicyDefinitions), "policydefinitions" },
        { typeof(Operations.PolicySetDefinitions.PolicySetDefinitions), "policysetdefinitions" },
        { typeof(Operations.PolicyState.PolicyState), "policystates" },
        { typeof(Operations.Pricing.Pricing), "pricings" },
        { typeof(Operations.PublicIPs.PublicIPs), "publicips" },
        { typeof(Operations.ResourceGroup.ResourceGroup), "resourcegroups" },
        { typeof(Operations.Resources.Resource), "resources" },
        { typeof(Operations.RoleAssignment.RoleAssignment), "roleassignments" },
        { typeof(Operations.RoleDefinitions.RoleDefinitions), "roledefinitions" },
        { typeof(Operations.SecurityTasks.SecurityTask), "securitytasks" },
        { typeof(Operations.ServicePrincipals.ServicePrincipal), "serviceprincipals" },
        { typeof(Operations.Sites.Site), "sites" },
        { typeof(Operations.StorageUsage.StorageUsage), "storageusages" },
        { typeof(Operations.SubAssessment.SubAssessment), "subassessments" },
        { typeof(Operations.Subscriptions.Subscriptions), "subscriptions" },
        { typeof(Operations.Users.Users), "users" },
        { typeof(Operations.VirtualMachine.VirtualMachine), "virtualmachines" },
        { typeof(Operations.VirtualMachineExtensions.VirtualMachineExtensions), "virtualmachineextensions" },
        { typeof(Operations.VirtualMachinePatch.VirtualMachinePatch), "virtualmachinepatchs" },
        { typeof(Operations.VirtualNetworks.VirtualNetworks), "virtualnetworks" },
    };

    public static string GetContainer(Type type)
    {
        if (!ContainerNames.TryGetValue(type, out var containerName))
        {
            throw new InvalidOperationException($"Container name for type {type.Name} not found.");
        }

        return containerName;
    }
}
