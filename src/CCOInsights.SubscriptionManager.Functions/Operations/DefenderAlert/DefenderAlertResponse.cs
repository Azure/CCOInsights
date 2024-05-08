using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderAlert;

[GeneratedProvider("/providers/Microsoft.Security/alerts?api-version=2021-01-01")]
public class DefenderAlertResponse : AzureResponse
{
    [JsonProperty("properties")]
    public DefenderAlertProperties Properties { get; set; }
}

public class DefenderAlertProperties
{
    [JsonProperty("alertType")]
    public string AlertType { get; set; }

    [JsonProperty("systemAlertId")]
    public string SystemAlertId { get; set; }

    [JsonProperty("productComponentName")]
    public string ProductComponentName { get; set; }

    [JsonProperty("alertDisplayName")]
    public string AlertDisplayName { get; set; }

    [JsonProperty("description")]
    public string Description { get; set; }

    [JsonProperty("severity")]
    public string Severity { get; set; }

    [JsonProperty("intent")]
    public string Intent { get; set; }

    [JsonProperty("startTimeUtc")]
    public DateTimeOffset StartTimeUtc { get; set; }

    [JsonProperty("endTimeUtc")]
    public DateTimeOffset EndTimeUtc { get; set; }

    [JsonProperty("resourceIdentifiers")]
    public DefenderAlertResourceIdentifier[] ResourceIdentifiers { get; set; }

    [JsonProperty("remediationSteps")]
    public string[] RemediationSteps { get; set; }

    [JsonProperty("vendorName")]
    public string VendorName { get; set; }

    [JsonProperty("status")]
    public string Status { get; set; }

    [JsonProperty("extendedLinks")]
    public DefenderAlertExtendedLink[] ExtendedLinks { get; set; }

    [JsonProperty("alertUri")]
    public Uri AlertUri { get; set; }

    [JsonProperty("timeGeneratedUtc")]
    public DateTimeOffset TimeGeneratedUtc { get; set; }

    [JsonProperty("productName")]
    public string ProductName { get; set; }

    [JsonProperty("processingEndTimeUtc")]
    public DateTimeOffset ProcessingEndTimeUtc { get; set; }

    [JsonProperty("entities")]
    public DefenderAlertEntity[] Entities { get; set; }

    [JsonProperty("isIncident")]
    public bool IsIncident { get; set; }

    [JsonProperty("correlationKey")]
    public string CorrelationKey { get; set; }

    [JsonProperty("extendedProperties")]
    public DefenderAlertExtendedProperties ExtendedProperties { get; set; }

    [JsonProperty("compromisedEntity")]
    public string CompromisedEntity { get; set; }
}

public class DefenderAlertEntity
{
    [JsonProperty("address", NullValueHandling = NullValueHandling.Ignore)]
    public string Address { get; set; }

    //[JsonProperty("location", NullValueHandling = NullValueHandling.Ignore)]
    //public DefenderAlertLocation Location { get; set; }

    [JsonProperty("type")]
    public string Type { get; set; }

    [JsonProperty("dnsDomain", NullValueHandling = NullValueHandling.Ignore)]
    public string DnsDomain { get; set; }

    [JsonProperty("ntDomain", NullValueHandling = NullValueHandling.Ignore)]
    public string NtDomain { get; set; }

    [JsonProperty("hostName", NullValueHandling = NullValueHandling.Ignore)]
    public string HostName { get; set; }

    [JsonProperty("netBiosName", NullValueHandling = NullValueHandling.Ignore)]
    public string NetBiosName { get; set; }

    [JsonProperty("azureID", NullValueHandling = NullValueHandling.Ignore)]
    public string AzureId { get; set; }

    [JsonProperty("omsAgentID", NullValueHandling = NullValueHandling.Ignore)]
    public string OmsAgentId { get; set; }

    [JsonProperty("operatingSystem", NullValueHandling = NullValueHandling.Ignore)]
    public string OperatingSystem { get; set; }

    [JsonProperty("OsVersion")]
    public object OsVersion { get; set; }

