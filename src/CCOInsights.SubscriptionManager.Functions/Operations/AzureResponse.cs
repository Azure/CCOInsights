using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations;

public class AzureResponse : IAzureResponse
{
    [JsonProperty("name")]
    public string Name { get; set; }

    [JsonProperty("id")]
    public string Id { get; set; }

    [JsonProperty("type")]
    public string Type { get; set; }

    [JsonProperty("tags")]
    public dynamic Tags { get; set; }
}
