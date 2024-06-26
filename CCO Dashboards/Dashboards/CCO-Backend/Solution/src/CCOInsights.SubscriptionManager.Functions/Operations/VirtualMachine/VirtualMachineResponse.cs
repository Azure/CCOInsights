using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachine;

public class VirtualMachineResponse : AzureResponse
{
    [JsonProperty("properties")]
    public VirtualMachineProperties Properties { get; set; }

    [JsonProperty("location")]
    public string Location { get; set; }

    [JsonProperty("tags")]
    public ProtectedSettingsClass Tags { get; set; }

    [JsonProperty("plan")]
    public Plan Plan { get; set; }

    [JsonProperty("resources")]
    public Resource[] Resources { get; set; }

    [JsonProperty("identity")]
    public Identity Identity { get; set; }

    [JsonProperty("zones")]
    public string[] Zones { get; set; }

    [JsonProperty("extendedLocation")]
    public ExtendedLocation ExtendedLocation { get; set; }
}

public class ExtendedLocation
{
    [JsonProperty("name")]
    public string Name { get; set; }

    [JsonProperty("type")]
    public string Type { get; set; }
}

public class Identity
{
    [JsonProperty("principalId")]
    public string PrincipalId { get; set; }

    [JsonProperty("tenantId")]
    public string TenantId { get; set; }

    [JsonProperty("type")]
    public string Type { get; set; }

    [JsonProperty("userAssignedIdentities")]
    public UserAssignedIdentities UserAssignedIdentities { get; set; }
}

public class UserAssignedIdentities
{
    [JsonProperty("key5688")]
    public Key5688 Key5688 { get; set; }
}

public class Key5688
{
    [JsonProperty("principalId")]
    public string PrincipalId { get; set; }

    [JsonProperty("clientId")]
    public string ClientId { get; set; }
}

public class Plan
{
    [JsonProperty("name")]
    public string Name { get; set; }

    [JsonProperty("publisher")]
    public string Publisher { get; set; }

    [JsonProperty("product")]
    public string Product { get; set; }

    [JsonProperty("promotionCode")]
    public string PromotionCode { get; set; }
}

public class VirtualMachineProperties
{
    [JsonProperty("vmId")]
    public string VmId { get; set; }

    [JsonProperty("availabilitySet")]
    public AvailabilitySet AvailabilitySet { get; set; }

    [JsonProperty("hardwareProfile")]
    public HardwareProfile HardwareProfile { get; set; }

    [JsonProperty("storageProfile")]
    public StorageProfile StorageProfile { get; set; }

    [JsonProperty("osProfile")]
    public OsProfile OsProfile { get; set; }

    [JsonProperty("networkProfile")]
    public NetworkProfile NetworkProfile { get; set; }

    [JsonProperty("provisioningState")]
    public string ProvisioningState { get; set; }

    [JsonProperty("additionalCapabilities")]
    public AdditionalCapabilities AdditionalCapabilities { get; set; }

    [JsonProperty("securityProfile")]
    public PropertiesSecurityProfile SecurityProfile { get; set; }

    [JsonProperty("diagnosticsProfile")]
    public DiagnosticsProfile DiagnosticsProfile { get; set; }

    [JsonProperty("virtualMachineScaleSet")]
    public AvailabilitySet VirtualMachineScaleSet { get; set; }

    [JsonProperty("proximityPlacementGroup")]
    public AvailabilitySet ProximityPlacementGroup { get; set; }

    [JsonProperty("priority")]
    public string Priority { get; set; }

    [JsonProperty("evictionPolicy")]
    public string EvictionPolicy { get; set; }

    [JsonProperty("billingProfile")]
    public BillingProfile BillingProfile { get; set; }

    [JsonProperty("host")]
    public AvailabilitySet Host { get; set; }

    [JsonProperty("hostGroup")]
    public AvailabilitySet HostGroup { get; set; }

    [JsonProperty("instanceView")]
    public InstanceView InstanceView { get; set; }

    [JsonProperty("licenseType")]
    public string LicenseType { get; set; }

    [JsonProperty("extensionsTimeBudget")]
    public string ExtensionsTimeBudget { get; set; }

