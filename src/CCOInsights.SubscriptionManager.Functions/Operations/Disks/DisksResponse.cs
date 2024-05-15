namespace CCOInsights.SubscriptionManager.Functions.Operations.Disks;

[GeneratedProvider("/providers/Microsoft.Compute/disks?api-version=2021-12-01")]
public class DisksResponse : AzureResponse
{
    public DisksProperties Properties { get; set; }
    public string location { get; set; }

}

public class DisksCreationData
{
    public string createOption { get; set; }
    public string sourceResourceId { get; set; }
    public DisksImageReference imageReference { get; set; }
}

public class DiskEncryptionKey
{
    public DisksSourceVault sourceVault { get; set; }
    public string secretUrl { get; set; }
}

public class DisksEncryption
{
    public string type { get; set; }
}

public class DisksEncryptionSetting
{
    public DiskEncryptionKey diskEncryptionKey { get; set; }
    public DisksKeyEncryptionKey keyEncryptionKey { get; set; }
}

public class DisksEncryptionSettingsCollection
{
    public bool enabled { get; set; }
    public List<DisksEncryptionSetting> encryptionSettings { get; set; }
}

public class DisksImageReference
{
    public string id { get; set; }
}

public class DisksKeyEncryptionKey
{
    public DisksSourceVault sourceVault { get; set; }
    public string keyUrl { get; set; }
}

public class DisksProperties
{
    public string osType { get; set; }
    public DisksCreationData creationData { get; set; }
    public int diskSizeGB { get; set; }
    public DisksEncryptionSettingsCollection encryptionSettingsCollection { get; set; }
    public DisksEncryption encryption { get; set; }
    public DateTime timeCreated { get; set; }
    public string provisioningState { get; set; }
}

public class DisksSourceVault
{
    public string id { get; set; }
}