    [JsonProperty("name", NullValueHandling = NullValueHandling.Ignore)]
    public string Name { get; set; }

    [JsonProperty("logonId", NullValueHandling = NullValueHandling.Ignore)]
    public string LogonId { get; set; }

    [JsonProperty("sid", NullValueHandling = NullValueHandling.Ignore)]
    public string Sid { get; set; }

    [JsonProperty("directory", NullValueHandling = NullValueHandling.Ignore)]
    public string Directory { get; set; }

    [JsonProperty("processId", NullValueHandling = NullValueHandling.Ignore)]
    public string ProcessId { get; set; }

    [JsonProperty("commandLine", NullValueHandling = NullValueHandling.Ignore)]
    public string CommandLine { get; set; }

    [JsonProperty("creationTimeUtc", NullValueHandling = NullValueHandling.Ignore)]
    public DateTimeOffset? CreationTimeUtc { get; set; }
}

//public partial class DefenderAlertLocation
//{
//    [JsonProperty("countryCode")]
//    public string CountryCode { get; set; }

//    [JsonProperty("state")]
//    public string State { get; set; }

//    [JsonProperty("city")]
//    public string City { get; set; }

//    [JsonProperty("longitude")]
//    public double Longitude { get; set; }

//    [JsonProperty("latitude")]
//    public double Latitude { get; set; }

//    [JsonProperty("asn")]
//    public long Asn { get; set; }
//}

public class DefenderAlertExtendedLink
{
    [JsonProperty("Category")]
    public string Category { get; set; }

    [JsonProperty("Label")]
    public string Label { get; set; }

    [JsonProperty("Href")]
    public Uri Href { get; set; }

    [JsonProperty("Type")]
    public string Type { get; set; }
}

public class DefenderAlertExtendedProperties
{
    [JsonProperty("Property1", NullValueHandling = NullValueHandling.Ignore)]
    public string Property1 { get; set; }

    [JsonProperty("domain name", NullValueHandling = NullValueHandling.Ignore)]
    public string DomainName { get; set; }

    [JsonProperty("user name", NullValueHandling = NullValueHandling.Ignore)]
    public string UserName { get; set; }

    [JsonProperty("process name", NullValueHandling = NullValueHandling.Ignore)]
    public string ProcessName { get; set; }

    [JsonProperty("command line", NullValueHandling = NullValueHandling.Ignore)]
    public string CommandLine { get; set; }

    [JsonProperty("parent process", NullValueHandling = NullValueHandling.Ignore)]
    public string ParentProcess { get; set; }

    [JsonProperty("process id", NullValueHandling = NullValueHandling.Ignore)]
    public string ProcessId { get; set; }

    [JsonProperty("account logon id", NullValueHandling = NullValueHandling.Ignore)]
    public string AccountLogonId { get; set; }

    [JsonProperty("user SID", NullValueHandling = NullValueHandling.Ignore)]
    public string UserSid { get; set; }

    [JsonProperty("parent process id", NullValueHandling = NullValueHandling.Ignore)]
    public string ParentProcessId { get; set; }

    [JsonProperty("resourceType", NullValueHandling = NullValueHandling.Ignore)]
    public string ResourceType { get; set; }
}

public class DefenderAlertResourceIdentifier
{
    [JsonProperty("azureResourceId", NullValueHandling = NullValueHandling.Ignore)]
    public string AzureResourceId { get; set; }

    [JsonProperty("type")]
    public string Type { get; set; }

    [JsonProperty("workspaceId", NullValueHandling = NullValueHandling.Ignore)]
    public string WorkspaceId { get; set; }

    [JsonProperty("workspaceSubscriptionId", NullValueHandling = NullValueHandling.Ignore)]
    public string WorkspaceSubscriptionId { get; set; }

    [JsonProperty("workspaceResourceGroup", NullValueHandling = NullValueHandling.Ignore)]
    public string WorkspaceResourceGroup { get; set; }

    [JsonProperty("agentId", NullValueHandling = NullValueHandling.Ignore)]
    public string AgentId { get; set; }
}