    [JsonProperty("platformFaultDomain")]
    public long PlatformFaultDomain { get; set; }

    [JsonProperty("scheduledEventsProfile")]
    public ScheduledEventsProfile ScheduledEventsProfile { get; set; }

    [JsonProperty("userData")]
    public string UserData { get; set; }

    [JsonProperty("capacityReservation")]
    public CapacityReservation CapacityReservation { get; set; }

    [JsonProperty("applicationProfile")]
    public ApplicationProfile ApplicationProfile { get; set; }

    [JsonProperty("timeCreated")]
    public DateTimeOffset TimeCreated { get; set; }
}

public class AdditionalCapabilities
{
    [JsonProperty("ultraSSDEnabled")]
    public bool UltraSsdEnabled { get; set; }

    [JsonProperty("hibernationEnabled")]
    public bool HibernationEnabled { get; set; }
}

public class ApplicationProfile
{
    [JsonProperty("galleryApplications")]
    public GalleryApplication[] GalleryApplications { get; set; }
}

public class GalleryApplication
{
    [JsonProperty("tags")]
    public string Tags { get; set; }

    [JsonProperty("order")]
    public long Order { get; set; }

    [JsonProperty("packageReferenceId")]
    public string PackageReferenceId { get; set; }

    [JsonProperty("configurationReference")]
    public string ConfigurationReference { get; set; }
}

public class AvailabilitySet
{
    [JsonProperty("id")]
    public string Id { get; set; }
}

public class BillingProfile
{
    [JsonProperty("maxPrice")]
    public long MaxPrice { get; set; }
}

public class CapacityReservation
{
    [JsonProperty("capacityReservationGroup")]
    public AvailabilitySet CapacityReservationGroup { get; set; }
}

public class DiagnosticsProfile
{
    [JsonProperty("bootDiagnostics")]
    public DiagnosticsProfileBootDiagnostics BootDiagnostics { get; set; }
}

public class DiagnosticsProfileBootDiagnostics
{
    [JsonProperty("enabled")]
    public bool Enabled { get; set; }

    [JsonProperty("storageUri")]
    public string StorageUri { get; set; }
}

public class HardwareProfile
{
    [JsonProperty("vmSize")]
    public string VmSize { get; set; }

    [JsonProperty("vmSizeProperties")]
    public VmSizeProperties VmSizeProperties { get; set; }
}

public class VmSizeProperties
{
    [JsonProperty("vCPUsAvailable")]
    public long VCpUsAvailable { get; set; }

    [JsonProperty("vCPUsPerCore")]
    public long VCpUsPerCore { get; set; }
}

public class InstanceView
{
    [JsonProperty("platformUpdateDomain")]
    public long PlatformUpdateDomain { get; set; }

    [JsonProperty("platformFaultDomain")]
    public long PlatformFaultDomain { get; set; }

    [JsonProperty("computerName")]
    public string ComputerName { get; set; }

    [JsonProperty("osName")]
    public string OsName { get; set; }

    [JsonProperty("osVersion")]
    public string OsVersion { get; set; }

    [JsonProperty("hyperVGeneration")]
    public string HyperVGeneration { get; set; }

    [JsonProperty("rdpThumbPrint")]
    public string RdpThumbPrint { get; set; }

    [JsonProperty("vmAgent")]
    public VmAgent VmAgent { get; set; }

    [JsonProperty("maintenanceRedeployStatus")]
    public MaintenanceRedeployStatus MaintenanceRedeployStatus { get; set; }

    [JsonProperty("disks")]
    public Disk[] Disks { get; set; }

    [JsonProperty("extensions")]
    public Extension[] Extensions { get; set; }

    [JsonProperty("vmHealth")]
    public VmHealth VmHealth { get; set; }

    [JsonProperty("bootDiagnostics")]
    public InstanceViewBootDiagnostics BootDiagnostics { get; set; }

    [JsonProperty("assignedHost")]
    public string AssignedHost { get; set; }

    [JsonProperty("statuses")]
    public VirtualMachineStatus[] Statuses { get; set; }

    [JsonProperty("patchStatus")]
    public PatchStatus PatchStatus { get; set; }
}

