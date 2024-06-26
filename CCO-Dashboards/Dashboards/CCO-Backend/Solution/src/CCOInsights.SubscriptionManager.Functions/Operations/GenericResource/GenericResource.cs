using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Models;
using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.GenericResource;

public class GenericResource : GenericResourceInner
{
    [JsonProperty(PropertyName = "tenantId")]
    public string TenantId { get; set; }

    [JsonProperty(PropertyName = "subscriptionId")]
    public string SubscriptionId { get; set; }

    [JsonProperty(PropertyName = "resourceGroup")]
    public string ResourceGroup { get; set; }

    [JsonProperty(PropertyName = "processDateTime")]
    public DateTime ProcessDateTime { get; set; }

    [JsonProperty(PropertyName = "resourceId")]
    public string ResourceId { get; set; }

    private GenericResource(string id, string tenantId, string subscriptionId, string resourceGroup, string resourceId, string location,
        string name, string type, IDictionary<string, string> tags, Plan plan, object properties, string kind, string managedBy, Sku sku, Identity identity)
        : base(location, id, name, type, tags, plan, properties, kind, managedBy, sku, identity)
    {
        TenantId = tenantId;
        SubscriptionId = subscriptionId;
        ResourceGroup = resourceGroup;
        ProcessDateTime = DateTime.UtcNow;
        ResourceId = resourceId;
    }

    public static GenericResource From(string tenantId, string subscriptionId, IGenericResource genericResource, GenericResourceInner genericResourceInner)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + genericResource.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new GenericResource(id, tenantId, subscriptionId, genericResource.ResourceGroupName,
            genericResource.Id, genericResourceInner.Location, genericResourceInner.Name, genericResourceInner.Type,
            genericResourceInner.Tags, genericResourceInner.Plan, genericResourceInner.Properties,
            genericResourceInner.Kind, genericResourceInner.ManagedBy, genericResourceInner.Sku,
            genericResourceInner.Identity);
    }
}
