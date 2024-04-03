using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Nic;

public class NicResponse : AzureResponse
{
    [JsonProperty("location")]
    public string Location { get; set; }

    [JsonProperty("properties")]
    public NicProperties NicProperties { get; set; }
}

public partial class NicProperties
{
    [JsonProperty("provisioningState")]
    public string ProvisioningState { get; set; }

    [JsonProperty("ipConfigurations")]
    public NicIpConfiguration[] NicIpConfigurations { get; set; }

    [JsonProperty("networkSecurityGroup", NullValueHandling = NullValueHandling.Ignore)]
    public NetworkSecurityGroup NetworkSecurityGroup { get; set; }

    [JsonProperty("primary", NullValueHandling = NullValueHandling.Ignore)]
    public bool? Primary { get; set; }

    [JsonProperty("virtualMachine", NullValueHandling = NullValueHandling.Ignore)]
    public NetworkSecurityGroup VirtualMachine { get; set; }
}

public partial class NicIpConfiguration
{
    [JsonProperty("id")]
    public string NicIpConfigurationId { get; set; }

    [JsonProperty("properties")]
    public NicIpConfigurationProperties NicIpConfigurationProperties { get; set; }
}

public partial class NicIpConfigurationProperties
{
    [JsonProperty("provisioningState")]
    public string ProvisioningState { get; set; }

    [JsonProperty("privateIPAddress")]
    public string PrivateIpAddress { get; set; }

    [JsonProperty("privateIPAllocationMethod")]
    public string PrivateIpAllocationMethod { get; set; }

    [JsonProperty("publicIPAddress")]
    public NetworkSecurityGroup PublicIpAddress { get; set; }

    [JsonProperty("subnet")]
    public NetworkSecurityGroup IpConfSubnet { get; set; }

    [JsonProperty("primary")]
    public bool IpConfPrimary { get; set; }

    [JsonProperty("privateIPAddressVersion")]
    public string IpConfPrivateIpAddressVersion { get; set; }
}

public partial class NetworkSecurityGroup
{
    [JsonProperty("id")]
    public string NetworkSecurityGroupId { get; set; }
}