public class InstanceViewBootDiagnostics
{
    [JsonProperty("consoleScreenshotBlobUri")]
    public string ConsoleScreenshotBlobUri { get; set; }

    [JsonProperty("serialConsoleLogBlobUri")]
    public SerialConsoleLogBlobUri SerialConsoleLogBlobUri { get; set; }

    [JsonProperty("status")]
    public VirtualMachineStatus Status { get; set; }
}

public class VirtualMachineStatus
{
    [JsonProperty("code")]
    public ProvisioningState Code { get; set; }

    [JsonProperty("level")]
    public Level Level { get; set; }

    [JsonProperty("displayStatus")]
    public DisplayStatus DisplayStatus { get; set; }

    [JsonProperty("message")]
    public SerialConsoleLogBlobUri Message { get; set; }

    [JsonProperty("time")]
    public DateTimeOffset Time { get; set; }
}

public class Disk
{
    [JsonProperty("name")]
    public string Name { get; set; }

    [JsonProperty("encryptionSettings")]
    public EncryptionSetting[] EncryptionSettings { get; set; }

    [JsonProperty("statuses")]
    public VirtualMachineStatus[] Statuses { get; set; }
}

public class EncryptionSetting
{

    [JsonProperty("enabled")]
    public bool Enabled { get; set; }
}


public class Extension
{
    [JsonProperty("name")]
    public DisplayStatus Name { get; set; }

    [JsonProperty("type")]
    public DisplayStatus Type { get; set; }

    [JsonProperty("typeHandlerVersion")]
    public string TypeHandlerVersion { get; set; }

    [JsonProperty("substatuses")]
    public VirtualMachineStatus[] Substatuses { get; set; }

    [JsonProperty("statuses")]
    public VirtualMachineStatus[] Statuses { get; set; }
}

public class MaintenanceRedeployStatus
{
    [JsonProperty("isCustomerInitiatedMaintenanceAllowed")]
    public bool IsCustomerInitiatedMaintenanceAllowed { get; set; }

    [JsonProperty("preMaintenanceWindowStartTime")]
    public DateTimeOffset PreMaintenanceWindowStartTime { get; set; }

    [JsonProperty("preMaintenanceWindowEndTime")]
    public DateTimeOffset PreMaintenanceWindowEndTime { get; set; }

    [JsonProperty("maintenanceWindowStartTime")]
    public DateTimeOffset MaintenanceWindowStartTime { get; set; }

    [JsonProperty("maintenanceWindowEndTime")]
    public DateTimeOffset MaintenanceWindowEndTime { get; set; }

    [JsonProperty("lastOperationResultCode")]
    public string LastOperationResultCode { get; set; }

    [JsonProperty("lastOperationMessage")]
    public string LastOperationMessage { get; set; }
}

public class PatchStatus
{
    [JsonProperty("availablePatchSummary")]
    public AvailablePatchSummary AvailablePatchSummary { get; set; }

    [JsonProperty("lastPatchInstallationSummary")]
    public LastPatchInstallationSummary LastPatchInstallationSummary { get; set; }

    [JsonProperty("configurationStatuses")]
    public VirtualMachineStatus[] ConfigurationStatuses { get; set; }
}

public class AvailablePatchSummary
{
    [JsonProperty("status")]
    public string Status { get; set; }

    [JsonProperty("assessmentActivityId")]
    public SerialConsoleLogBlobUri AssessmentActivityId { get; set; }

    [JsonProperty("rebootPending")]
    public bool RebootPending { get; set; }

    [JsonProperty("criticalAndSecurityPatchCount")]
    public long CriticalAndSecurityPatchCount { get; set; }

    [JsonProperty("otherPatchCount")]
    public long OtherPatchCount { get; set; }

    [JsonProperty("startTime")]
    public DateTimeOffset StartTime { get; set; }

    [JsonProperty("lastModifiedTime")]
    public DateTimeOffset LastModifiedTime { get; set; }

    [JsonProperty("error")]
    public Error Error { get; set; }
}

public class Error
{
    [JsonProperty("details")]
    public Detail[] Details { get; set; }

