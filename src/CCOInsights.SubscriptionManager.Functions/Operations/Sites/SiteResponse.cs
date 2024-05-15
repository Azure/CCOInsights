namespace CCOInsights.SubscriptionManager.Functions.Operations.Sites;

[GeneratedProvider("/providers/Microsoft.Web/sites?api-version=2022-03-01")]
public class SiteResponse : AzureResponse
{
    public SiteResponseProperties Properties { get; set; }
    public string Kind { get; set; }
    public string Location { get; set; }
    public Identity Identity { get; set; }
}

public class SiteResponseProperties
{
    public ExtendedLocation ExtendedLocation { get; set; }
    public ManagedServiceIdentity ManagedServiceIdentity { get; set; }

    public string AvailabilityState { get; set; }
    public bool? ClientAffinityEnabled { get; set; }
    public bool? ClientCertEnabled { get; set; }
    public string ClientCertExclusionPaths { get; set; }
    public string ClientCertMode { get; set; }
    public CloningInfo CloningInfo { get; set; }
    public int? ContainerSize { get; set; }
    public string CustomDomainVerificationId { get; set; }
    public int? DailyMemoryTimeQuota { get; set; }
    public string DefaultHostName { get; set; }
    public bool? Enabled { get; set; }
    public string[] EnabledHostNames { get; set; }
    public HostNameSslState[] HostNameSslStates { get; set; }
    public string[] HostNames { get; set; }
    public bool? HostNamesDisabled { get; set; }
    public HostingEnvironmentProfile HostingEnvironmentProfile { get; set; }
    public bool? HttpsOnly { get; set; }
    public bool? HyperV { get; set; }
    public string InprogressOperationId { get; set; }
    public bool IsDefaultContainer { get; set; }
    public bool? IsXenon { get; set; }
    public string KeyVaultReferenceIdentity { get; set; }
    public string LastModifiedTimeUtc { get; set; }
    public int? MaxNumberOfWorkers { get; set; }
    public string OutboundIpAddresses { get; set; }
    public string PossibleOutboundIpAddresses { get; set; }
    public string PublicNetworkAccess { get; set; }
    public string RedundancyMode { get; set; }
    public string RepositorySiteName { get; set; }
    public bool? Reserved { get; set; }
    public string ResourceGroup { get; set; }
    public bool? ScmSiteAlsoStopped { get; set; }
    public string ServerFarmId { get; set; }
    public object SiteConfig { get; set; }
    public SlotSwapStatus SlotSwapStatus { get; set; }
    public string State { get; set; }
    public bool? StorageAccountRequired { get; set; }
    public string SuspendedTill { get; set; }
    public string TargetSwapSlot { get; set; }
    public string[] TrafficManagerHostNames { get; set; }
    public string UsageState { get; set; }
    public string VirtualNetworkSubnetId { get; set; }
    public bool? VnetContentShareEnabled { get; set; }
    public bool? VnetImagePullEnabled { get; set; }
    public bool? VnetRouteAllEnabled { get; set; }
}

public class Identity
{
    public string Type { get; set; }
    public string TenantId { get; set; }
    public string PrincipalId { get; set; }
}

public class ExtendedLocation
{
    public string Name { get; set; }
    public string Type { get; set; }
}

public class ManagedServiceIdentity
{
    public string PrincipalId { get; set; }
    public string TenantId { get; set; }
    public string Type { get; set; }
    public Dictionary<string, UserAssignedIdentity> UserAssignedIdentities { get; set; }
}

public class UserAssignedIdentity
{
    public string ClientId { get; set; }
}

public class CloningInfo
{
    public object AppSettingsOverrides { get; set; }
    public bool? CloneCustomHostNames { get; set; }
    public bool? CloneSourceControl { get; set; }
    public bool? ConfigureLoadBalancing { get; set; }
    public string CorrelationId { get; set; }
    public string HostingEnvironment { get; set; }
    public bool? Overwrite { get; set; }
    public string SourceWebAppId { get; set; }
    public string SourceWebAppLocation { get; set; }
    public string TrafficManagerProfileId { get; set; }
    public string TrafficManagerProfileName { get; set; }
}

public class HostNameSslState
{
    public string HostType { get; set; }
    public string Name { get; set; }
    public string SslState { get; set; }
    public string Thumbprint { get; set; }
    public bool? ToUpdate { get; set; }
    public string VirtualIp { get; set; }
}

public class HostingEnvironmentProfile
{
    public string Id { get; set; }
    public string Name { get; set; }
    public string Type { get; set; }
}

public class SlotSwapStatus
{
    public string DestinationSlotName { get; set; }
    public string SourceSlotName { get; set; }
    public string TimestampUtc { get; set; }
}
