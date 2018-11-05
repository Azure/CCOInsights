// AKS Clusters
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId", "displayName"}, {"subscriptionId", "displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"subscriptionId", "SubscriptionId"}, {"displayName", "Subscription Name"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns", "AKSClusters", each ListAKS([SubscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"AKSClusters"}),
    #"Expanded AKSClusters" = Table.ExpandTableColumn(#"Removed Errors", "AKSClusters", {"AKS Cluster Id", "location", "name", "type", "provisioningState", "kubernetesVersion", "dnsPrefix", "fqdn", "name.1", "count", "vmSize", "storageProfile", "maxPods", "osType", "clientId", "enabled", "config", "enabled.1", "logAnalyticsWorkspaceResourceID", "nodeResourceGroup", "enableRBAC", "networkPlugin", "serviceCidr", "dnsServiceIP", "dockerBridgeCidr"}, {"AKS Cluster Id", "location", "name", "type", "provisioningState", "kubernetesVersion", "dnsPrefix", "fqdn", "name.1", "count", "vmSize", "storageProfile", "maxPods", "osType", "clientId", "enabled", "config", "enabled.1", "logAnalyticsWorkspaceResourceID", "nodeResourceGroup", "enableRBAC", "networkPlugin", "serviceCidr", "dnsServiceIP", "dockerBridgeCidr"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded AKSClusters",{"SubscriptionId", "Subscription Name"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"name.1", "Agent Pool Name"}}),
    #"Added Conditional Column" = Table.AddColumn(#"Renamed Columns1", "ClusterImage", each if [AKS Cluster Id] = "ClusterImage" then "" else "https://raw.githubusercontent.com/JSFCES/DashboardImages/master/ContainersLogo.svg?sanitize=true"),
    #"Renamed Columns2" = Table.RenameColumns(#"Added Conditional Column",{{"name", "Cluster Name"}})
in
    #"Renamed Columns2"

// ListAKS
let ListAKS= (subscriptionId as text) =>

let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.ContainerService/managedClusters?api-version=2018-03-31")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "location", "name", "type", "properties"}, {"id", "location", "name", "type", "properties"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column1", "properties", {"provisioningState", "kubernetesVersion", "dnsPrefix", "fqdn", "agentPoolProfiles", "servicePrincipalProfile", "addonProfiles", "nodeResourceGroup", "enableRBAC", "networkProfile"}, {"provisioningState", "kubernetesVersion", "dnsPrefix", "fqdn", "agentPoolProfiles", "servicePrincipalProfile", "addonProfiles", "nodeResourceGroup", "enableRBAC", "networkProfile"}),
    #"Expanded agentPoolProfiles" = Table.ExpandListColumn(#"Expanded properties", "agentPoolProfiles"),
    #"Expanded agentPoolProfiles1" = Table.ExpandRecordColumn(#"Expanded agentPoolProfiles", "agentPoolProfiles", {"name", "count", "vmSize", "storageProfile", "maxPods", "osType"}, {"name.1", "count", "vmSize", "storageProfile", "maxPods", "osType"}),
    #"Expanded servicePrincipalProfile" = Table.ExpandRecordColumn(#"Expanded agentPoolProfiles1", "servicePrincipalProfile", {"clientId"}, {"clientId"}),
    #"Expanded addonProfiles" = Table.ExpandRecordColumn(#"Expanded servicePrincipalProfile", "addonProfiles", {"httpApplicationRouting", "omsagent"}, {"httpApplicationRouting", "omsagent"}),
    #"Expanded httpApplicationRouting" = Table.ExpandRecordColumn(#"Expanded addonProfiles", "httpApplicationRouting", {"enabled", "config"}, {"enabled", "config"}),
    #"Expanded omsagent" = Table.ExpandRecordColumn(#"Expanded httpApplicationRouting", "omsagent", {"enabled", "config"}, {"enabled.1", "config.1"}),
    #"Expanded config.1" = Table.ExpandRecordColumn(#"Expanded omsagent", "config.1", {"logAnalyticsWorkspaceResourceID"}, {"logAnalyticsWorkspaceResourceID"}),
    #"Expanded networkProfile" = Table.ExpandRecordColumn(#"Expanded config.1", "networkProfile", {"networkPlugin", "serviceCidr", "dnsServiceIP", "dockerBridgeCidr"}, {"networkPlugin", "serviceCidr", "dnsServiceIP", "dockerBridgeCidr"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded networkProfile",{{"id", "AKS Cluster Id"}})