    [JsonProperty("innererror")]
    public Innererror Innererror { get; set; }

    [JsonProperty("code")]
    public string Code { get; set; }

    [JsonProperty("target")]
    public string Target { get; set; }

    [JsonProperty("message")]
    public ProvisioningState Message { get; set; }
}

public class Detail
{
    [JsonProperty("code")]
    public string Code { get; set; }

    [JsonProperty("target")]
    public string Target { get; set; }

    [JsonProperty("message")]
    public string Message { get; set; }
}

public class Innererror
{
    [JsonProperty("exceptiontype")]
    public string Exceptiontype { get; set; }

    [JsonProperty("errordetail")]
    public string Errordetail { get; set; }
}

public class LastPatchInstallationSummary
{
    [JsonProperty("status")]
    public string Status { get; set; }

    [JsonProperty("installationActivityId")]
    public string InstallationActivityId { get; set; }

    [JsonProperty("maintenanceWindowExceeded")]
    public bool MaintenanceWindowExceeded { get; set; }

    [JsonProperty("notSelectedPatchCount")]
    public long NotSelectedPatchCount { get; set; }

    [JsonProperty("excludedPatchCount")]
    public long ExcludedPatchCount { get; set; }

    [JsonProperty("pendingPatchCount")]
    public long PendingPatchCount { get; set; }

    [JsonProperty("installedPatchCount")]
    public long InstalledPatchCount { get; set; }

    [JsonProperty("failedPatchCount")]
    public long FailedPatchCount { get; set; }

    [JsonProperty("startTime")]
    public DateTimeOffset StartTime { get; set; }

    [JsonProperty("lastModifiedTime")]
    public DateTimeOffset LastModifiedTime { get; set; }

    [JsonProperty("error")]
    public Error Error { get; set; }
}

public class VmAgent
{
    [JsonProperty("vmAgentVersion")]
    public string VmAgentVersion { get; set; }

    [JsonProperty("extensionHandlers")]
    public ExtensionHandler[] ExtensionHandlers { get; set; }

    [JsonProperty("statuses")]
    public VirtualMachineStatus[] Statuses { get; set; }
}

public class ExtensionHandler
{
    [JsonProperty("type")]
    public string Type { get; set; }

    [JsonProperty("typeHandlerVersion")]
    public SerialConsoleLogBlobUri TypeHandlerVersion { get; set; }

    [JsonProperty("status")]
    public VirtualMachineStatus Status { get; set; }
}

public class VmHealth
{
    [JsonProperty("status")]
    public VirtualMachineStatus Status { get; set; }
}

public class NetworkProfile
{
    [JsonProperty("networkInterfaces")]
    public NetworkInterface[] NetworkInterfaces { get; set; }

    [JsonProperty("networkApiVersion")]
    public DateTimeOffset NetworkApiVersion { get; set; }

    [JsonProperty("networkInterfaceConfigurations")]
    public NetworkInterfaceConfiguration[] NetworkInterfaceConfigurations { get; set; }
}

public class NetworkInterfaceConfiguration
{
    [JsonProperty("name")]
    public string Name { get; set; }

    [JsonProperty("properties")]
    public NetworkInterfaceConfigurationProperties Properties { get; set; }
}

public class NetworkInterfaceConfigurationProperties
{
    [JsonProperty("primary")]
    public bool Primary { get; set; }

    [JsonProperty("deleteOption")]
    public string DeleteOption { get; set; }

    [JsonProperty("enableAcceleratedNetworking")]
    public bool EnableAcceleratedNetworking { get; set; }

    [JsonProperty("enableFpga")]
    public bool EnableFpga { get; set; }

    [JsonProperty("enableIPForwarding")]
    public bool EnableIpForwarding { get; set; }

    [JsonProperty("networkSecurityGroup")]
    public AvailabilitySet NetworkSecurityGroup { get; set; }

    [JsonProperty("dnsSettings")]
    public PurpleDnsSettings DnsSettings { get; set; }

    [JsonProperty("ipConfigurations")]
    public IpConfiguration[] IpConfigurations { get; set; }

    [JsonProperty("dscpConfiguration")]
    public AvailabilitySet DscpConfiguration { get; set; }
}

