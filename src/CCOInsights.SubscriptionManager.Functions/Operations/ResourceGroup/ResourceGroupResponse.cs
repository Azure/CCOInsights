using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.ResourceGroup;

public class ResourceGroupResponse : AzureResponse
{
    [JsonProperty("location")]
    public string Location { get; set; }

    [JsonProperty("managedBy")]
    public string ManagedBy { get; set; }

    [JsonProperty("tags")]
    public object Tags { get; set; }

    [JsonProperty("properties")]
    public AzureResourceGroupProperties Properties { get; set; }
}

public class AzureResourceGroupProperties
{
    [JsonProperty("provisioningState")]
    public string ProvisioningState { get; set; }
}