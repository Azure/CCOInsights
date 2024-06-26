namespace CCOInsights.SubscriptionManager.Functions.Operations.NetworkSecurityGroups;

[GeneratedProvider("/providers/Microsoft.Network/networkSecurityGroups?api-version=2022-07-01")]
public class NetworkSecurityGroupResponse : AzureResponse
{
    public string etag { get; set; }
    public string location { get; set; }
    public NetworkSecurityGroupProperties properties { get; set; }
}

public class NetworkSecurityGroupProperties
{
    public SecurityRule[] defaultSecurityRules { get; set; }
    public FlowLog[] flowLogs { get; set; }
    public bool flushConnection { get; set; }
    public NetworkInterface[] networkInterfaces { get; set; }
    public string resourceGuid { get; set; }
    public SecurityRule[] securityRules { get; set; }
    public object[] subnets { get; set; }
}

public class NetworkInterface
{
    public string etag { get; set; }
    public ExtendedLocation extendedLocation { get; set; }
    public string id { get; set; }
    public string location { get; set; }
    public string name { get; set; }
    public NetworkInterfaceProperties properties { get; set; }
}

public class NetworkInterfaceProperties
{
    public string auxiliaryMode { get; set; }
    public bool disableTcpStateTracking { get; set; }
    public NetworkInterfaceDnsSettings DnsSettings { get; set; }
    public SubResource dscpConfiguration { get; set; }
    public bool enableAcceleratedNetworking { get; set; }
    public bool enableIPForwarding { get; set; }
    public string[] hostedWorkloads { get; set; }
    public NetworkInterfaceIPConfiguration[] ipConfigurations { get; set; }
}

public class NetworkInterfaceIPConfiguration
{
    public string etag { get; set; }
    public string id { get; set; }
    public string name { get; set; }
    public NetworkInterfaceIPConfigurationProperties properties { get; set; }
    public string type { get; set; }
}

public class NetworkInterfaceIPConfigurationProperties
{
    public ApplicationGatewayBackendAddressPool[] applicationGatewayBackendAddressPools { get; set; }
    public ApplicationSecurityGroup[] applicationSecurityGroups { get; set; }
    public SubResource gatewayLoadBalancer { get; set; }
    public BackendAddressPool[] loadBalancerBackendAddressPools { get; set; }
    public object[] loadBalancerInboundNatRules { get; set; }
    public bool primary { get; set; }
    public string privateIPAddress { get; set; }
    public string privateIPAddressVersion { get; set; }
    public string privateIPAllocationMethod { get; set; }
    public object privateLinkConnectionProperties { get; set; }
    public string provisioningState { get; set; }
    public object publicIPAddress { get; set; }
    public object subnet { get; set; }
    public object[] virtualNetworkTaps { get; set; }
}

public class BackendAddressPool
{
    public string etag { get; set; }
    public string id { get; set; }
    public string name { get; set; }
    public BackendAddressPoolProperties properties { get; set; }
    public string type { get; set; }
}

public class BackendAddressPoolProperties
{
    public NetworkInterfaceIPConfiguration[] backendIPConfigurations { get; set; }
    public int drainPeriodInSeconds { get; set; }
    public SubResource[] inboundNatRules { get; set; }
    public object[] loadBalancerBackendAddresses { get; set; }
    public SubResource[] loadBalancingRules { get; set; }
    public string location { get; set; }
    public SubResource outboundRule { get; set; }
    public SubResource[] outboundRules { get; set; }
    public string provisioningState { get; set; }
    public object[] tunnelInterfaces { get; set; }
    public SubResource virtualNetwork { get; set; }
}

public class ApplicationGatewayBackendAddressPool
{
    public string etag { get; set; }
    public string id { get; set; }
    public string name { get; set; }
    public ApplicationGatewayBackendAddressPoolProperties properties { get; set; }
}
public class ApplicationGatewayBackendAddressPoolProperties
{
    public ApplicationGatewayBackendAddress[] backendAddresses { get; set; }
    public NetworkInterfaceIPConfiguration[] backendIPConfigurations { get; set; }
    public string provisioningState { get; set; }
}

public class ApplicationGatewayBackendAddress
{
    public string fqdn { get; set; }
    public string ipAddress { get; set; }
}

public class SubResource
{
    public string id { get; set; }
}

public class NetworkInterfaceDnsSettings
{
    public string[] appliedDnsServers { get; set; }
    public string[] dnsServers { get; set; }
    public string internalDnsNameLabel { get; set; }
    public string internalDomainNameSuffix { get; set; }
    public string internalFqdn { get; set; }
}

public class ExtendedLocation
{
    public string name { get; set; }
    public string type { get; set; }
}

public class SecurityRule
{
    public string etag { get; set; }
    public string id { get; set; }
    public string name { get; set; }
    public SecurityRuleProperties properties { get; set; }
    public string type { get; set; }
}

public class FlowLog
{
    public string etag { get; set; }
    public string id { get; set; }
    public string location { get; set; }
    public string name { get; set; }
    public FlowLogProperties properties { get; set; }
    public object tags { get; set; }
    public string type { get; set; }
}

public class FlowLogProperties
{
    public string enabled { get; set; }
    public FlowAnalyticsConfiguration flowAnalyticsConfiguration { get; set; }
    public FlowLogFormatParameters format { get; set; }
    public string provisioningState { get; set; }
    public RetentionPolicyParameters retentionPolicy { get; set; }
    public string storageId { get; set; }
    public string targetResourceGuid { get; set; }
    public string targetResourceId { get; set; }
}

public class RetentionPolicyParameters
{
    public bool enabled { get; set; }
    public int days { get; set; }
}
public class FlowAnalyticsConfiguration
{
    public TrafficAnalyticsConfigurationProperties networkWatcherFlowAnalyticsConfiguration { get; set; }
}

public class FlowLogFormatParameters
{
    public object type { get; set; }
    public int version { get; set; }
}

public class TrafficAnalyticsConfigurationProperties
{
    public bool enabled { get; set; }
    public int trafficAnalyticsInterval { get; set; }
    public string workspaceId { get; set; }
    public string workspaceRegion { get; set; }
    public string workspaceResourceId { get; set; }
}

public class SecurityRuleProperties
{
    public string access { get; set; }
    public string description { get; set; }
    public string destinationAddressPrefix { get; set; }
    public string[] destinationAddressPrefixes { get; set; }
    public ApplicationSecurityGroup[] destinationApplicationSecurityGroups { get; set; }
    public string destinationPortRange { get; set; }
    public string[] destinationPortRanges { get; set; }
    public string direction { get; set; }
    public int priority { get; set; }
    public string protocol { get; set; }
    public string provisioningState { get; set; }
    public string sourceAddressPrefix { get; set; }
    public string[] sourceAddressPrefixes { get; set; }
    public ApplicationSecurityGroup[] sourceApplicationSecurityGroups { get; set; }
    public string sourcePortRange { get; set; }
    public string[] sourcePortRanges { get; set; }
}

public class ApplicationSecurityGroup
{
    public string id { get; set; }
    public string etag { get; set; }
    public string location { get; set; }
    public string name { get; set; }
    public string provisioningState { get; set; }
    public string resourceGuid { get; set; }
    public object tags { get; set; }
    public string type { get; set; }
}