public class PurpleDnsSettings
{
    [JsonProperty("dnsServers")]
    public DisplayStatus[] DnsServers { get; set; }
}

public class IpConfiguration
{
    [JsonProperty("name")]
    public string Name { get; set; }

    [JsonProperty("properties")]
    public IpConfigurationProperties Properties { get; set; }
}

public class IpConfigurationProperties
{
    [JsonProperty("subnet")]
    public AvailabilitySet Subnet { get; set; }

    [JsonProperty("primary")]
    public bool Primary { get; set; }

    [JsonProperty("publicIPAddressConfiguration")]
    public PublicIpAddressConfiguration PublicIpAddressConfiguration { get; set; }

    [JsonProperty("privateIPAddressVersion")]
    public string PrivateIpAddressVersion { get; set; }

    [JsonProperty("applicationSecurityGroups")]
    public AvailabilitySet[] ApplicationSecurityGroups { get; set; }

    [JsonProperty("applicationGatewayBackendAddressPools")]
    public AvailabilitySet[] ApplicationGatewayBackendAddressPools { get; set; }

    [JsonProperty("loadBalancerBackendAddressPools")]
    public AvailabilitySet[] LoadBalancerBackendAddressPools { get; set; }
}

public class PublicIpAddressConfiguration
{
    [JsonProperty("name")]
    public string Name { get; set; }

    [JsonProperty("properties")]
    public PublicIpAddressConfigurationProperties Properties { get; set; }

    [JsonProperty("sku")]
    public VirtualMachineSku Sku { get; set; }
}

public class PublicIpAddressConfigurationProperties
{
    [JsonProperty("idleTimeoutInMinutes")]
    public long IdleTimeoutInMinutes { get; set; }

    [JsonProperty("deleteOption")]
    public string DeleteOption { get; set; }

    [JsonProperty("dnsSettings")]
    public FluffyDnsSettings DnsSettings { get; set; }

    [JsonProperty("ipTags")]
    public IpTag[] IpTags { get; set; }

    [JsonProperty("publicIPPrefix")]
    public AvailabilitySet PublicIpPrefix { get; set; }

    [JsonProperty("publicIPAddressVersion")]
    public string PublicIpAddressVersion { get; set; }

    [JsonProperty("publicIPAllocationMethod")]
    public string PublicIpAllocationMethod { get; set; }
}

public class FluffyDnsSettings
{
    [JsonProperty("domainNameLabel")]
    public string DomainNameLabel { get; set; }
}

public class IpTag
{
    [JsonProperty("ipTagType")]
    public string IpTagType { get; set; }

    [JsonProperty("tag")]
    public string Tag { get; set; }
}

public class VirtualMachineSku
{
    [JsonProperty("name")]
    public string Name { get; set; }

    [JsonProperty("tier")]
    public string Tier { get; set; }
}

public class NetworkInterface
{
    [JsonProperty("id")]
    public string Id { get; set; }

    [JsonProperty("properties")]
    public NetworkInterfaceProperties Properties { get; set; }
}

public class NetworkInterfaceProperties
{
    [JsonProperty("primary")]
    public bool Primary { get; set; }

    [JsonProperty("deleteOption")]
    public string DeleteOption { get; set; }
}

public class OsProfile
{
    [JsonProperty("computerName")]
    public string ComputerName { get; set; }

    [JsonProperty("adminUsername")]
    public string AdminUsername { get; set; }

    [JsonProperty("windowsConfiguration")]
    public WindowsConfiguration WindowsConfiguration { get; set; }

    [JsonProperty("secrets")]
    public object[] Secrets { get; set; }

    [JsonProperty("allowExtensionOperations")]
    public bool AllowExtensionOperations { get; set; }

    [JsonProperty("adminPassword")]
    public string AdminPassword { get; set; }

    [JsonProperty("customData")]
    public string CustomData { get; set; }

    [JsonProperty("linuxConfiguration")]
    public LinuxConfiguration LinuxConfiguration { get; set; }

    [JsonProperty("requireGuestProvisionSignal")]
    public bool RequireGuestProvisionSignal { get; set; }
}

