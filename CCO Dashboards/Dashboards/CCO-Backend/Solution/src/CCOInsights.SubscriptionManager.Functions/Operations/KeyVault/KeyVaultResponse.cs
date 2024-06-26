namespace CCOInsights.SubscriptionManager.Functions.Operations.KeyVault;

public class KeyVaultResponse : AzureResponse
{
    public string Location { get; set; }
    public Systemdata SystemData { get; set; }
    public Properties Properties { get; set; }
}

public class Systemdata
{
    public string CreatedBy { get; set; }
    public string CreatedByType { get; set; }
    public DateTime CreatedAt { get; set; }
    public string LastModifiedBy { get; set; }
    public string LastModifiedByType { get; set; }
    public DateTime LastModifiedAt { get; set; }
}

public class Properties
{
    public Sku Sku { get; set; }
    public string TenantId { get; set; }
    public Accesspolicy[] AccessPolicies { get; set; }
    public bool EnabledForDeployment { get; set; }
    public bool EnabledForDiskEncryption { get; set; }
    public bool EnabledForTemplateDeployment { get; set; }
    public bool EnableSoftDelete { get; set; }
    public int SoftDeleteRetentionInDays { get; set; }
    public bool EnableRbacAuthorization { get; set; }
    public string VaultUri { get; set; }
    public string ProvisioningState { get; set; }
    public string PublicNetworkAccess { get; set; }
}

public class Sku
{
    public string Family { get; set; }
    public string Name { get; set; }
}

public class Accesspolicy
{
    public string TenantId { get; set; }
    public string ObjectId { get; set; }
    public Permissions Permissions { get; set; }
}

public class Permissions
{
    public string[] Keys { get; set; }
    public string[] Secrets { get; set; }
    public string[] Certificates { get; set; }
}