using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.SecurityTasks;

[GeneratedProvider("/providers/Microsoft.Security/tasks?api-version=2015-06-01-preview")]
public class SecurityTaskResponse : AzureResponse
{
    [JsonProperty("properties")]
    public SecurityTaskProperties Properties { get; set; }
}

public class SecurityTaskProperties
{
    [JsonProperty("creationTimeUtc")]
    public string CreationTimeUtc { get; set; }

    [JsonProperty("lastStateChangeTimeUtc")]
    public string LastStateChangeTimeUtc { get; set; }

    [JsonProperty("state")]
    public string State { get; set; }

    [JsonProperty("securityTaskParameters")]
    public object SecurityTaskParameters { get; set; }

    [JsonProperty("subState")]
    public string SubState { get; set; }
}