public class LinuxConfiguration
{
    [JsonProperty("disablePasswordAuthentication")]
    public bool DisablePasswordAuthentication { get; set; }

    [JsonProperty("provisionVMAgent")]
    public bool ProvisionVmAgent { get; set; }

    [JsonProperty("patchSettings")]
    public LinuxConfigurationPatchSettings PatchSettings { get; set; }
}

public class LinuxConfigurationPatchSettings
{
    [JsonProperty("patchMode")]
    public string PatchMode { get; set; }

    [JsonProperty("assessmentMode")]
    public string AssessmentMode { get; set; }
}

public class WindowsConfiguration
{
    [JsonProperty("provisionVMAgent")]
    public bool ProvisionVmAgent { get; set; }

    [JsonProperty("enableAutomaticUpdates")]
    public bool EnableAutomaticUpdates { get; set; }

    [JsonProperty("timeZone")]
    public string TimeZone { get; set; }

    [JsonProperty("additionalUnattendContent")]
    public AdditionalUnattendContent[] AdditionalUnattendContent { get; set; }

    [JsonProperty("patchSettings")]
    public WindowsConfigurationPatchSettings PatchSettings { get; set; }

    [JsonProperty("winRM")]
    public WinRm WinRm { get; set; }
}

public class AdditionalUnattendContent
{
    [JsonProperty("passName")]
    public string PassName { get; set; }

    [JsonProperty("componentName")]
    public string ComponentName { get; set; }

    [JsonProperty("settingName")]
    public string SettingName { get; set; }

    [JsonProperty("content")]
    public string Content { get; set; }
}

public class WindowsConfigurationPatchSettings
{
    [JsonProperty("patchMode")]
    public string PatchMode { get; set; }

    [JsonProperty("enableHotpatching")]
    public bool EnableHotpatching { get; set; }

    [JsonProperty("assessmentMode")]
    public string AssessmentMode { get; set; }
}

public class WinRm
{
    [JsonProperty("listeners")]
    public Listener[] Listeners { get; set; }
}

public class Listener
{
    [JsonProperty("protocol")]
    public string Protocol { get; set; }

    [JsonProperty("certificateUrl")]
    public string CertificateUrl { get; set; }
}

public class ScheduledEventsProfile
{
    [JsonProperty("terminateNotificationProfile")]
    public TerminateNotificationProfile TerminateNotificationProfile { get; set; }
}

public class TerminateNotificationProfile
{
    [JsonProperty("notBeforeTimeout")]
    public string NotBeforeTimeout { get; set; }

    [JsonProperty("enable")]
    public bool Enable { get; set; }
}

public class PropertiesSecurityProfile
{
    [JsonProperty("uefiSettings")]
    public UefiSettings UefiSettings { get; set; }

    [JsonProperty("encryptionAtHost")]
    public bool EncryptionAtHost { get; set; }

    [JsonProperty("securityType")]
    public string SecurityType { get; set; }
}

public class UefiSettings
{
    [JsonProperty("secureBootEnabled")]
    public bool SecureBootEnabled { get; set; }

    [JsonProperty("vTpmEnabled")]
    public bool VTpmEnabled { get; set; }
}

public class StorageProfile
{
    [JsonProperty("imageReference")]
    public ImageReference ImageReference { get; set; }

    [JsonProperty("osDisk")]
    public OsDisk OsDisk { get; set; }

    [JsonProperty("dataDisks")]
    public object[] DataDisks { get; set; }
}

public class ImageReference
{
    [JsonProperty("publisher")]
    public string Publisher { get; set; }

    [JsonProperty("offer")]
    public string Offer { get; set; }

    [JsonProperty("sku")]
    public string VirtualMachineSku { get; set; }

    [JsonProperty("version")]
    public string Version { get; set; }

    [JsonProperty("exactVersion")]
    public string ExactVersion { get; set; }

    [JsonProperty("sharedGalleryImageId")]
    public string SharedGalleryImageId { get; set; }

    [JsonProperty("communityGalleryImageId")]
    public string CommunityGalleryImageId { get; set; }

    [JsonProperty("id")]
    public string Id { get; set; }
}

