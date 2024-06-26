using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations;

public class ProviderResponse<T>
{
    [JsonProperty("value")]
    public T[] Value { get; set; }

    [JsonProperty("nextLink")]
    public string NextLink { get; set; }
}