namespace CCOInsights.SubscriptionManager.Functions.Operations.PublicIPs;

public class PublicIPsResponse : AzureResponse
{
    public string etag { get; set; }
    public string location { get; set; }
    public AzurePublicIPProperties properties { get; set; }
    public Sku sku { get; set; }
}

public class AzurePublicIPProperties
{
    public string provisioningState { get; set; }
    public string resourceGuid { get; set; }
    public string publicIPAddressVersion { get; set; }
    public string publicIPAllocationMethod { get; set; }
    public int idleTimeoutInMinutes { get; set; }
    public object[] ipTags { get; set; }
    public Ipconfiguration ipConfiguration { get; set; }
}

public class Ipconfiguration
{
    public string id { get; set; }
}

public class Sku
{
    public string name { get; set; }
    public string tier { get; set; }
}