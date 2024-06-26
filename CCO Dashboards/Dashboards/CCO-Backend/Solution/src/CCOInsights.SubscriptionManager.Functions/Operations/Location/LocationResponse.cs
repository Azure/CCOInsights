using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Location;

public class LocationResponse : AzureResponse
{
    [JsonProperty("displayName")]
    public string DisplayName { get; set; }

    [JsonProperty("regionalDisplayName")]
    public string RegionalDisplayName { get; set; }

    [JsonProperty("subscriptionId")]
    public string SubscriptionId { get; set; }

    [JsonProperty("metadata")]
    public AzureLocationMetadata Metadata { get; set; }
}

public class AzureLocationMetadata
{
    [JsonProperty("geographyGroup")]
    public string GeographyGroup { get; set; }

    [JsonProperty("latitude")]
    public string Latitude { get; set; }

    [JsonProperty("longitude")]
    public string Longitude { get; set; }

    [JsonProperty("physicalLocation")]
    public string PhysicalLocation { get; set; }

    [JsonProperty("pairedRegion")]
    public ICollection<PairedRegion> PairedRegion { get; set; } = new List<PairedRegion>();

    [JsonProperty("regionCategory")]
    public string RegionCategory { get; set; }

    [JsonProperty("regionType")]
    public string RegionType { get; set; }
}

public class PairedRegion
{
    [JsonProperty("id")]
    public string Id { get; set; }

    [JsonProperty("name")]
    public string Name { get; set; }

    [JsonProperty("subscriptionId")]
    public string SubscriptionId { get; set; }
}