public class OsDisk
{
    [JsonProperty("osType")]
    public string OsType { get; set; }

    [JsonProperty("name")]
    public string Name { get; set; }

    [JsonProperty("createOption")]
    public string CreateOption { get; set; }

    [JsonProperty("vhd")]
    public Image Vhd { get; set; }

    [JsonProperty("caching")]
    public string Caching { get; set; }

    [JsonProperty("diskSizeGB")]
    public long DiskSizeGb { get; set; }

    [JsonProperty("encryptionSettings")]
    public EncryptionSetting EncryptionSettings { get; set; }

    [JsonProperty("image")]
    public Image Image { get; set; }

    [JsonProperty("writeAcceleratorEnabled")]
    public bool WriteAcceleratorEnabled { get; set; }

    [JsonProperty("diffDiskSettings")]
    public DiffDiskSettings DiffDiskSettings { get; set; }

    [JsonProperty("managedDisk")]
    public ManagedDisk ManagedDisk { get; set; }

    [JsonProperty("deleteOption")]
    public string DeleteOption { get; set; }
}

public class DiffDiskSettings
{
    [JsonProperty("option")]
    public string Option { get; set; }

    [JsonProperty("placement")]
    public string Placement { get; set; }
}

public class Image
{
    [JsonProperty("uri")]
    public string Uri { get; set; }
}

public class ManagedDisk
{
    [JsonProperty("storageAccountType")]
    public string StorageAccountType { get; set; }

    [JsonProperty("diskEncryptionSet")]
    public AvailabilitySet DiskEncryptionSet { get; set; }

    [JsonProperty("securityProfile")]
    public ManagedDiskSecurityProfile SecurityProfile { get; set; }

    [JsonProperty("id")]
    public string Id { get; set; }
}

public class ManagedDiskSecurityProfile
{
    [JsonProperty("securityEncryptionType")]
    public string SecurityEncryptionType { get; set; }

    [JsonProperty("diskEncryptionSet")]
    public AvailabilitySet DiskEncryptionSet { get; set; }
}

public class Resource
{
    [JsonProperty("properties")]
    public ResourceProperties Properties { get; set; }

    [JsonProperty("id")]
    public string Id { get; set; }

    [JsonProperty("name")]
    public string Name { get; set; }

    [JsonProperty("type")]
    public string Type { get; set; }

    [JsonProperty("location")]
    public string Location { get; set; }

    [JsonProperty("tags")]
    public ResourceTags Tags { get; set; }
}

public class ResourceProperties
{
    [JsonProperty("forceUpdateTag")]
    public string ForceUpdateTag { get; set; }

    [JsonProperty("publisher")]
    public string Publisher { get; set; }

    [JsonProperty("type")]
    public string Type { get; set; }

    [JsonProperty("typeHandlerVersion")]
    public string TypeHandlerVersion { get; set; }

    [JsonProperty("autoUpgradeMinorVersion")]
    public bool AutoUpgradeMinorVersion { get; set; }

    [JsonProperty("enableAutomaticUpgrade")]
    public bool EnableAutomaticUpgrade { get; set; }

    [JsonProperty("settings")]
    public ProtectedSettingsClass Settings { get; set; }

    [JsonProperty("protectedSettings")]
    public ProtectedSettingsClass ProtectedSettings { get; set; }

    [JsonProperty("provisioningState")]
    public ProvisioningState ProvisioningState { get; set; }

    [JsonProperty("instanceView")]
    public Extension InstanceView { get; set; }

    [JsonProperty("suppressFailures")]
    public bool SuppressFailures { get; set; }

    [JsonProperty("protectedSettingsFromKeyVault")]
    public ProtectedSettingsClass ProtectedSettingsFromKeyVault { get; set; }
}

public class ProtectedSettingsClass
{
}

public class ResourceTags
{
    [JsonProperty("key9428")]
    public string Key9428 { get; set; }
}

public enum SerialConsoleLogBlobUri { Aaaaaaaaaaaaaaaaaaa };

public enum ProvisioningState { Aaa };

public enum DisplayStatus { Aaaaaaaaaaaaaaaaaaaaaaaa };

public enum Level { Info };