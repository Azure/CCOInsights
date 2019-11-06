// AKS Clusters
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId", "displayName"}, {"subscriptionId", "displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"subscriptionId", "SubscriptionId"}, {"displayName", "Subscription Name"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns", "AKSClusters", each ListAKS([SubscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"AKSClusters"}),
    #"Expanded AKSClusters" = Table.ExpandTableColumn(#"Removed Errors", "AKSClusters", {"id", "location", "name", "type", "provisioningState", "kubernetesVersion", "dnsPrefix", "fqdn", "name.1", "count", "vmSize", "storageProfile", "maxPods", "osType", "vnetSubnetID", "servicePrincipalProfile.clientId", "addonProfiles.omsagent.enabled", "logAnalyticsWorkspaceResourceID", "nodeResourceGroup", "enableRBAC", "AKS Cluster Id", "clientId", "enabled", "config", "enabled.1", "networkPlugin", "serviceCidr", "dnsServiceIP", "dockerBridgeCidr"}, {"id", "location", "name", "type", "provisioningState", "kubernetesVersion", "dnsPrefix", "fqdn", "name.1", "count", "vmSize", "storageProfile", "maxPods", "osType", "vnetSubnetID", "servicePrincipalProfile.clientId", "addonProfiles.omsagent.enabled", "logAnalyticsWorkspaceResourceID", "nodeResourceGroup", "enableRBAC", "AKS Cluster Id", "clientId", "enabled", "config", "enabled.1", "networkPlugin", "serviceCidr", "dnsServiceIP", "dockerBridgeCidr"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded AKSClusters",{"SubscriptionId", "Subscription Name"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"name.1", "Agent Pool Name"}}),
    #"Added Conditional Column" = Table.AddColumn(#"Renamed Columns1", "ClusterImage", each if [AKS Cluster Id] = "ClusterImage" then "" else "https://azure.github.io/ccodashboard/assets/pictures/000_AKS_ContainersLogo.svg"),
    #"Renamed Columns2" = Table.RenameColumns(#"Added Conditional Column",{{"name", "Cluster Name"}}),
    #"Expanded config" = Table.ExpandRecordColumn(#"Renamed Columns2", "config", {"HTTPApplicationRoutingZoneName"}, {"HTTPApplicationRoutingZoneName"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Expanded config",{"HTTPApplicationRoutingZoneName", "enabled", "enabled.1", "AKS Cluster Id", "clientId", "networkPlugin", "serviceCidr", "dnsServiceIP", "dockerBridgeCidr"}),
    #"Replaced Value" = Table.ReplaceValue(#"Removed Columns1",null,false,Replacer.ReplaceValue,{"addonProfiles.omsagent.enabled"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Replaced Value",{{"enableRBAC", type number}}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Changed Type", "addonProfiles.omsagent.enabled", "addonProfiles.omsagent.enabled - Copy"),
    #"Changed Type1" = Table.TransformColumnTypes(#"Duplicated Column",{{"addonProfiles.omsagent.enabled - Copy", type number}}),
    #"Renamed Columns3" = Table.RenameColumns(#"Changed Type1",{{"addonProfiles.omsagent.enabled - Copy", "LA agent"}})
in
    #"Renamed Columns3"

// ListAKS
let ListAKS= (subscriptionId as text) =>

let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.ContainerService/managedClusters?api-version=2019-08-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "location", "name", "type", "properties"}, {"id", "location", "name", "type", "properties"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column1", "properties", {"provisioningState", "kubernetesVersion", "dnsPrefix", "fqdn", "agentPoolProfiles", "servicePrincipalProfile", "addonProfiles", "nodeResourceGroup", "enableRBAC", "networkProfile"}, {"provisioningState", "kubernetesVersion", "dnsPrefix", "fqdn", "agentPoolProfiles", "servicePrincipalProfile", "addonProfiles", "nodeResourceGroup", "enableRBAC", "networkProfile"}),
    #"Expanded agentPoolProfiles" = Table.ExpandListColumn(#"Expanded properties", "agentPoolProfiles"),
    #"Expanded agentPoolProfiles1" = Table.ExpandRecordColumn(#"Expanded agentPoolProfiles", "agentPoolProfiles", {"name", "count", "vmSize", "storageProfile", "maxPods", "osType", "vnetSubnetID", "osDiskSizeGB"}, {"name.1", "count", "vmSize", "storageProfile", "maxPods", "osType", "vnetSubnetID", "osDiskSizeGB"}),
    #"Expanded servicePrincipalProfile" = Table.ExpandRecordColumn(#"Expanded agentPoolProfiles1", "servicePrincipalProfile", {"clientId"}, {"servicePrincipalProfile.clientId"}),
    #"Expanded addonProfiles" = Table.ExpandRecordColumn(#"Expanded servicePrincipalProfile", "addonProfiles", {"httpApplicationRouting", "omsagent", "httpapplicationrouting"}, {"addonProfiles.httpApplicationRouting.1", "addonProfiles.omsagent", "addonProfiles.httpapplicationrouting"}),
    #"Expanded addonProfiles.omsagent" = Table.ExpandRecordColumn(#"Expanded addonProfiles", "addonProfiles.omsagent", {"enabled", "config"}, {"addonProfiles.omsagent.enabled", "addonProfiles.omsagent.config"}),
    #"Expanded addonProfiles.omsagent.config" = Table.ExpandRecordColumn(#"Expanded addonProfiles.omsagent", "addonProfiles.omsagent.config", {"logAnalyticsWorkspaceResourceID", "loganalyticsworkspaceresourceid"}, {"addonProfiles.omsagent.config.logAnalyticsWorkspaceResourceID.1", "addonProfiles.omsagent.config.loganalyticsworkspaceresourceid"}),
    #"Merged Columns" = Table.CombineColumns(#"Expanded addonProfiles.omsagent.config",{"addonProfiles.omsagent.config.logAnalyticsWorkspaceResourceID.1", "addonProfiles.omsagent.config.loganalyticsworkspaceresourceid"},Combiner.CombineTextByDelimiter("", QuoteStyle.None),"Merged"),
    #"Renamed Columns" = Table.RenameColumns(#"Merged Columns",{{"Merged", "logAnalyticsWorkspaceResourceID"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns",{"addonProfiles.httpapplicationrouting", "networkProfile", "addonProfiles.httpApplicationRouting.1"})
in
    #"Removed Columns"
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
    #"Expanded AKSClusters" = Table.ExpandTableColumn(#"Removed Errors", "AKSClusters", {"id", "location", "name", "type", "provisioningState", "kubernetesVersion", "dnsPrefix", "fqdn", "name.1", "count", "vmSize", "storageProfile", "maxPods", "osType", "logAnalyticsWorkspaceResourceID", "nodeResourceGroup", "enableRBAC", "AKS Cluster Id", "clientId", "enabled", "config", "enabled.1", "networkPlugin", "serviceCidr", "dnsServiceIP", "dockerBridgeCidr"}, {"id", "location", "name", "type", "provisioningState", "kubernetesVersion", "dnsPrefix", "fqdn", "name.1", "count", "vmSize", "storageProfile", "maxPods", "osType", "logAnalyticsWorkspaceResourceID", "nodeResourceGroup", "enableRBAC", "AKS Cluster Id", "clientId", "enabled", "config", "enabled.1", "networkPlugin", "serviceCidr", "dnsServiceIP", "dockerBridgeCidr"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded AKSClusters",{"SubscriptionId", "Subscription Name"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"name.1", "Agent Pool Name"}}),
    #"Added Conditional Column" = Table.AddColumn(#"Renamed Columns1", "ClusterImage", each if [AKS Cluster Id] = "ClusterImage" then "" else "https://azure.github.io/ccodashboard/assets/pictures/000_AKS_ContainersLogo.svg"),
    #"Added Conditional Column1" = Table.AddColumn(#"Added Conditional Column", "HostImage", each if [AKS Cluster Id] = "HostImage" then "" else "https://azure.github.io/ccodashboard/assets/pictures/002_AKS_ContainersHost.svg"),
    #"Added Conditional Column2" = Table.AddColumn(#"Added Conditional Column1", "PodImage", each if [AKS Cluster Id] = "PodImage" then "" else "https://azure.github.io/ccodashboard/assets/pictures/003_AKS_PodImage.svg"),
    #"Added Conditional Column3" = Table.AddColumn(#"Added Conditional Column2", "ContainerImage", each if [AKS Cluster Id] = "ContainerImage" then "" else "https://azure.github.io/ccodashboard/assets/pictures/004_AKS_SingleContainerLogo.svg"),
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
    #"Expanded config" = Table.ExpandRecordColumn(#"Renamed Columns3", "config", {"HTTPApplicationRoutingZoneName"}, {"HTTPApplicationRoutingZoneName"}),
    #"Renamed Columns4" = Table.RenameColumns(#"Expanded config",{{"id", "AKSClusterId"}}),
    #"Removed Columns2" = Table.RemoveColumns(#"Renamed Columns4",{"AKS Cluster Id"}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Removed Columns2", "AKSClusterId", "AKSClusterId - Copy"),
    #"Split Column by Delimiter1" = Table.SplitColumn(#"Duplicated Column", "AKSClusterId - Copy", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"AKSClusterId - Copy.1", "AKSClusterId - Copy.2", "AKSClusterId - Copy.3", "AKSClusterId - Copy.4", "AKSClusterId - Copy.5", "AKSClusterId - Copy.6", "AKSClusterId - Copy.7", "AKSClusterId - Copy.8", "AKSClusterId - Copy.9"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Split Column by Delimiter1",{{"AKSClusterId - Copy.1", type text}, {"AKSClusterId - Copy.2", type text}, {"AKSClusterId - Copy.3", type text}, {"AKSClusterId - Copy.4", type text}, {"AKSClusterId - Copy.5", type text}, {"AKSClusterId - Copy.6", type text}, {"AKSClusterId - Copy.7", type text}, {"AKSClusterId - Copy.8", type text}, {"AKSClusterId - Copy.9", type text}}),
    #"Removed Columns3" = Table.RemoveColumns(#"Changed Type1",{"AKSClusterId - Copy.2", "AKSClusterId - Copy.4", "AKSClusterId - Copy.5", "AKSClusterId - Copy.6", "AKSClusterId - Copy.7", "AKSClusterId - Copy.8", "AKSClusterId - Copy.9", "AKSClusterId - Copy.1"}),
    #"Renamed Columns5" = Table.RenameColumns(#"Removed Columns3",{{"AKSClusterId - Copy.3", "SubscriptionId"}}),
    #"Added Custom" = Table.AddColumn(#"Renamed Columns5", "Custom", each (Text.Combine({"/subscription/",[SubscriptionId],"/resourceGroups/",[nodeResourceGroup],"/providers/Microsoft.Compute/virtualMachines/",[Computer]}))),
    #"Renamed Columns6" = Table.RenameColumns(#"Added Custom",{{"Custom", "VMNodeID"}}),
    #"Added Conditional Column4" = Table.AddColumn(#"Renamed Columns6", "ContainerStatusIcon", each if [ContainerStatus] = "running" then 2 else if [ContainerStatus] = "waiting" then 1 else if [ContainerStatus] = "terminated" then 0 else if [ContainerStatus] = "Unknown" then 3 else null),
    #"Added Conditional Column5" = Table.AddColumn(#"Added Conditional Column4", "PodStatusIcon", each if [PodStatus] = "Running" then 2 else if [PodStatus] = "Failed" then 0 else if [PodStatus] = "Unknown" then 3 else if [PodStatus] = "Pending" then 1 else null)
in
    #"Added Conditional Column5"

// ListOMSCutomerId
let ListOMSCustomerId= (WorkspaceId as text) =>

let
    Source = Json.Document(Web.Contents("https://management.azure.com/"&WorkspaceId&"?api-version=2015-11-01-preview")),
    properties = Source[properties],
    #"Converted to Table" = Record.ToTable(properties),
    #"Transposed Table" = Table.Transpose(#"Converted to Table"),
    #"Promoted Headers" = Table.PromoteHeaders(#"Transposed Table", [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"source", type text}, {"customerId", type text}, {"provisioningState", type text}, {"sku", type any}, {"retentionInDays", Int64.Type}, {"features", type any}, {"workspaceCapping", type any}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type",{"sku", "features", "workspaceCapping"})
in
    #"Removed Columns"

in
    #"ListOMSCustomerId"

// ListKubePodInventory
let ListKubePodInventory = (CustomerId as text , ClusterName as text) =>

let Source = Json.Document(Web.Contents("https://api.loganalytics.io/v1/workspaces/"&CustomerId&"/query", 
[Query=[#"query"="KubePodInventory
| where ClusterName == """&ClusterName&""" 
",#"x-ms-app"="OmsAnalyticsPBI",#"timespan"="PT2H",#"prefer"="ai.response-thinning=true"],Timeout=#duration(0,0,4,0)])),
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
    #"Expanded AKSClusters" = Table.ExpandTableColumn(#"Removed Errors", "AKSClusters", {"id", "location", "name", "type", "provisioningState", "kubernetesVersion", "dnsPrefix", "fqdn", "name.1", "count", "vmSize", "storageProfile", "maxPods", "osType", "logAnalyticsWorkspaceResourceID", "nodeResourceGroup", "enableRBAC", "clientId", "enabled", "config", "enabled.1", "networkPlugin", "serviceCidr", "dnsServiceIP", "dockerBridgeCidr"}, {"id", "location", "name", "type", "provisioningState", "kubernetesVersion", "dnsPrefix", "fqdn", "name.1", "count", "vmSize", "storageProfile", "maxPods", "osType", "logAnalyticsWorkspaceResourceID", "nodeResourceGroup", "enableRBAC", "clientId", "enabled", "config", "enabled.1", "networkPlugin", "serviceCidr", "dnsServiceIP", "dockerBridgeCidr"}),
    #"Renamed Columns4" = Table.RenameColumns(#"Expanded AKSClusters",{{"id", "AKSClusterId"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns4",{"SubscriptionId", "Subscription Name"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"name.1", "Agent Pool Name"}}),
    #"Added Conditional Column" = Table.AddColumn(#"Renamed Columns1", "ClusterImage", each if [AKSClusterId] = "ClusterImage" then "" else "https://azure.github.io/ccodashboard/assets/pictures/000_AKS_ContainersLogo.svg"),
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
    #"Removed Duplicates1" = Table.Distinct(#"Expanded ContainerImageInventory", {"ImageID"}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Removed Duplicates1", "AKSClusterId", "AKSClusterId - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "AKSClusterId - Copy", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"AKSClusterId - Copy.1", "AKSClusterId - Copy.2", "AKSClusterId - Copy.3", "AKSClusterId - Copy.4", "AKSClusterId - Copy.5", "AKSClusterId - Copy.6", "AKSClusterId - Copy.7", "AKSClusterId - Copy.8", "AKSClusterId - Copy.9"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Split Column by Delimiter",{"AKSClusterId - Copy.1", "AKSClusterId - Copy.2", "AKSClusterId - Copy.4", "AKSClusterId - Copy.5", "AKSClusterId - Copy.6", "AKSClusterId - Copy.7", "AKSClusterId - Copy.8", "AKSClusterId - Copy.9"}),
    #"Renamed Columns5" = Table.RenameColumns(#"Removed Columns1",{{"AKSClusterId - Copy.3", "SubscriptionId"}}),
    #"Added Custom" = Table.AddColumn(#"Renamed Columns5", "VMNodeId", each (Text.Combine({"/subscription/",[SubscriptionId],"/resourceGroups/",[nodeResourceGroup],"/providers/Microsoft.Compute/virtualMachines/",[Computer]})))
in
    #"Added Custom"

// ListContainerImageInventory
let ListContainerImageInventory = (CustomerId as text , ComputerName as text) =>

let Source = Json.Document(Web.Contents("https://api.loganalytics.io/v1/workspaces/"&CustomerId&"/query", 
[Query=[#"query"="ContainerImageInventory
| where Computer == """&ComputerName&""" 
",#"x-ms-app"="OmsAnalyticsPBI",#"timespan"="PT2H",#"prefer"="ai.response-thinning=true"],Timeout=#duration(0,0,4,0)])),
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

// ListImages
let ListContainerImageInventory = (CustomerId as text , ComputerName as text) =>

let Source = Json.Document(Web.Contents("https://api.loganalytics.io/v1/workspaces/"&CustomerId&"/query", 
[Query=[#"query"="ContainerInventory
| where Computer == """&ComputerName&""" 
",#"x-ms-app"="OmsAnalyticsPBI",#"timespan"="PT2H",#"prefer"="ai.response-thinning=true"],Timeout=#duration(0,0,4,0)])),
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

// ImageInventory
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId", "displayName"}, {"subscriptionId", "displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"subscriptionId", "SubscriptionId"}, {"displayName", "Subscription Name"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns", "AKSClusters", each ListAKS([SubscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"AKSClusters"}),
    #"Expanded AKSClusters" = Table.ExpandTableColumn(#"Removed Errors", "AKSClusters", {"id", "location", "name", "type", "provisioningState", "kubernetesVersion", "dnsPrefix", "fqdn", "name.1", "count", "vmSize", "storageProfile", "maxPods", "osType", "logAnalyticsWorkspaceResourceID", "nodeResourceGroup", "enableRBAC", "clientId", "enabled", "config", "enabled.1", "networkPlugin", "serviceCidr", "dnsServiceIP", "dockerBridgeCidr"}, {"id", "location", "name", "type", "provisioningState", "kubernetesVersion", "dnsPrefix", "fqdn", "name.1", "count", "vmSize", "storageProfile", "maxPods", "osType", "logAnalyticsWorkspaceResourceID", "nodeResourceGroup", "enableRBAC", "clientId", "enabled", "config", "enabled.1", "networkPlugin", "serviceCidr", "dnsServiceIP", "dockerBridgeCidr"}),
    #"Renamed Columns4" = Table.RenameColumns(#"Expanded AKSClusters",{{"id", "AKSClusterId"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns4",{"SubscriptionId", "Subscription Name"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"name.1", "Agent Pool Name"}}),
    #"Added Conditional Column" = Table.AddColumn(#"Renamed Columns1", "ClusterImage", each if [AKSClusterId] = "ClusterImage" then "" else "https://azure.github.io/ccodashboard/assets/pictures/000_AKS_ContainersLogo.svg"),
    #"Renamed Columns2" = Table.RenameColumns(#"Added Conditional Column",{{"name", "Cluster Name"}}),
    #"Invoked Custom Function1" = Table.AddColumn(#"Renamed Columns2", "CustomerId", each ListOMSCutomerId([logAnalyticsWorkspaceResourceID])),
    #"Removed Errors2" = Table.RemoveRowsWithErrors(#"Invoked Custom Function1", {"CustomerId"}),
    #"Expanded CustomerId" = Table.ExpandTableColumn(#"Removed Errors2", "CustomerId", {"customerId"}, {"customerId.1"}),
    #"Renamed Columns3" = Table.RenameColumns(#"Expanded CustomerId",{{"customerId.1", "CustomerId"}}),
    #"Invoked Custom Function2" = Table.AddColumn(#"Renamed Columns3", "KubePodComputerName", each ListKubePodInventory([CustomerId], [Cluster Name])),
    #"Expanded KubePodComputerName" = Table.ExpandTableColumn(#"Invoked Custom Function2", "KubePodComputerName", {"Computer"}, {"Computer"}),
    #"Removed Duplicates" = Table.Distinct(#"Expanded KubePodComputerName", {"Computer"}),
    #"Invoked Custom Function3" = Table.AddColumn(#"Removed Duplicates", "ContainerImageInventory", each ListImages([CustomerId], [Computer])),
    #"Removed Errors1" = Table.RemoveRowsWithErrors(#"Invoked Custom Function3", {"ContainerImageInventory"}),
    #"Expanded ContainerImageInventory" = Table.ExpandTableColumn(#"Removed Errors1", "ContainerImageInventory", {"TenantId", "SourceSystem", "TimeGenerated", "Computer", "ContainerID", "Name", "ContainerHostname", "ImageID", "Repository", "Image", "ImageTag", "ContainerState", "Ports", "Links", "ExitCode", "ComposeGroup", "EnvironmentVar", "Command", "CreatedTime", "StartedTime", "FinishedTime", "Type", "_ResourceId"}, {"ContainerImageInventory.TenantId", "ContainerImageInventory.SourceSystem", "ContainerImageInventory.TimeGenerated", "ContainerImageInventory.Computer", "ContainerImageInventory.ContainerID", "ContainerImageInventory.Name", "ContainerImageInventory.ContainerHostname", "ContainerImageInventory.ImageID", "ContainerImageInventory.Repository", "ContainerImageInventory.Image", "ContainerImageInventory.ImageTag", "ContainerImageInventory.ContainerState", "ContainerImageInventory.Ports", "ContainerImageInventory.Links", "ContainerImageInventory.ExitCode", "ContainerImageInventory.ComposeGroup", "ContainerImageInventory.EnvironmentVar", "ContainerImageInventory.Command", "ContainerImageInventory.CreatedTime", "ContainerImageInventory.StartedTime", "ContainerImageInventory.FinishedTime", "ContainerImageInventory.Type", "ContainerImageInventory._ResourceId"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded ContainerImageInventory",{{"ContainerImageInventory.FinishedTime", type datetimezone}, {"ContainerImageInventory.StartedTime", type datetimezone}, {"ContainerImageInventory.CreatedTime", type datetimezone}})
in
    #"Changed Type"