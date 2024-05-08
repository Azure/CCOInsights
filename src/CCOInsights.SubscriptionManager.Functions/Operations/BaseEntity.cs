using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations;

public class BaseEntity<T> where T : IAzureResponse
{
    [JsonProperty(PropertyName = "id")]
    public string Id { get; }

    public string ExecutionId { get; }

    [JsonProperty(PropertyName = "tenantId")]
    public string TenantId { get; }

    [JsonProperty(PropertyName = "subscriptionId")]
    public string SubscriptionId { get; }

    [JsonProperty(PropertyName = "processDateTime")]
    public DateTime ProcessDateTime { get; }

    [JsonProperty(PropertyName = "value")]
    public T Value { get; private set; }

    public BaseEntity(string id, string tenantId, string subscriptionId, string executionId, T value)
    {
        Id = id;
        TenantId = tenantId;
        ExecutionId = executionId;
        SubscriptionId = subscriptionId;
        Value = value;
        ProcessDateTime = DateTime.Now;
    }

    public BaseEntity(string id, string executionId, T value)
    {
        Id = id;
        ExecutionId = executionId;
        Value = value;
        ProcessDateTime = DateTime.Now;
    }
}