in
    #"Renamed Columns"

in
    #"ListAKS"

// AKS KubePodInventory
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId", "displayName"}, {"subscriptionId", "displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"subscriptionId", "SubscriptionId"}, {"displayName", "Subscription Name"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns", "AKSClusters", each ListAKS([SubscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"AKSClusters"}),
    #"Expanded AKSClusters" = Table.ExpandTableColumn(#"Removed Errors", "AKSClusters", {"AKS Cluster Id", "location", "name", "type", "provisioningState", "kubernetesVersion", "dnsPrefix", "fqdn", "name.1", "count", "vmSize", "storageProfile", "maxPods", "osType", "clientId", "enabled", "config", "enabled.1", "logAnalyticsWorkspaceResourceID", "nodeResourceGroup", "enableRBAC", "networkPlugin", "serviceCidr", "dnsServiceIP", "dockerBridgeCidr"}, {"AKS Cluster Id", "location", "name", "type", "provisioningState", "kubernetesVersion", "dnsPrefix", "fqdn", "name.1", "count", "vmSize", "storageProfile", "maxPods", "osType", "clientId", "enabled", "config", "enabled.1", "logAnalyticsWorkspaceResourceID", "nodeResourceGroup", "enableRBAC", "networkPlugin", "serviceCidr", "dnsServiceIP", "dockerBridgeCidr"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded AKSClusters",{"SubscriptionId", "Subscription Name"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"name.1", "Agent Pool Name"}}),
    #"Added Conditional Column" = Table.AddColumn(#"Renamed Columns1", "ClusterImage", each if [AKS Cluster Id] = "ClusterImage" then "" else "https://raw.githubusercontent.com/JSFCES/DashboardImages/master/ContainersLogo.svg?sanitize=true"),
    #"Added Conditional Column1" = Table.AddColumn(#"Added Conditional Column", "HostImage", each if [AKS Cluster Id] = "HostImage" then "" else "https://raw.githubusercontent.com/JSFCES/DashboardImages/master/ContainersHost.svg?sanitize=true"),
    #"Added Conditional Column2" = Table.AddColumn(#"Added Conditional Column1", "PodImage", each if [AKS Cluster Id] = "PodImage" then "" else "https://raw.githubusercontent.com/JSFCES/DashboardImages/master/PodImage.svg?sanitize=true"),
    #"Added Conditional Column3" = Table.AddColumn(#"Added Conditional Column2", "ContainerImage", each if [AKS Cluster Id] = "ContainerImage" then "" else "https://raw.githubusercontent.com/JSFCES/DashboardImages/master/SingleContainerLogo.svg?sanitize=true"),
    #"Invoked Custom Function1" = Table.AddColumn(#"Added Conditional Column3", "OMS Customer Id", each ListOMSCutomerId([logAnalyticsWorkspaceResourceID])),
    #"Removed Errors1" = Table.RemoveRowsWithErrors(#"Invoked Custom Function1", {"OMS Customer Id"}),
    #"Expanded OMS Customer Id" = Table.ExpandTableColumn(#"Removed Errors1", "OMS Customer Id", {"customerId"}, {"customerId"}),
    #"Invoked Custom Function2" = Table.AddColumn(#"Expanded OMS Customer Id", "KubePodInventoryTable", each ListKubePodInventory([customerId], [name])),
    #"Expanded KubePodInventoryTable1" = Table.ExpandTableColumn(#"Invoked Custom Function2", "KubePodInventoryTable", {"TimeGenerated", "Computer", "ContainerCreationTimeStamp", "PodUid", "PodCreationTimeStamp", "InstanceName", "ContainerRestartCount", "PodRestartCount", "PodStartTime", "ContainerStartTime", "ServiceName", "ControllerKind", "ControllerName", "ContainerStatus", "ContainerID", "ContainerName", "Name", "PodLabel", "Namespace", "PodStatus", "ClusterName", "PodIp"}, {"TimeGenerated", "Computer", "ContainerCreationTimeStamp", "PodUid", "PodCreationTimeStamp", "InstanceName", "ContainerRestartCount", "PodRestartCount", "PodStartTime", "ContainerStartTime", "ServiceName", "ControllerKind", "ControllerName", "ContainerStatus", "ContainerID", "ContainerName", "Name.1", "PodLabel", "Namespace", "PodStatus", "ClusterName", "PodIp"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Expanded KubePodInventoryTable1",{{"Name.1", "Pod Name"}}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Renamed Columns2", "ContainerName", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"ContainerName.1", "ContainerName.2"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"ContainerName.1", type text}, {"ContainerName.2", type text}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Changed Type",{"ContainerName.1"}),
    #"Renamed Columns3" = Table.RenameColumns(#"Removed Columns1",{{"ContainerName.2", "ContainerName"}}),
    #"Expanded config" = Table.ExpandRecordColumn(#"Renamed Columns3", "config", {"HTTPApplicationRoutingZoneName"}, {"HTTPApplicationRoutingZoneName"})
in
    #"Expanded config"

// ListOMSCutomerId
let ListOMSCustomerId= (WorkspaceId as text) =>

let
    Source = Json.Document(Web.Contents("https://management.azure.com/"&WorkspaceId&"?api-version=2015-11-01-preview")),
    #"Converted to Table" = Record.ToTable(Source),
    Value = #"Converted to Table"{0}[Value],
    #"Converted to Table1" = Record.ToTable(Value),
    #"Reversed Rows" = Table.ReverseRows(#"Converted to Table1"),
    #"Reversed Rows1" = Table.ReverseRows(#"Reversed Rows"),
    #"Transposed Table" = Table.Transpose(#"Reversed Rows1"),
    #"Promoted Headers" = Table.PromoteHeaders(#"Transposed Table", [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"source", type text}, {"customerId", type text}, {"portalUrl", type text}, {"provisioningState", type text}, {"sku", type any}, {"retentionInDays", Int64.Type}, {"features", type any}, {"workspaceCapping", type any}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type",{"portalUrl", "provisioningState", "sku", "retentionInDays", "features", "workspaceCapping", "source"})
in
    #"Removed Columns"

in
    #"ListOMSCustomerId"

// ListKubePodInventory
let ListKubePodInventory = (CustomerId as text , ClusterName as text) =>

let Source = Json.Document(Web.Contents("https://api.loganalytics.io/v1/workspaces/"&CustomerId&"/query", 
[Query=[#"query"="KubePodInventory
| where ClusterName == """&ClusterName&""" 
",#"x-ms-app"="OmsAnalyticsPBI",#"timespan"="PT6H",#"prefer"="ai.response-thinning=true"],Timeout=#duration(0,0,4,0)])),
TypeMap = #table(
{ "AnalyticsTypes", "Type" }, 
{ 
{ "string",   Text.Type },
{ "int",      Int32.Type },
{ "long",     Int64.Type },
{ "real",     Double.Type },
{ "timespan", Duration.Type },
{ "datetime", DateTimeZone.Type },
{ "bool",     Logical.Type },
{ "guid",     Text.Type },
{ "dynamic",  Text.Type }
}),
DataTable = Source[tables]{0},
Columns = Table.FromRecords(DataTable[columns]),
ColumnsWithType = Table.Join(Columns, {"type"}, TypeMap , {"AnalyticsTypes"}),
Rows = Table.FromRows(DataTable[rows], Columns[name]), 
Table = Table.TransformColumnTypes(Rows, Table.ToList(ColumnsWithType, (c) => { c{0}, c{3}}))


in
 Table


in
    ListKubePodInventory

// AKS ContainerImageInventory
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId", "displayName"}, {"subscriptionId", "displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"subscriptionId", "SubscriptionId"}, {"displayName", "Subscription Name"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns", "AKSClusters", each ListAKS([SubscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"AKSClusters"}),
    #"Expanded AKSClusters" = Table.ExpandTableColumn(#"Removed Errors", "AKSClusters", {"AKS Cluster Id", "location", "name", "type", "provisioningState", "kubernetesVersion", "dnsPrefix", "fqdn", "name.1", "count", "vmSize", "storageProfile", "maxPods", "osType", "clientId", "enabled", "config", "enabled.1", "logAnalyticsWorkspaceResourceID", "nodeResourceGroup", "enableRBAC", "networkPlugin", "serviceCidr", "dnsServiceIP", "dockerBridgeCidr"}, {"AKS Cluster Id", "location", "name", "type", "provisioningState", "kubernetesVersion", "dnsPrefix", "fqdn", "name.1", "count", "vmSize", "storageProfile", "maxPods", "osType", "clientId", "enabled", "config", "enabled.1", "logAnalyticsWorkspaceResourceID", "nodeResourceGroup", "enableRBAC", "networkPlugin", "serviceCidr", "dnsServiceIP", "dockerBridgeCidr"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded AKSClusters",{"SubscriptionId", "Subscription Name"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"name.1", "Agent Pool Name"}}),
    #"Added Conditional Column" = Table.AddColumn(#"Renamed Columns1", "ClusterImage", each if [AKS Cluster Id] = "ClusterImage" then "" else "https://raw.githubusercontent.com/JSFCES/DashboardImages/master/ContainersLogo.svg?sanitize=true"),
    #"Renamed Columns2" = Table.RenameColumns(#"Added Conditional Column",{{"name", "Cluster Name"}}),
    #"Invoked Custom Function1" = Table.AddColumn(#"Renamed Columns2", "CustomerId", each ListOMSCutomerId([logAnalyticsWorkspaceResourceID])),
    #"Removed Errors2" = Table.RemoveRowsWithErrors(#"Invoked Custom Function1", {"CustomerId"}),
    #"Expanded CustomerId" = Table.ExpandTableColumn(#"Removed Errors2", "CustomerId", {"customerId"}, {"customerId.1"}),
    #"Renamed Columns3" = Table.RenameColumns(#"Expanded CustomerId",{{"customerId.1", "CustomerId"}}),
    #"Invoked Custom Function2" = Table.AddColumn(#"Renamed Columns3", "KubePodComputerName", each ListKubePodInventory([CustomerId], [Cluster Name])),
    #"Expanded KubePodComputerName" = Table.ExpandTableColumn(#"Invoked Custom Function2", "KubePodComputerName", {"Computer"}, {"Computer"}),
    #"Removed Duplicates" = Table.Distinct(#"Expanded KubePodComputerName", {"Computer"}),
    #"Invoked Custom Function3" = Table.AddColumn(#"Removed Duplicates", "ContainerImageInventory", each ListContainerImageInventory([CustomerId], [Computer])),
    #"Removed Errors1" = Table.RemoveRowsWithErrors(#"Invoked Custom Function3", {"ContainerImageInventory"}),
    #"Expanded ContainerImageInventory" = Table.ExpandTableColumn(#"Removed Errors1", "ContainerImageInventory", {"TimeGenerated", "ImageID", "Repository", "Image", "ImageTag", "ImageSize", "VirtualSize", "Running", "Stopped", "Failed", "Paused", "TotalContainer"}, {"TimeGenerated", "ImageID", "Repository", "Image", "ImageTag", "ImageSize", "VirtualSize", "Running", "Stopped", "Failed", "Paused", "TotalContainer"}),
    #"Removed Duplicates1" = Table.Distinct(#"Expanded ContainerImageInventory", {"ImageID"})
in
    #"Removed Duplicates1"

// ListContainerImageInventory
let ListContainerImageInventory = (CustomerId as text , ComputerName as text) =>

let Source = Json.Document(Web.Contents("https://api.loganalytics.io/v1/workspaces/"&CustomerId&"/query", 
[Query=[#"query"="ContainerImageInventory
| where Computer == """&ComputerName&""" 
",#"x-ms-app"="OmsAnalyticsPBI",#"timespan"="PT6H",#"prefer"="ai.response-thinning=true"],Timeout=#duration(0,0,4,0)])),
TypeMap = #table(
{ "AnalyticsTypes", "Type" }, 
{ 
{ "string",   Text.Type },
{ "int",      Int32.Type },
{ "long",     Int64.Type },
{ "real",     Double.Type },
{ "timespan", Duration.Type },
{ "datetime", DateTimeZone.Type },
{ "bool",     Logical.Type },
{ "guid",     Text.Type },
{ "dynamic",  Text.Type }
}),
DataTable = Source[tables]{0},
Columns = Table.FromRecords(DataTable[columns]),
ColumnsWithType = Table.Join(Columns, {"type"}, TypeMap , {"AnalyticsTypes"}),
Rows = Table.FromRows(DataTable[rows], Columns[name]), 
Table = Table.TransformColumnTypes(Rows, Table.ToList(ColumnsWithType, (c) => { c{0}, c{3}}))


in
 Table


in
    ListContainerImageInventory