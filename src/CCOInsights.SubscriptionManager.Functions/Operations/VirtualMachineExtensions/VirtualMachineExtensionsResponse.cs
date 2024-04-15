namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachineExtensions;

public class VirtualMachineExtensionsResponse : AzureResponse
{
    public string Location { get; set; }
    public AzureVirtualMachineExtensionProperties Properties { get; set; }

}

public class AzureVirtualMachineExtensionProperties
{
    public bool autoUpgradeMinorVersion { get; set; }
    public string provisioningState { get; set; }
    public string publisher { get; set; }
    public string type { get; set; }
    public string typeHandlerVersion { get; set; }
    public bool suppressFailures { get; set; }
    public dynamic settings { get; set; }
    public string forceUpdateTag { get; set; }
    public bool enableAutomaticUpgrade { get; set; }
    public dynamic protectedSettings { get; set; }
    public Instanceview instanceView { get; set; }
}

public class Instanceview
{
    public string name { get; set; }
    public string type { get; set; }
    public string typeHandlerVersion { get; set; }
    public AzureVirtualMachineExtensionSubstatus[] substatuses { get; set; }
    public AzureVirtualMachineExtensionStatus[] statuses { get; set; }
}

public class AzureVirtualMachineExtensionSubstatus
{
    public string code { get; set; }
    public string level { get; set; }
    public string displayStatus { get; set; }
    public string message { get; set; }
    public DateTime time { get; set; }
}

public class AzureVirtualMachineExtensionStatus
{
    public string code { get; set; }
    public string level { get; set; }
    public string displayStatus { get; set; }
    public string message { get; set; }
    public DateTime time { get; set; }
}