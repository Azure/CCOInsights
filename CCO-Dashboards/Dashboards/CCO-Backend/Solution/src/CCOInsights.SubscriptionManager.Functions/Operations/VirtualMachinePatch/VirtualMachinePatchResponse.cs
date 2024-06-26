using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachinePatch;

public class VirtualMachinePatchResponse : AzureResponse
{
    [JsonProperty("tenantId")]
    public string TenantId { get; set; }

    [JsonProperty("resourceGroup")]
    public string ResourceGroup { get; set; }

    [JsonProperty("subscriptionId")]
    public string SubscriptionId { get; set; }

    [JsonProperty("properties")]
    public VirtualMachinePatchProperties Properties { get; set; }
}

public class VirtualMachinePatchProperties
{
    [JsonProperty("lastModifiedDateTime")]
    public string LastModifiedDateTime { get; set; }

    [JsonProperty("classifications")]
    public string[] Classifications { get; set; }

    [JsonProperty("patchName")]
    public string PatchName { get; set; }

    [JsonProperty("patchId")]
    public string PatchId { get; set; }

    [JsonProperty("publishedDateTime")]
    public string PublishedDateTime { get; set; }

    [JsonProperty("rebootBehavior")]
    public string RebootBehavior { get; set; }

    [JsonProperty("kbId")]
    public long KbId { get; set; }

    [JsonProperty("msrcSeverity", NullValueHandling = NullValueHandling.Ignore)]
    public string MsrcSeverity { get; set; }
}