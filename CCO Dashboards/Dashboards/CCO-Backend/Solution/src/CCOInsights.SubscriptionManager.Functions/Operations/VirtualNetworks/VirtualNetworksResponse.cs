namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualNetworks;

[GeneratedProvider("/providers/Microsoft.Network/virtualNetworks?api-version=2022-05-01")]
public class VirtualNetworksResponse : AzureResponse
{
    public string location { get; set; }
    public VirtualNetworksProperties properties { get; set; }
}

public class VirtualNetworksProperties
{
    public VirtualNetworksAddressspace addressSpace { get; set; }
    public VirtualNetworksDhcpoptions dhcpOptions { get; set; }
    public object[] subnets { get; set; }
    public object[] virtualNetworkPeerings { get; set; }
    public string provisioningState { get; set; }
}

public class VirtualNetworksAddressspace
{
    public string[] addressPrefixes { get; set; }
}

public class VirtualNetworksDhcpoptions
{
    public string[] dnsServers { get; set; }
}