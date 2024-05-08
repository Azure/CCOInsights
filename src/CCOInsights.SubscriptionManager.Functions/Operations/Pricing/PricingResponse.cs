using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Pricing;

public class PricingResponse : AzureResponse
{
    [JsonProperty("properties")]
    public PricingProperties Properties { get; set; }
}

public class PricingProperties
{
    [JsonProperty("pricingTier")]
    public string PricingTier { get; set; }
}