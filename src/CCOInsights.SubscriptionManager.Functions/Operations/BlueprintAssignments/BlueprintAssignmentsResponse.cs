using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.BlueprintAssignments;

[GeneratedProvider("/providers/Microsoft.Blueprint/blueprintAssignments?api-version=2018-11-01-preview")]
public class BlueprintAssignmentsResponse : AzureResponse
{
    [JsonProperty("identity")]
    public AzureBlueprintAssignmentIdentity Identity { get; set; }

    [JsonProperty("location")]
    public string Location { get; set; }

    [JsonProperty("properties")]
    public AzureBlueprintAssignmentProperties Properties { get; set; }
}

public class AzureBlueprintAssignmentIdentity
{
    [JsonProperty("principalId")]
    public string PrincipalId { get; set; }
    [JsonProperty("tenantId")]
    public string TenantId { get; set; }
    [JsonProperty("type")]
    public string Type { get; set; }
    [JsonProperty("userAssignedIdentities")]
    public Dictionary<string, AzureBlueprintAssignmentUserAssignedIdentity> UserAssignedIdentities { get; set; } = new();
}

public class AzureBlueprintAssignmentUserAssignedIdentity
{
    [JsonProperty("clientId")]
    public string ClientId { get; set; }
    [JsonProperty("principalId")]
    public string PrincipalId { get; set; }
}

public class AzureBlueprintAssignmentProperties
{
    [JsonProperty("blueprintId")]
    public string BlueprintId { get; set; }

    [JsonProperty("Description")]
    public string Description { get; set; }

    [JsonProperty("displayName")]
    public string DisplayName { get; set; }

    [JsonProperty("locks")]
    public AzureBlueprintAssignmentPropertiesLocks Locks { get; set; }

    [JsonProperty("parameters")]
    public Dictionary<string, AzureBlueprintAssignmentPropertiesParameters> Parameters { get; set; } = new();

    [JsonProperty("provisioningState")]
    public string ProvisioningState { get; set; }

    [JsonProperty("resourceGroups")]
    public Dictionary<string, AzureBlueprintAssignmentPropertiesResourceGroupValue> ResourceGroups { get; set; } = new();

    [JsonProperty("scope")]
    public string Scope { get; set; }

    [JsonProperty("status")]
    public AzureBlueprintAssignmentPropertiesStatus Status { get; set; }

    [JsonProperty("type")]
    public string Type { get; set; }
}

public class AzureBlueprintAssignmentPropertiesLocks
{
    [JsonProperty("excludedActions")]
    public List<string> ExcludedActions { get; set; } = new();

    [JsonProperty("excludedPrincipals")]
    public List<string> ExcludedPrincipals { get; set; } = new();

    [JsonProperty("assignmentLockMode")]
    public string AssignmentLockMode { get; set; }
}

public class AzureBlueprintAssignmentPropertiesParameters
{
    [JsonProperty("reference")]
    public AzureBlueprintAssignmentPropertiesParametersSecretValueReference Reference { get; set; }

    [JsonProperty("value")]
    public object Value { get; set; }
}

public class AzureBlueprintAssignmentPropertiesParametersSecretValueReference
{
    [JsonProperty("keyVault")]
    public AzureBlueprintAssignmentPropertiesParametersSecretValueReferenceKeyVaultReference KeyVault { get; set; }

    [JsonProperty("secretName")]
    public string SecretName { get; set; }

    [JsonProperty("secretVersion")]
    public string SecretVersion { get; set; }
}

public class AzureBlueprintAssignmentPropertiesParametersSecretValueReferenceKeyVaultReference
{
    [JsonProperty("id")]
    public string Id { get; set; }
}

public class AzureBlueprintAssignmentPropertiesResourceGroupValue
{
    [JsonProperty("location")]
    public string Location { get; set; }

    [JsonProperty("name")]
    public string Name { get; set; }
}

public class AzureBlueprintAssignmentPropertiesStatus
{
    [JsonProperty("lastModified")]
    public string LastModified { get; set; }

    [JsonProperty("managedResources")]
    public List<string> ManagedResources { get; set; } = new();

    [JsonProperty("timeCreated")]
    public string TimeCreated { get; set; }
}
