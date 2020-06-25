// ListVirtualMachines
let ListVirtualMachines = (subscriptionId as text) =>
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.Compute/virtualMachines?api-version=2017-12-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"properties", "resources", "type", "location", "tags", "id", "name"}, {"properties", "resources", "type", "location", "tags", "id", "name"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"id", "VM Resource Id"}, {"name", "VM Name"}}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Renamed Columns", "properties", {"vmId", "availabilitySet", "hardwareProfile", "storageProfile", "osProfile", "networkProfile", "provisioningState", "diagnosticsProfile"}, {"vmId", "availabilitySet", "hardwareProfile", "storageProfile", "osProfile", "networkProfile", "provisioningState", "diagnosticsProfile"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded properties",{"vmId"}),
    #"Expanded availabilitySet" = Table.ExpandRecordColumn(#"Removed Columns", "availabilitySet", {"id"}, {"id"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded availabilitySet",{{"id", "Availability Set Id"}}),
    #"Expanded hardwareProfile" = Table.ExpandRecordColumn(#"Renamed Columns1", "hardwareProfile", {"vmSize"}, {"vmSize"}),
    #"Expanded storageProfile" = Table.ExpandRecordColumn(#"Expanded hardwareProfile", "storageProfile", {"imageReference", "osDisk", "dataDisks"}, {"imageReference", "osDisk", "dataDisks"}),
    #"Expanded imageReference" = Table.ExpandRecordColumn(#"Expanded storageProfile", "imageReference", {"publisher", "offer", "sku", "version"}, {"publisher", "offer", "sku", "version"}),
    #"Expanded osDisk" = Table.ExpandRecordColumn(#"Expanded imageReference", "osDisk", {"osType", "name", "createOption", "vhd", "caching", "diskSizeGB", "managedDisk"}, {"osType", "name", "createOption", "vhd", "caching", "diskSizeGB", "managedDisk"}),
    #"Expanded vhd" = Table.ExpandRecordColumn(#"Expanded osDisk", "vhd", {"uri"}, {"uri"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Expanded vhd",{{"uri", "vhd uri"}}),
    #"Expanded managedDisk" = Table.ExpandRecordColumn(#"Renamed Columns2", "managedDisk", {"storageAccountType", "id"}, {"storageAccountType", "id"}),
    #"Renamed Columns3" = Table.RenameColumns(#"Expanded managedDisk",{{"id", "Managed Disk Id"}}),
    #"Expanded dataDisks" = Table.ExpandListColumn(#"Renamed Columns3", "dataDisks"),
    #"Expanded dataDisks1" = Table.ExpandRecordColumn(#"Expanded dataDisks", "dataDisks", {"lun", "name", "createOption", "vhd", "caching", "diskSizeGB"}, {"lun", "name.1", "createOption.1", "vhd", "caching.1", "diskSizeGB.1"}),
    #"Expanded vhd1" = Table.ExpandRecordColumn(#"Expanded dataDisks1", "vhd", {"uri"}, {"uri"}),
    #"Renamed Columns4" = Table.RenameColumns(#"Expanded vhd1",{{"uri", "Data vhd uri"}}),
    #"Expanded osProfile" = Table.ExpandRecordColumn(#"Renamed Columns4", "osProfile", {"computerName", "adminUsername", "linuxConfiguration", "secrets", "windowsConfiguration"}, {"computerName", "adminUsername", "linuxConfiguration", "secrets", "windowsConfiguration"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Expanded osProfile",{"linuxConfiguration", "secrets"}),
    #"Expanded windowsConfiguration" = Table.ExpandRecordColumn(#"Removed Columns1", "windowsConfiguration", {"provisionVMAgent", "enableAutomaticUpdates"}, {"provisionVMAgent", "enableAutomaticUpdates"}),
    #"Expanded networkProfile" = Table.ExpandRecordColumn(#"Expanded windowsConfiguration", "networkProfile", {"networkInterfaces"}, {"networkInterfaces"}),
    #"Expanded networkInterfaces" = Table.ExpandListColumn(#"Expanded networkProfile", "networkInterfaces"),
    #"Expanded networkInterfaces1" = Table.ExpandRecordColumn(#"Expanded networkInterfaces", "networkInterfaces", {"id"}, {"id"}),
    #"Renamed Columns5" = Table.RenameColumns(#"Expanded networkInterfaces1",{{"id", "Network Inteface Id"}}),
    #"Expanded diagnosticsProfile" = Table.ExpandRecordColumn(#"Renamed Columns5", "diagnosticsProfile", {"bootDiagnostics"}, {"bootDiagnostics"}),
    #"Expanded bootDiagnostics" = Table.ExpandRecordColumn(#"Expanded diagnosticsProfile", "bootDiagnostics", {"enabled", "storageUri"}, {"enabled", "storageUri"}),
    #"Expanded resources" = Table.ExpandListColumn(#"Expanded bootDiagnostics", "resources"),
    #"Expanded resources1" = Table.ExpandRecordColumn(#"Expanded resources", "resources", {"id"}, {"id"}),
    #"Renamed Columns6" = Table.RenameColumns(#"Expanded resources1",{{"id", "Extensions Resource Id"}}),
    #"Expanded tags" = Table.ExpandRecordColumn(#"Renamed Columns6", "tags", {"creationSource", "orchestrator", "poolName", "resourceNameSuffix"}, {"creationSource", "orchestrator", "poolName", "resourceNameSuffix"})
in
    #"Expanded tags"

in
    ListVirtualMachines

// TenantName
"microsoft.com" meta [IsParameterQuery=true, Type="Text", IsParameterQueryRequired=true]

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
    #"Removed Duplicates" = Table.Distinct(#"Expanded AKSClusters", {"id"}),
    #"Removed Columns" = Table.RemoveColumns(#"Removed Duplicates",{"SubscriptionId", "Subscription Name"}),
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

// ListACS
let ListResourceGroups= (subscriptionId as text) =>

let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.ContainerService/containerServices?api-version=2017-01-31")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error)
in
    #"Converted to Table"

in
    #"ListResourceGroups"

// ACI
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId","displayName"}, {"Column1.subscriptionId","Column1.displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"Column1.subscriptionId", "SubscriptionId"}}),
    #"List ACI" = Table.AddColumn(#"Renamed Columns", "ListACI", each ListACI([SubscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"List ACI", {"ListACI"}),
    #"Expanded ListACI" = Table.ExpandTableColumn(#"Removed Errors", "ListACI", {"id", "location", "name", "type", "properties"}, {"id", "location", "name", "type", "properties"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded ListACI", "properties", {"provisioningState", "containers", "restartPolicy", "ipAddress", "osType"}, {"provisioningState", "containers", "restartPolicy", "ipAddress", "osType"}),
    #"Expanded containers" = Table.ExpandListColumn(#"Expanded properties", "containers"),
    #"Expanded containers1" = Table.ExpandRecordColumn(#"Expanded containers", "containers", {"name", "properties"}, {"name.1", "properties"}),
    #"Expanded properties1" = Table.ExpandRecordColumn(#"Expanded containers1", "properties", {"image", "ports", "environmentVariables", "resources"}, {"image", "ports", "environmentVariables", "resources"}),
    #"Expanded ports" = Table.ExpandListColumn(#"Expanded properties1", "ports"),
    #"Expanded ports1" = Table.ExpandRecordColumn(#"Expanded ports", "ports", {"port"}, {"port"}),
    #"Expanded environmentVariables" = Table.ExpandListColumn(#"Expanded ports1", "environmentVariables"),
    #"Expanded resources" = Table.ExpandRecordColumn(#"Expanded environmentVariables", "resources", {"requests"}, {"requests"}),
    #"Expanded requests" = Table.ExpandRecordColumn(#"Expanded resources", "requests", {"memoryInGB", "cpu"}, {"memoryInGB", "cpu"}),
    #"Expanded ipAddress" = Table.ExpandRecordColumn(#"Expanded requests", "ipAddress", {"ip", "type"}, {"ip", "type.1"}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Expanded ipAddress", "id", "id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "id", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"id.1", "id.2", "id.3", "id.4", "id.5", "id.6", "id.7", "id.8", "id.9"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"id.1", type text}, {"id.2", type text}, {"id.3", type text}, {"id.4", type text}, {"id.5", type text}, {"id.6", type text}, {"id.7", type text}, {"id.8", type text}, {"id.9", type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type",{"id.1", "id.2", "id.3", "id.4"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"id.5", "Resource Group Name"}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Renamed Columns1",{"id.6", "id.7", "id.8", "id.9"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Removed Columns1",{{"id - Copy", "Id"}, {"Column1.displayName", "Subscription Name"}}),
    #"Removed Columns2" = Table.RemoveColumns(#"Renamed Columns2",{"SubscriptionId", "Subscription Name"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Columns2", {"Resource Group Name"})
in
    #"Removed Duplicates"

// ListACI
let ListResourceGroups= (subscriptionId as text) =>

let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.ContainerInstance/containerGroups?api-version=2018-10-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "location", "name", "type", "properties"}, {"id", "location", "name", "type", "properties"})
in
    #"Expanded Column1"

in
    #"ListResourceGroups"

// ListRegistry
let ListResourceGroups= (subscriptionId as text) =>

let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.ContainerRegistry/registries?api-version=2017-10-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error)
in
    #"Converted to Table"

in
    #"ListResourceGroups"

// ACR
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId","displayName"}, {"Column1.subscriptionId","Column1.displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"Column1.subscriptionId", "SubscriptionId"}}),
    #"List Registry" = Table.AddColumn(#"Renamed Columns", "ListRegistry", each ListRegistry([SubscriptionId])),
    #"Expanded ListRegistry" = Table.ExpandTableColumn(#"List Registry", "ListRegistry", {"Column1"}, {"Column1"}),
    #"Expanded Column2" = Table.ExpandRecordColumn(#"Expanded ListRegistry", "Column1", {"sku", "type", "id", "name", "location", "tags", "properties"}, {"sku", "type", "id", "name", "location", "tags", "properties"}),
    #"Expanded sku" = Table.ExpandRecordColumn(#"Expanded Column2", "sku", {"name", "tier"}, {"sku.name", "sku.tier"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded sku",{"tags"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Removed Columns", "properties", {"loginServer", "creationDate", "provisioningState", "adminUserEnabled", "storageAccount"}, {"loginServer", "creationDate", "provisioningState", "adminUserEnabled", "storageAccount"}),
    #"Expanded storageAccount" = Table.ExpandRecordColumn(#"Expanded properties", "storageAccount", {"id"}, {"id.1"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded storageAccount",{{"Column1.displayName", "Subscription Name"}}),
    #"Filtered Rows" = Table.SelectRows(#"Renamed Columns1", each [type] <> null and [type] <> ""),
    #"Removed Columns1" = Table.RemoveColumns(#"Filtered Rows",{"SubscriptionId", "Subscription Name"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Removed Columns1",{{"loginServer", "Registry login Server"}})
in
    #"Renamed Columns2"

// Resources
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId", "displayName"}, {"subscriptionId", "displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"displayName", "Subscription Name"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns", "ListResources", each ListResources([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListResources"}),
    #"Expanded ListResources" = Table.ExpandTableColumn(#"Removed Errors", "ListResources", {"Resource Id", "Resource Name", "Resource Type", "location", "creationSource", "orchestrator", "poolName", "resourceNameSuffix", "created-by", "displayName", "ms-resource-usage", "ContainerTag", "service", "hidden-related:/subscriptions/02fd7403-de8f-4ea6-8ab4-6f00f0b4a808/resourcegroup", "hidden-related:/subscriptions/02fd7403-de8f-4ea6-8ab4-6f00f0b4a808/resourceGro.1", "name", "tier", "capacity", "size", "family", "kind", "name.1", "promotionCode", "product", "publisher", "managedBy", "Resource Group Id"}, {"Resource Id", "Resource Name", "Resource Type", "location", "creationSource", "orchestrator", "poolName", "resourceNameSuffix", "created-by", "displayName", "ms-resource-usage", "ContainerTag", "service", "hidden-related:/subscriptions/02fd7403-de8f-4ea6-8ab4-6f00f0b4a808/resourcegroup", "hidden-related:/subscriptions/02fd7403-de8f-4ea6-8ab4-6f00f0b4a808/resourceGro.1", "name", "tier", "capacity", "size", "family", "kind", "name.1", "promotionCode", "product", "publisher", "managedBy", "Resource Group Id"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded ListResources", each true),
    #"Added Conditional Column" = Table.AddColumn(#"Filtered Rows", "Container Type", each if Text.Contains([Resource Type], "containerGroups") then "ACI" else if Text.Contains([Resource Type], "managedClusters") then "AKS" else if Text.Contains([Resource Type], "containerServices") then "ACS" else null),
    #"Duplicated Column" = Table.DuplicateColumn(#"Added Conditional Column", "Resource Group Id", "Resource Group Id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "Resource Group Id - Copy", Splitter.SplitTextByDelimiter("/resourceGroups/", QuoteStyle.Csv), {"Resource Group Id - Copy.1", "Resource Group Id - Copy.2"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Resource Group Id - Copy.1", type text}, {"Resource Group Id - Copy.2", type text}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Changed Type",{"Resource Group Id - Copy.1"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns1",{{"Resource Group Id - Copy.2", "Resource Group Name"}})
in
    #"Renamed Columns1"

// ListResources
let ListResources = (subscriptionId as text) =>
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/resources?api-version=2017-05-10")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "name", "type", "location", "tags", "sku", "kind", "plan", "managedBy"}, {"id", "name", "type", "location", "tags", "sku", "kind", "plan", "managedBy"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"id", "Resource Id"}, {"name", "Resource Name"}, {"type", "Resource Type"}}),
    #"Expanded tags" = Table.ExpandRecordColumn(#"Renamed Columns", "tags", {"creationSource", "orchestrator", "poolName", "resourceNameSuffix", "created-by", "displayName", "ms-resource-usage", "ContainerTag", "service", "hidden-related:/subscriptions/02fd7403-de8f-4ea6-8ab4-6f00f0b4a808/resourcegroups/WebappforcontainersCedwards/providers/Microsoft.Web/serverfarms/ServicePlanb8fd2fe5-b45f", "hidden-related:/subscriptions/02fd7403-de8f-4ea6-8ab4-6f00f0b4a808/resourceGroups/WebAppRG/providers/Microsoft.Web/serverfarms/cedwardWebApp1"}, {"creationSource", "orchestrator", "poolName", "resourceNameSuffix", "created-by", "displayName", "ms-resource-usage", "ContainerTag", "service", "hidden-related:/subscriptions/02fd7403-de8f-4ea6-8ab4-6f00f0b4a808/resourcegroup", "hidden-related:/subscriptions/02fd7403-de8f-4ea6-8ab4-6f00f0b4a808/resourceGro.1"}),
    #"Expanded sku" = Table.ExpandRecordColumn(#"Expanded tags", "sku", {"name", "tier", "capacity", "size", "family"}, {"name", "tier", "capacity", "size", "family"}),
    #"Expanded plan" = Table.ExpandRecordColumn(#"Expanded sku", "plan", {"name", "promotionCode", "product", "publisher"}, {"name.1", "promotionCode", "product", "publisher"}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Expanded plan", "Resource Id", "Resource Id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "Resource Id - Copy", Splitter.SplitTextByDelimiter("/providers", QuoteStyle.Csv), {"Resource Id - Copy.1", "Resource Id - Copy.2"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Resource Id - Copy.1", type text}, {"Resource Id - Copy.2", type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type",{"Resource Id - Copy.2"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"Resource Id - Copy.1", "Resource Group Id"}})
in
    #"Renamed Columns1"in
    ListResources

// ListVirtualNetworks
let ListVirtualNetworks = (subscriptionId as text) =>
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.Network/virtualNetworks?api-version=2017-09-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"name", "id", "etag", "type", "location", "properties", "tags"}, {"name", "id", "etag", "type", "location", "properties", "tags"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"name", "VNET Name"}, {"id", "VNET Id"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns",{"etag"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Removed Columns", "properties", {"provisioningState", "resourceGuid", "addressSpace", "subnets", "virtualNetworkPeerings", "enableDdosProtection", "enableVmProtection", "dhcpOptions"}, {"provisioningState", "resourceGuid", "addressSpace", "subnets", "virtualNetworkPeerings", "enableDdosProtection", "enableVmProtection", "dhcpOptions"}),
    #"Expanded addressSpace" = Table.ExpandRecordColumn(#"Expanded properties", "addressSpace", {"addressPrefixes"}, {"addressPrefixes"}),
    #"Extracted Values" = Table.TransformColumns(#"Expanded addressSpace", {"addressPrefixes", each Text.Combine(List.Transform(_, Text.From)), type text}),
    #"Expanded subnets" = Table.ExpandListColumn(#"Extracted Values", "subnets"),
    #"Expanded subnets1" = Table.ExpandRecordColumn(#"Expanded subnets", "subnets", {"name", "id", "properties"}, {"name", "id", "properties"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded subnets1",{{"name", "Subnet Name"}, {"id", "Subnet Id"}}),
    #"Expanded properties1" = Table.ExpandRecordColumn(#"Renamed Columns1", "properties", {"provisioningState", "addressPrefix", "ipConfigurations", "serviceEndpoints", "routeTable"}, {"provisioningState.1", "addressPrefix", "ipConfigurations", "serviceEndpoints", "routeTable"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Expanded properties1",{"provisioningState.1"}),
    #"Expanded ipConfigurations" = Table.ExpandListColumn(#"Removed Columns1", "ipConfigurations"),
    #"Expanded ipConfigurations1" = Table.ExpandRecordColumn(#"Expanded ipConfigurations", "ipConfigurations", {"id"}, {"id"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Expanded ipConfigurations1",{{"id", "IP Configuration Id"}}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Renamed Columns2", "VNET Id", "VNET Id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "VNET Id - Copy", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"VNET Id - Copy.1", "VNET Id - Copy.2", "VNET Id - Copy.3", "VNET Id - Copy.4", "VNET Id - Copy.5", "VNET Id - Copy.6", "VNET Id - Copy.7", "VNET Id - Copy.8", "VNET Id - Copy.9"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"VNET Id - Copy.1", type text}, {"VNET Id - Copy.2", type text}, {"VNET Id - Copy.3", type text}, {"VNET Id - Copy.4", type text}, {"VNET Id - Copy.5", type text}, {"VNET Id - Copy.6", type text}, {"VNET Id - Copy.7", type text}, {"VNET Id - Copy.8", type text}, {"VNET Id - Copy.9", type text}}),
    #"Renamed Columns3" = Table.RenameColumns(#"Changed Type",{{"VNET Id - Copy.3", "Subscription Id"}}),
    #"Removed Columns2" = Table.RemoveColumns(#"Renamed Columns3",{"VNET Id - Copy.1", "VNET Id - Copy.2"}),
    #"Renamed Columns4" = Table.RenameColumns(#"Removed Columns2",{{"VNET Id - Copy.5", "Resource Group"}}),
    #"Removed Columns3" = Table.RemoveColumns(#"Renamed Columns4",{"VNET Id - Copy.4", "VNET Id - Copy.6", "VNET Id - Copy.7", "VNET Id - Copy.8", "VNET Id - Copy.9"}),
    #"Expanded virtualNetworkPeerings" = Table.ExpandListColumn(#"Removed Columns3", "virtualNetworkPeerings"),
    #"Expanded virtualNetworkPeerings1" = Table.ExpandRecordColumn(#"Expanded virtualNetworkPeerings", "virtualNetworkPeerings", {"name", "id", "etag", "properties"}, {"name", "id", "etag", "properties"}),
    #"Renamed Columns5" = Table.RenameColumns(#"Expanded virtualNetworkPeerings1",{{"id", "VNET Peering Id"}, {"name", "VNET Peering Name"}}),
    #"Removed Columns4" = Table.RemoveColumns(#"Renamed Columns5",{"etag"}),
    #"Expanded properties2" = Table.ExpandRecordColumn(#"Removed Columns4", "properties", {"provisioningState", "peeringState", "remoteVirtualNetwork", "allowVirtualNetworkAccess", "allowForwardedTraffic", "allowGatewayTransit", "useRemoteGateways", "remoteAddressSpace"}, {"provisioningState.1", "peeringState", "remoteVirtualNetwork", "allowVirtualNetworkAccess", "allowForwardedTraffic", "allowGatewayTransit", "useRemoteGateways", "remoteAddressSpace"}),
    #"Removed Columns5" = Table.RemoveColumns(#"Expanded properties2",{"provisioningState.1"}),
    #"Renamed Columns6" = Table.RenameColumns(#"Removed Columns5",{{"peeringState", "VNET peeringState"}}),
    #"Expanded remoteVirtualNetwork" = Table.ExpandRecordColumn(#"Renamed Columns6", "remoteVirtualNetwork", {"id"}, {"id"}),
    #"Renamed Columns7" = Table.RenameColumns(#"Expanded remoteVirtualNetwork",{{"id", "Remote VNET Id"}}),
    #"Expanded remoteAddressSpace" = Table.ExpandRecordColumn(#"Renamed Columns7", "remoteAddressSpace", {"addressPrefixes"}, {"addressPrefixes.1"}),
    #"Extracted Values1" = Table.TransformColumns(#"Expanded remoteAddressSpace", {"addressPrefixes.1", each Text.Combine(List.Transform(_, Text.From)), type text}),
    #"Replaced Errors" = Table.ReplaceErrorValues(#"Extracted Values1", {{"addressPrefixes.1", "Null"}}),
    #"Removed Columns6" = Table.RemoveColumns(#"Replaced Errors",{"tags"}),
    #"Expanded dhcpOptions" = Table.ExpandRecordColumn(#"Removed Columns6", "dhcpOptions", {"dnsServers"}, {"dnsServers"}),
    #"Extracted Values2" = Table.TransformColumns(#"Expanded dhcpOptions", {"dnsServers", each Text.Combine(List.Transform(_, Text.From)), type text}),
    #"Replaced Errors1" = Table.ReplaceErrorValues(#"Extracted Values2", {{"dnsServers", "Null"}}),
    #"Removed Columns7" = Table.RemoveColumns(#"Replaced Errors1",{"type"}),
    #"Renamed Columns8" = Table.RenameColumns(#"Removed Columns7",{{"addressPrefixes", "VNET addressPrefixes"}, {"addressPrefix", "Subnet addressPrefix"}}),
    #"Expanded routeTable" = Table.ExpandRecordColumn(#"Renamed Columns8", "routeTable", {"id"}, {"id"}),
    #"Renamed Columns9" = Table.RenameColumns(#"Expanded routeTable",{{"id", "Route Table id"}, {"addressPrefixes.1", "Remote VNET addressPrefixes"}})
in
    #"Renamed Columns9"
in
    ListVirtualNetworks

// ListAllNICs
let ListAllNICs = (subscriptionId as text) =>
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.Network/networkInterfaces?api-version=2017-10-01")),
    value = Source[value],
     #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"name", "id", "etag", "location", "properties", "type"}, {"name", "id", "etag", "location", "properties", "type"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded Column1",{"etag"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Removed Columns", "properties", {"provisioningState", "resourceGuid", "ipConfigurations", "dnsSettings", "macAddress", "enableAcceleratedNetworking", "enableIPForwarding", "networkSecurityGroup", "primary", "virtualMachine"}, {"provisioningState", "resourceGuid", "ipConfigurations", "dnsSettings", "macAddress", "enableAcceleratedNetworking", "enableIPForwarding", "networkSecurityGroup", "primary", "virtualMachine"}),
    #"Expanded dnsSettings" = Table.ExpandRecordColumn(#"Expanded properties", "dnsSettings", {"dnsServers", "appliedDnsServers"}, {"dnsServers", "appliedDnsServers"}),
    #"Extracted Values" = Table.TransformColumns(#"Expanded dnsSettings", {"dnsServers", each Text.Combine(List.Transform(_, Text.From)), type text}),
    #"Extracted Values1" = Table.TransformColumns(#"Extracted Values", {"appliedDnsServers", each Text.Combine(List.Transform(_, Text.From)), type text}),
    #"Expanded networkSecurityGroup" = Table.ExpandRecordColumn(#"Extracted Values1", "networkSecurityGroup", {"id"}, {"id.1"}),
    #"Expanded virtualMachine" = Table.ExpandRecordColumn(#"Expanded networkSecurityGroup", "virtualMachine", {"id"}, {"id.2"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Expanded virtualMachine",{"ipConfigurations"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns1",{{"id.1", "NSG Id"}, {"id.2", "Virtual Machine Id"}, {"id", "NIC Id"}})
in
    #"Renamed Columns"
in
    ListAllNICs

// ListAllNICsDetails
let ListAllNICsDetails = (subscriptionId as text) =>
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.Network/networkInterfaces?api-version=2017-10-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"name", "id", "etag", "location", "properties", "type"}, {"name", "id", "etag", "location", "properties", "type"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded Column1",{"etag"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Removed Columns", "properties", {"provisioningState", "resourceGuid", "ipConfigurations", "dnsSettings", "macAddress", "enableAcceleratedNetworking", "enableIPForwarding", "networkSecurityGroup", "primary", "virtualMachine"}, {"provisioningState", "resourceGuid", "ipConfigurations", "dnsSettings", "macAddress", "enableAcceleratedNetworking", "enableIPForwarding", "networkSecurityGroup", "primary", "virtualMachine"}),
    #"Expanded dnsSettings" = Table.ExpandRecordColumn(#"Expanded properties", "dnsSettings", {"dnsServers", "appliedDnsServers"}, {"dnsServers", "appliedDnsServers"}),
    #"Extracted Values" = Table.TransformColumns(#"Expanded dnsSettings", {"dnsServers", each Text.Combine(List.Transform(_, Text.From)), type text}),
    #"Extracted Values1" = Table.TransformColumns(#"Extracted Values", {"appliedDnsServers", each Text.Combine(List.Transform(_, Text.From)), type text}),
    #"Expanded networkSecurityGroup" = Table.ExpandRecordColumn(#"Extracted Values1", "networkSecurityGroup", {"id"}, {"id.1"}),
    #"Expanded virtualMachine" = Table.ExpandRecordColumn(#"Expanded networkSecurityGroup", "virtualMachine", {"id"}, {"id.2"}),
    #"Expanded ipConfigurations" = Table.ExpandListColumn(#"Expanded virtualMachine", "ipConfigurations"),
    #"Expanded ipConfigurations1" = Table.ExpandRecordColumn(#"Expanded ipConfigurations", "ipConfigurations", {"name", "id", "etag", "properties"}, {"name.1", "id.3", "etag", "properties"}),
    #"Expanded properties1" = Table.ExpandRecordColumn(#"Expanded ipConfigurations1", "properties", {"provisioningState", "privateIPAddress", "privateIPAllocationMethod", "publicIPAddress", "subnet", "primary", "privateIPAddressVersion", "isInUseWithService", "loadBalancerBackendAddressPools"}, {"provisioningState.1", "privateIPAddress", "privateIPAllocationMethod", "publicIPAddress", "subnet", "primary.1", "privateIPAddressVersion", "isInUseWithService", "loadBalancerBackendAddressPools"}),
    #"Expanded publicIPAddress" = Table.ExpandRecordColumn(#"Expanded properties1", "publicIPAddress", {"id"}, {"id.4"}),
    #"Expanded subnet" = Table.ExpandRecordColumn(#"Expanded publicIPAddress", "subnet", {"id"}, {"id.5"}),
    #"Expanded loadBalancerBackendAddressPools" = Table.ExpandListColumn(#"Expanded subnet", "loadBalancerBackendAddressPools"),
    #"Expanded loadBalancerBackendAddressPools1" = Table.ExpandRecordColumn(#"Expanded loadBalancerBackendAddressPools", "loadBalancerBackendAddressPools", {"id"}, {"id.6"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded loadBalancerBackendAddressPools1",{{"id.4", "Public IP Address ID"}, {"id.5", "Subnet Id"}, {"id.1", "NSG Id"}, {"id.2", "Virtual Machine Id"}, {"id", "NIC Id"}, {"name", "NIC Name"}})
in
    #"Renamed Columns"
in
    ListAllNICsDetails

// Public IPs
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId", "displayName"}, {"subscriptionId", "displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"displayName", "Subscription Name"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns", "ListPublicIPs", each ListPublicIPs([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListPublicIPs"}),
    #"Expanded ListPublicIPs" = Table.ExpandTableColumn(#"Removed Errors", "ListPublicIPs", {"Public IP Name", "Public IP Resource Id", "location", "provisioningState", "resourceGuid", "ipAddress", "publicIPAddressVersion", "publicIPAllocationMethod", "idleTimeoutInMinutes", "domainNameLabel", "fqdn", "ipTags", "IP Configuration Id", "type", "sku", "Resource Group Id"}, {"Public IP Name", "Public IP Resource Id", "location", "provisioningState", "resourceGuid", "ipAddress", "publicIPAddressVersion", "publicIPAllocationMethod", "idleTimeoutInMinutes", "domainNameLabel", "fqdn", "ipTags", "IP Configuration Id", "type", "sku", "Resource Group Id"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded ListPublicIPs",{"subscriptionId", "Subscription Name"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"ipAddress", "Public IP Address"}})
in
    #"Renamed Columns1"

// ListPublicIPs
let ListPublicIPs = (subscriptionId as text) =>
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.Network/publicIPAddresses?api-version=2017-10-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"name", "id", "location", "properties", "type", "sku", "tags"}, {"name", "id", "location", "properties", "type", "sku", "tags"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"name", "Public IP Name"}, {"id", "Public IP Resource Id"}}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Renamed Columns", "properties", {"provisioningState", "resourceGuid", "ipAddress", "publicIPAddressVersion", "publicIPAllocationMethod", "idleTimeoutInMinutes", "dnsSettings", "ipTags", "ipConfiguration"}, {"provisioningState", "resourceGuid", "ipAddress", "publicIPAddressVersion", "publicIPAllocationMethod", "idleTimeoutInMinutes", "dnsSettings", "ipTags", "ipConfiguration"}),
    #"Expanded dnsSettings" = Table.ExpandRecordColumn(#"Expanded properties", "dnsSettings", {"domainNameLabel", "fqdn"}, {"domainNameLabel", "fqdn"}),
    #"Expanded ipTags" = Table.ExpandListColumn(#"Expanded dnsSettings", "ipTags"),
    #"Expanded ipConfiguration" = Table.ExpandRecordColumn(#"Expanded ipTags", "ipConfiguration", {"id"}, {"id"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded ipConfiguration",{{"id", "IP Configuration Id"}}),
    #"Expanded sku" = Table.ExpandRecordColumn(#"Renamed Columns1", "sku", {"name"}, {"name"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Expanded sku",{{"name", "sku"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns2",{"tags"}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Removed Columns", "Public IP Resource Id", "Public IP Resource Id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "Public IP Resource Id - Copy", Splitter.SplitTextByDelimiter("/providers", QuoteStyle.Csv), {"Public IP Resource Id - Copy.1", "Public IP Resource Id - Copy.2"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Public IP Resource Id - Copy.1", type text}, {"Public IP Resource Id - Copy.2", type text}}),
    #"Renamed Columns3" = Table.RenameColumns(#"Changed Type",{{"Public IP Resource Id - Copy.1", "Resource Group Id"}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Renamed Columns3",{"Public IP Resource Id - Copy.2"})
in
    #"Removed Columns1"


in
    ListPublicIPs

// Containers VMs
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId", "displayName"}, {"subscriptionId", "displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"displayName", "Subscription Name"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns", "ListVirtualMachines", each ListVirtualMachines([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListVirtualMachines"}),
    #"Expanded ListVirtualMachines" = Table.ExpandTableColumn(#"Removed Errors", "ListVirtualMachines", {"Availability Set Id", "vmSize", "publisher", "offer", "sku", "version", "osType", "name", "createOption", "vhd uri", "caching", "diskSizeGB", "storageAccountType", "Managed Disk Id", "lun", "name.1", "createOption.1", "Data vhd uri", "caching.1", "diskSizeGB.1", "computerName", "adminUsername", "provisionVMAgent", "enableAutomaticUpdates", "Network Inteface Id", "provisioningState", "enabled", "storageUri", "Extensions Resource Id", "type", "location", "creationSource", "orchestrator", "poolName", "resourceNameSuffix", "VM Resource Id", "VM Name"}, {"Availability Set Id", "vmSize", "publisher", "offer", "sku", "version", "osType", "name", "createOption", "vhd uri", "caching", "diskSizeGB", "storageAccountType", "Managed Disk Id", "lun", "name.1", "createOption.1", "Data vhd uri", "caching.1", "diskSizeGB.1", "computerName", "adminUsername", "provisionVMAgent", "enableAutomaticUpdates", "Network Inteface Id", "provisioningState", "enabled", "storageUri", "Extensions Resource Id", "type", "location", "creationSource", "orchestrator", "poolName", "resourceNameSuffix", "VM Resource Id", "VM Name"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded ListVirtualMachines",{"subscriptionId", "Subscription Name"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Columns", {"VM Resource Id"}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Removed Duplicates", "VM Resource Id", "VM Resource Id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "VM Resource Id - Copy", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"VM Resource Id - Copy.1", "VM Resource Id - Copy.2", "VM Resource Id - Copy.3", "VM Resource Id - Copy.4", "VM Resource Id - Copy.5", "VM Resource Id - Copy.6", "VM Resource Id - Copy.7", "VM Resource Id - Copy.8", "VM Resource Id - Copy.9"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"VM Resource Id - Copy.1", type text}, {"VM Resource Id - Copy.2", type text}, {"VM Resource Id - Copy.3", type text}, {"VM Resource Id - Copy.4", type text}, {"VM Resource Id - Copy.5", type text}, {"VM Resource Id - Copy.6", type text}, {"VM Resource Id - Copy.7", type text}, {"VM Resource Id - Copy.8", type text}, {"VM Resource Id - Copy.9", type text}}),
    #"Renamed Columns1" = Table.RenameColumns(#"Changed Type",{{"VM Resource Id - Copy.5", "Resource Group Name"}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Renamed Columns1",{"VM Resource Id - Copy.1", "VM Resource Id - Copy.2", "VM Resource Id - Copy.3", "VM Resource Id - Copy.4", "VM Resource Id - Copy.6", "VM Resource Id - Copy.7", "VM Resource Id - Copy.8", "VM Resource Id - Copy.9"}),
    #"Added Conditional Column" = Table.AddColumn(#"Removed Columns1", "Is Using Managed Disks", each if [Managed Disk Id] = null then false else true),
    #"Duplicated Column1" = Table.DuplicateColumn(#"Added Conditional Column", "Extensions Resource Id", "Extensions Resource Id - Copy"),
    #"Split Column by Delimiter1" = Table.SplitColumn(#"Duplicated Column1", "Extensions Resource Id - Copy", Splitter.SplitTextByDelimiter("/extensions/", QuoteStyle.Csv), {"Extensions Resource Id - Copy.1", "Extensions Resource Id - Copy.2"}),
    #"Removed Columns2" = Table.RemoveColumns(#"Split Column by Delimiter1",{"Extensions Resource Id - Copy.1"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Removed Columns2",{{"Extensions Resource Id - Copy.2", "VM Extension"}}),
    #"Added Conditional Column1" = Table.AddColumn(#"Renamed Columns2", "IsRunningContainers", each if [orchestrator] = null then "VM without Containers" else "VM with Containers"),
    #"Replaced Value" = Table.ReplaceValue(#"Added Conditional Column1",null,"Custom",Replacer.ReplaceValue,{"offer"}),
    #"Added Conditional Column2" = Table.AddColumn(#"Replaced Value", "OS Type", each if [osType] = "Windows" then "https://azure.github.io/ccodashboard/assets/pictures/001_Compute_WindowsLogo.svg" else if [osType] = "Linux" then "https://azure.github.io/ccodashboard/assets/pictures/002_Compute_LinuxLogo.svg" else null),
    #"Changed Type1" = Table.TransformColumnTypes(#"Added Conditional Column2",{{"OS Type", type text}}),
    #"Filtered Rows" = Table.SelectRows(#"Changed Type1", each ([IsRunningContainers] = "VM with Containers")),
    #"Added Conditional Column3" = Table.AddColumn(#"Filtered Rows", "Custom", each if [IsRunningContainers] <> "VM with Containers" then "" else "https://azure.github.io/ccodashboard/assets/pictures/002_AKS_ContainersHost.svg"),
    #"Renamed Columns3" = Table.RenameColumns(#"Added Conditional Column3",{{"Custom", "Node Image"}})
in
    #"Renamed Columns3"

// Containers NICs
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId", "displayName"}, {"subscriptionId", "displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"displayName", "Subscription Name"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns", "ListAllNICsDetails", each ListAllNICsDetails([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListAllNICsDetails"}),
    #"Expanded ListAllNICsDetails" = Table.ExpandTableColumn(#"Removed Errors", "ListAllNICsDetails", {"NIC Name", "NIC Id", "location", "provisioningState", "resourceGuid", "name.1", "id.3", "etag", "provisioningState.1", "privateIPAddress", "privateIPAllocationMethod", "Public IP Address ID", "Subnet Id", "primary.1", "privateIPAddressVersion", "isInUseWithService", "id.6", "dnsServers", "appliedDnsServers", "macAddress", "enableAcceleratedNetworking", "enableIPForwarding", "NSG Id", "primary", "Virtual Machine Id", "type"}, {"NIC Name", "NIC Id", "location", "provisioningState", "resourceGuid", "name.1", "id.3", "etag", "provisioningState.1", "privateIPAddress", "privateIPAllocationMethod", "Public IP Address ID", "Subnet Id", "primary.1", "privateIPAddressVersion", "isInUseWithService", "id.6", "dnsServers", "appliedDnsServers", "macAddress", "enableAcceleratedNetworking", "enableIPForwarding", "NSG Id", "primary", "Virtual Machine Id", "type"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded ListAllNICsDetails",{"subscriptionId", "Subscription Name"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"id.3", "IP Configuration Id"}, {"primary.1", "isPrimary"}, {"id.6", "BackendAddressPool Id"}}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Renamed Columns1", "Subnet Id", "Subnet Id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "Subnet Id - Copy", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"Subnet Id - Copy.1", "Subnet Id - Copy.2", "Subnet Id - Copy.3", "Subnet Id - Copy.4", "Subnet Id - Copy.5", "Subnet Id - Copy.6", "Subnet Id - Copy.7", "Subnet Id - Copy.8", "Subnet Id - Copy.9", "Subnet Id - Copy.10", "Subnet Id - Copy.11"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Subnet Id - Copy.1", type text}, {"Subnet Id - Copy.2", type text}, {"Subnet Id - Copy.3", type text}, {"Subnet Id - Copy.4", type text}, {"Subnet Id - Copy.5", type text}, {"Subnet Id - Copy.6", type text}, {"Subnet Id - Copy.7", type text}, {"Subnet Id - Copy.8", type text}, {"Subnet Id - Copy.9", type text}, {"Subnet Id - Copy.10", type text}, {"Subnet Id - Copy.11", type text}}),
    #"Renamed Columns2" = Table.RenameColumns(#"Changed Type",{{"Subnet Id - Copy.9", "VNET Name"}, {"Subnet Id - Copy.11", "Subnet Name"}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Renamed Columns2",{"Subnet Id - Copy.10", "Subnet Id - Copy.4", "Subnet Id - Copy.5", "Subnet Id - Copy.6", "Subnet Id - Copy.7", "Subnet Id - Copy.8", "Subnet Id - Copy.1", "Subnet Id - Copy.2", "Subnet Id - Copy.3", "name.1"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Columns1", {"NIC Id"})
in
    #"Removed Duplicates"

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

// ListServicePrincipals
let ListRBACUsers = (principalId as text) =>
let
    url = "https://graph.windows.net/myorganization/servicePrincipals?api-version=1.6&$filter=objectId eq '"&principalId&"'",
    iterations = 10,
    FuncGetOnePage = (url) as record =>
    let 
       Source = Json.Document(Web.Contents(url)),
       data = try Source[value] otherwise null,
       next = try Source[nextLink] otherwise null,
       res = [Data=data, Next=next]
    in
        res,
        GeneratedListOfPages = List.Generate(()=>[i=0, res = FuncGetOnePage(url)],
        each [i]<iterations and [res][Data]<>null,
        each [i=[i]+1, res = FuncGetOnePage([res][Next])],
        each [res][Data]),

    #"Converted to Table" = Table.FromList(GeneratedListOfPages, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandListColumn(#"Converted to Table", "Column1")
   
 in
    #"Expanded Column1"
in
    ListRBACUsers

// Service Principals
// RBAC Role Assignments
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId","displayName"}, {"Column1.subscriptionId","Column1.displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"Column1.subscriptionId", "SubscriptionId"}}),
    #"List RBACRoleAssignments" = Table.AddColumn(#"Renamed Columns", "ListRBACRoleAssignments", each ListRBACRoleAssignments([SubscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"List RBACRoleAssignments", {"ListRBACRoleAssignments"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Errors",{{"Column1.displayName", "Subscription Name"}}),
    #"Expanded ListRBACRoleAssignments" = Table.ExpandTableColumn(#"Renamed Columns1", "ListRBACRoleAssignments", {"roleDefinitionId", "principalId", "scope", "createdOn", "updatedOn", "createdBy", "updatedBy", "id", "type", "name"}, {"roleDefinitionId", "principalId", "scope", "createdOn", "updatedOn", "createdBy", "updatedBy", "id", "type", "name"}),
    #"Invoked Custom Function" = Table.AddColumn(#"Expanded ListRBACRoleAssignments", "Users", each ListServicePrincipals([principalId])),
    #"Removed Errors1" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"Users"}),
    #"Expanded Users" = Table.ExpandTableColumn(#"Removed Errors1", "Users", {"Column1"}, {"Column1"}),
    #"Expanded Column2" = Table.ExpandRecordColumn(#"Expanded Users", "Column1", {"odata.type", "objectType", "objectId", "deletionTimestamp", "accountEnabled", "addIns", "alternativeNames", "appDisplayName", "appId", "appOwnerTenantId", "appRoleAssignmentRequired", "appRoles", "displayName", "errorUrl", "homepage", "keyCredentials", "logoutUrl", "oauth2Permissions", "passwordCredentials", "preferredTokenSigningKeyThumbprint", "publisherName", "replyUrls", "samlMetadataUrl", "servicePrincipalNames", "servicePrincipalType", "signInAudience", "tags", "tokenEncryptionKeyId"}, {"odata.type", "objectType", "objectId", "deletionTimestamp", "accountEnabled", "addIns", "alternativeNames", "appDisplayName", "appId", "appOwnerTenantId", "appRoleAssignmentRequired", "appRoles", "displayName", "errorUrl", "homepage", "keyCredentials", "logoutUrl", "oauth2Permissions", "passwordCredentials", "preferredTokenSigningKeyThumbprint", "publisherName", "replyUrls", "samlMetadataUrl", "servicePrincipalNames", "servicePrincipalType", "signInAudience", "tags", "tokenEncryptionKeyId"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded Column2",{"replyUrls", "servicePrincipalNames", "tags", "passwordCredentials"}),
    #"Expanded oauth2Permissions" = Table.ExpandListColumn(#"Removed Columns", "oauth2Permissions"),
    #"Expanded oauth2Permissions1" = Table.ExpandRecordColumn(#"Expanded oauth2Permissions", "oauth2Permissions", {"adminConsentDescription", "adminConsentDisplayName", "id", "isEnabled", "type", "userConsentDescription", "userConsentDisplayName", "value"}, {"adminConsentDescription", "adminConsentDisplayName", "id.1", "isEnabled", "type.1", "userConsentDescription", "userConsentDisplayName", "value"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Expanded oauth2Permissions1",{"addIns", "alternativeNames", "appRoles", "errorUrl"}),
    #"Expanded keyCredentials" = Table.ExpandListColumn(#"Removed Columns1", "keyCredentials"),
    #"Removed Columns2" = Table.RemoveColumns(#"Expanded keyCredentials",{"keyCredentials", "logoutUrl"}),
    #"Filtered Rows" = Table.SelectRows(#"Removed Columns2", each not Text.StartsWith([displayName], "AzureContainerService") and not Text.StartsWith([displayName], "azure-cli-")),
    #"Filtered Rows1" = Table.SelectRows(#"Filtered Rows", each true),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Filtered Rows1", "scope", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"scope.1", "scope.2", "scope.3", "scope.4", "scope.5", "scope.6", "scope.7", "scope.8", "scope.9", "scope.10", "scope.11"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Split Column by Delimiter",{{"scope.5", "Resource Group"}, {"scope.7", "Resource Provider"}, {"scope.8", "Resource Type"}, {"scope.9", "Resource Name"}}),
    #"Removed Columns3" = Table.RemoveColumns(#"Renamed Columns2",{"scope.1", "scope.2", "scope.3", "scope.4", "scope.6"}),
    #"Replaced Value" = Table.ReplaceValue(#"Removed Columns3",null,"*",Replacer.ReplaceValue,{"Resource Group"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value",null,"*",Replacer.ReplaceValue,{"Resource Provider"}),
    #"Added Conditional Column" = Table.AddColumn(#"Replaced Value1", "Custom", each if [Resource Group] = "*" then "Subscription" else if [Resource Provider] = "*" then "Resource Group" else if [Resource Type] <> null then [Resource Type] else null),
    #"Renamed Columns3" = Table.RenameColumns(#"Added Conditional Column",{{"scope.11", "Integration Runtime Name"}, {"scope.10", "DataFactory Resource Type"}}),
    #"Replaced Value2" = Table.ReplaceValue(#"Renamed Columns3",null,"resourcegroup",Replacer.ReplaceValue,{"Resource Type"}),
    #"Removed Duplicates" = Table.Distinct(#"Replaced Value2", {"appId"})

in
    #"Removed Duplicates"

// ListRBACRoleAssignments
let ListRBACRoleAssignments = (subscriptionId as text) =>
let
    url = "https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.Authorization/roleAssignments?api-version=2015-07-01",
    iterations = 10,
    FuncGetOnePage = (url) as record =>
    let 
       Source = Json.Document(Web.Contents(url)),
       data = try Source[value] otherwise null,
       next = try Source[nextLink] otherwise null,
       res = [Data=data, Next=next]
    in
        res,
        GeneratedListOfPages = List.Generate(()=>[i=0, res = FuncGetOnePage(url)],
        each [i]<iterations and [res][Data]<>null,
        each [i=[i]+1, res = FuncGetOnePage([res][Next])],
        each [res][Data]),

    #"Converted to Table" = Table.FromList(GeneratedListOfPages, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandListColumn(#"Converted to Table", "Column1"),
    #"Expanded Column2" = Table.ExpandRecordColumn(#"Expanded Column1", "Column1", {"properties", "id", "type", "name"}, {"properties", "id", "type", "name"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column2", "properties", {"roleDefinitionId", "principalId", "scope", "createdOn", "updatedOn", "createdBy", "updatedBy"}, {"roleDefinitionId", "principalId", "scope", "createdOn", "updatedOn", "createdBy", "updatedBy"})
in
    #"Expanded properties"

in
    ListRBACRoleAssignments

// RBAC Role Definitions
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId","displayName"}, {"Column1.subscriptionId","Column1.displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"Column1.subscriptionId", "SubscriptionId"}}),
    #"List RBACRoleDefinitions" = Table.AddColumn(#"Renamed Columns", "ListRBACRoleDefinitions", each ListRBACRoleDefinitions([SubscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"List RBACRoleDefinitions", {"ListRBACRoleDefinitions"}),
    #"Expanded ListRBACRoleDefinitions" = Table.ExpandTableColumn(#"Removed Errors", "ListRBACRoleDefinitions", {"roleName", "type.1", "description", "assignableScopes", "actions", "notActions", "createdOn", "updatedOn", "createdBy", "updatedBy", "id", "type", "name"}, {"roleName", "type.1", "description", "assignableScopes", "actions", "notActions", "createdOn", "updatedOn", "createdBy", "updatedBy", "id", "type", "name"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded ListRBACRoleDefinitions",{{"type.1", "roleType"}, {"Column1.displayName", "Subscription Name"}, {"id", "roleDefinitionId"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns1",{"type"})
in
    #"Removed Columns"

// ListRBACRoleDefinitions
let ListRBACRoleDefinitions = (subscriptionId as text) =>
let
    url = "https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.Authorization/roleDefinitions?api-version=2015-07-01",
    iterations = 10,
    FuncGetOnePage = (url) as record =>
    let 
       Source = Json.Document(Web.Contents(url)),
       data = try Source[value] otherwise null,
       next = try Source[nextLink] otherwise null,
       res = [Data=data, Next=next]
    in
        res,
        GeneratedListOfPages = List.Generate(()=>[i=0, res = FuncGetOnePage(url)],
        each [i]<iterations and [res][Data]<>null,
        each [i=[i]+1, res = FuncGetOnePage([res][Next])],
        each [res][Data]),

    #"Converted to Table" = Table.FromList(GeneratedListOfPages, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandListColumn(#"Converted to Table", "Column1"),
    #"Expanded Column2" = Table.ExpandRecordColumn(#"Expanded Column1", "Column1", {"properties", "id", "type", "name"}, {"properties", "id", "type", "name"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column2", "properties", {"roleName", "type", "description", "assignableScopes", "permissions", "createdOn", "updatedOn", "createdBy", "updatedBy"}, {"roleName", "type.1", "description", "assignableScopes", "permissions", "createdOn", "updatedOn", "createdBy", "updatedBy"}),
    #"Extracted Values" = Table.TransformColumns(#"Expanded properties", {"assignableScopes", each Text.Combine(List.Transform(_, Text.From)), type text}),
    #"Expanded permissions" = Table.ExpandListColumn(#"Extracted Values", "permissions"),
    #"Expanded permissions1" = Table.ExpandRecordColumn(#"Expanded permissions", "permissions", {"actions", "notActions"}, {"actions", "notActions"}),
    #"Extracted Values1" = Table.TransformColumns(#"Expanded permissions1", {"actions", each Text.Combine(List.Transform(_, Text.From)), type text}),
    #"Extracted Values2" = Table.TransformColumns(#"Extracted Values1", {"notActions", each Text.Combine(List.Transform(_, Text.From)), type text})
in
    #"Extracted Values2"
in
    ListRBACRoleDefinitions

// RBAC Role Users
// RBAC Role Assignments
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId","displayName"}, {"Column1.subscriptionId","Column1.displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"Column1.subscriptionId", "SubscriptionId"}}),
    #"List RBACRoleAssignments" = Table.AddColumn(#"Renamed Columns", "ListRBACRoleAssignments", each ListRBACRoleAssignments([SubscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"List RBACRoleAssignments", {"ListRBACRoleAssignments"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Errors",{{"Column1.displayName", "Subscription Name"}}),
    #"Expanded ListRBACRoleAssignments" = Table.ExpandTableColumn(#"Renamed Columns1", "ListRBACRoleAssignments", {"roleDefinitionId", "principalId", "scope", "createdOn", "updatedOn", "createdBy", "updatedBy", "id", "type", "name"}, {"roleDefinitionId", "principalId", "scope", "createdOn", "updatedOn", "createdBy", "updatedBy", "id", "type", "name"}),
    #"Split Column by Delimiter1" = Table.SplitColumn(#"Expanded ListRBACRoleAssignments", "scope", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"scope.1", "scope.2", "scope.3", "scope.4", "scope.5", "scope.6", "scope.7", "scope.8", "scope.9", "scope.10", "scope.11"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Split Column by Delimiter1",{{"scope.5", "Resource Group"}, {"scope.7", "Resource Provider"}, {"scope.8", "Resource Type"}, {"scope.9", "Resource Name"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns2",{"scope.1", "scope.2", "scope.3", "scope.4", "scope.6"}),
    #"Replaced Value" = Table.ReplaceValue(#"Removed Columns",null,"*",Replacer.ReplaceValue,{"Resource Group"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value",null,"*",Replacer.ReplaceValue,{"Resource Provider"}),
    #"Added Conditional Column" = Table.AddColumn(#"Replaced Value1", "Custom", each if [Resource Group] = "*" then "Subscription" else if [Resource Provider] = "*" then "Resource Group" else if [Resource Type] <> null then [Resource Type] else null),
    #"Renamed Columns3" = Table.RenameColumns(#"Added Conditional Column",{{"Resource Type", "Rtype"}, {"Custom", "Resource Type"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns3", "Users", each ListRBACUsers([principalId])),
    #"Removed Errors1" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"Users"}),
    #"Expanded Users" = Table.ExpandTableColumn(#"Removed Errors1", "Users", {"odata.type", "objectType", "objectId", "deletionTimestamp", "accountEnabled", "ageGroup", "city", "companyName", "consentProvidedForMinor", "country", "creationType", "department", "dirSyncEnabled", "displayName", "employeeId", "facsimileTelephoneNumber", "givenName", "immutableId", "isCompromised", "jobTitle", "lastDirSyncTime", "legalAgeGroupClassification", "mail", "mailNickname", "mobile", "onPremisesDistinguishedName", "onPremisesSecurityIdentifier", "passwordPolicies", "passwordProfile", "physicalDeliveryOfficeName", "postalCode", "preferredLanguage", "refreshTokensValidFromDateTime", "showInAddressList", "sipProxyAddress", "state", "streetAddress", "surname", "telephoneNumber", "thumbnailPhoto@odata.mediaContentType", "usageLocation", "userPrincipalName", "userType", "extension_18e31482d3fb4a8ea958aa96b662f508_SupervisorInd", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingName", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingID", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToPersonnelNbr", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToFullName", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToEmailName", "extension_18e31482d3fb4a8ea958aa96b662f508_CompanyCode", "extension_18e31482d3fb4a8ea958aa96b662f508_CostCenterCode", "extension_18e31482d3fb4a8ea958aa96b662f508_LocationAreaCode", "extension_18e31482d3fb4a8ea958aa96b662f508_PersonnelNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_PositionNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_ProfitCenterCode"}, {"odata.type", "objectType", "objectId", "deletionTimestamp", "accountEnabled", "ageGroup", "city", "companyName", "consentProvidedForMinor", "country", "creationType", "department", "dirSyncEnabled", "displayName", "employeeId", "facsimileTelephoneNumber", "givenName", "immutableId", "isCompromised", "jobTitle", "lastDirSyncTime", "legalAgeGroupClassification", "mail", "mailNickname", "mobile", "onPremisesDistinguishedName", "onPremisesSecurityIdentifier", "passwordPolicies", "passwordProfile", "physicalDeliveryOfficeName", "postalCode", "preferredLanguage", "refreshTokensValidFromDateTime", "showInAddressList", "sipProxyAddress", "state", "streetAddress", "surname", "telephoneNumber", "thumbnailPhoto@odata.mediaContentType", "usageLocation", "userPrincipalName", "userType", "extension_18e31482d3fb4a8ea958aa96b662f508_SupervisorInd", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingName", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingID", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToPersonnelNbr", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToFullName", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToEmailName", "extension_18e31482d3fb4a8ea958aa96b662f508_CompanyCode", "extension_18e31482d3fb4a8ea958aa96b662f508_CostCenterCode", "extension_18e31482d3fb4a8ea958aa96b662f508_LocationAreaCode", "extension_18e31482d3fb4a8ea958aa96b662f508_PersonnelNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_PositionNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_ProfitCenterCode"})
in
    #"Expanded Users"

// ListRBACUsers
let ListRBACUsers = (principalId as text) =>
let
    url = "https://graph.windows.net/"&TenantName&"/users?api-version=1.6&$filter=objectId eq '"&principalId&"'",
    iterations = 10,
    FuncGetOnePage = (url) as record =>
    let 
       Source = Json.Document(Web.Contents(url)),
       data = try Source[value] otherwise null,
       next = try Source[nextLink] otherwise null,
       res = [Data=data, Next=next]
    in
        res,
        GeneratedListOfPages = List.Generate(()=>[i=0, res = FuncGetOnePage(url)],
        each [i]<iterations and [res][Data]<>null,
        each [i=[i]+1, res = FuncGetOnePage([res][Next])],
        each [res][Data]),

    #"Converted to Table" = Table.FromList(GeneratedListOfPages, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandListColumn(#"Converted to Table", "Column1"),
    #"Expanded Column2" = Table.ExpandRecordColumn(#"Expanded Column1", "Column1", {"odata.type", "objectType", "objectId", "deletionTimestamp", "accountEnabled", "ageGroup", "assignedLicenses", "assignedPlans", "city", "companyName", "consentProvidedForMinor", "country", "creationType", "department", "dirSyncEnabled", "displayName", "employeeId", "facsimileTelephoneNumber", "givenName", "immutableId", "isCompromised", "jobTitle", "lastDirSyncTime", "legalAgeGroupClassification", "mail", "mailNickname", "mobile", "onPremisesDistinguishedName", "onPremisesSecurityIdentifier", "otherMails", "passwordPolicies", "passwordProfile", "physicalDeliveryOfficeName", "postalCode", "preferredLanguage", "provisionedPlans", "provisioningErrors", "proxyAddresses", "refreshTokensValidFromDateTime", "showInAddressList", "signInNames", "sipProxyAddress", "state", "streetAddress", "surname", "telephoneNumber", "thumbnailPhoto@odata.mediaContentType", "usageLocation", "userIdentities", "userPrincipalName", "userType", "extension_18e31482d3fb4a8ea958aa96b662f508_SupervisorInd", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingName", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingID", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToPersonnelNbr", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToFullName", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToEmailName", "extension_18e31482d3fb4a8ea958aa96b662f508_CompanyCode", "extension_18e31482d3fb4a8ea958aa96b662f508_CostCenterCode", "extension_18e31482d3fb4a8ea958aa96b662f508_LocationAreaCode", "extension_18e31482d3fb4a8ea958aa96b662f508_PersonnelNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_PositionNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_ProfitCenterCode"}, {"odata.type", "objectType", "objectId", "deletionTimestamp", "accountEnabled", "ageGroup", "assignedLicenses", "assignedPlans", "city", "companyName", "consentProvidedForMinor", "country", "creationType", "department", "dirSyncEnabled", "displayName", "employeeId", "facsimileTelephoneNumber", "givenName", "immutableId", "isCompromised", "jobTitle", "lastDirSyncTime", "legalAgeGroupClassification", "mail", "mailNickname", "mobile", "onPremisesDistinguishedName", "onPremisesSecurityIdentifier", "otherMails", "passwordPolicies", "passwordProfile", "physicalDeliveryOfficeName", "postalCode", "preferredLanguage", "provisionedPlans", "provisioningErrors", "proxyAddresses", "refreshTokensValidFromDateTime", "showInAddressList", "signInNames", "sipProxyAddress", "state", "streetAddress", "surname", "telephoneNumber", "thumbnailPhoto@odata.mediaContentType", "usageLocation", "userIdentities", "userPrincipalName", "userType", "extension_18e31482d3fb4a8ea958aa96b662f508_SupervisorInd", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingName", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingID", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToPersonnelNbr", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToFullName", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToEmailName", "extension_18e31482d3fb4a8ea958aa96b662f508_CompanyCode", "extension_18e31482d3fb4a8ea958aa96b662f508_CostCenterCode", "extension_18e31482d3fb4a8ea958aa96b662f508_LocationAreaCode", "extension_18e31482d3fb4a8ea958aa96b662f508_PersonnelNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_PositionNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_ProfitCenterCode"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded Column2",{"assignedLicenses", "assignedPlans", "otherMails", "provisionedPlans", "provisioningErrors", "proxyAddresses", "signInNames", "userIdentities"})
in
    #"Removed Columns"
in
    ListRBACUsers

// List Security tasks
let ListSecurityTasks = (subscriptionId as text)=>
let
    url = "https://management.azure.com/subscriptions/"&subscriptionId&"/providers/microsoft.Security/tasks?api-version=2015-06-01-preview",
    iterations = 10,
    FuncGetOnePage = (url) as record =>
    let 
       Source = Json.Document(Web.Contents(url)),
       data = try Source[value] otherwise null,
       next = try Source[nextLink] otherwise null,
       res = [Data=data, Next=next]
    in
        res,
        GeneratedListOfPages = List.Generate(()=>[i=0, res = FuncGetOnePage(url)],
        each [i]<iterations and [res][Data]<>null,
        each [i=[i]+1, res = FuncGetOnePage([res][Next])],
        each [res][Data]),

    #"Converted to Table" = Table.FromList(GeneratedListOfPages, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandListColumn(#"Converted to Table", "Column1"),
    #"Expanded Column2" = Table.ExpandRecordColumn(#"Expanded Column1", "Column1", {"id", "properties"}, {"id", "properties"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column2",{{"id", "Security Center Task Id"}}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Renamed Columns", "properties", {"state", "subState", "creationTimeUtc", "lastStateChangeTimeUtc", "securityTaskParameters"}, {"state", "subState", "creationTimeUtc", "lastStateChangeTimeUtc", "securityTaskParameters"}),
    #"Expanded securityTaskParameters" = Table.ExpandRecordColumn(#"Expanded properties", "securityTaskParameters", {"subscriptionId", "id", "title", "classification", "totalNumberOfImpactedMachines", "severity", "osType", "isMandatory", "workspaces", "name", "uniqueKey", "resourceId", "baselineRuleId", "baselineName", "baselineCceId", "osName", "ruleType", "totalNumberOfDefectedMachines", "resourceType", "category", "assessmentKey", "policyName", "policyDefinitionId", "details", "vmId", "vmName", "isOsDiskEncrypted", "isDataDiskEncrypted"}, {"subscriptionId", "id", "title", "classification", "totalNumberOfImpactedMachines", "severity", "osType", "isMandatory", "workspaces", "name", "uniqueKey", "resourceId", "baselineRuleId", "baselineName", "baselineCceId", "osName", "ruleType", "totalNumberOfDefectedMachines", "resourceType", "category", "assessmentKey", "policyName", "policyDefinitionId", "details", "vmId", "vmName", "isOsDiskEncrypted", "isDataDiskEncrypted"}),
     #"Filtered Rows" = Table.SelectRows(#"Expanded securityTaskParameters", each ([subscriptionId] = null))  
in
    #"Filtered Rows"
in
    ListSecurityTasks

// Security Tasks
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Converted to Table", {"Column1"}),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Removed Errors", "Column1", {"subscriptionId", "displayName"}, {"subscriptionId", "displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"displayName", "SubscriptionName"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns", "SecurityTasks", each #"List Security tasks"([subscriptionId])),
    #"Removed Errors1" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"SecurityTasks"}),
    #"Expanded SecurityTasks" = Table.ExpandTableColumn(#"Removed Errors1", "SecurityTasks", {"Security Center Task Id", "state", "subState", "creationTimeUtc", "lastStateChangeTimeUtc", "id", "title", "classification", "totalNumberOfImpactedMachines", "severity", "osType", "isMandatory", "name", "uniqueKey", "resourceId", "resourceType", "policyName", "policyDefinitionId", "vmId", "vmName", "isOsDiskEncrypted", "isDataDiskEncrypted"}, {"Security Center Task Id", "state", "subState", "creationTimeUtc", "lastStateChangeTimeUtc", "id", "title", "classification", "totalNumberOfImpactedMachines", "severity", "osType", "isMandatory", "name", "uniqueKey", "resourceId", "resourceType", "policyName", "policyDefinitionId", "vmId", "vmName", "isOsDiskEncrypted", "isDataDiskEncrypted"}),
 #"Added Conditional Column" = Table.AddColumn(#"Expanded SecurityTasks", "Custom", each if [policyName] = null then [name] else [policyName]),
    #"Renamed Columns1" = Table.RenameColumns(#"Added Conditional Column",{{"Custom", "Recommendation"}}),
    #"Replaced EncryptionOnVM Value" = Table.ReplaceValue(#"Renamed Columns1","EncryptionOnVm","Apply Disk Encryption on your virtual machines",Replacer.ReplaceText,{"Recommendation"}),
    #"Replaced InstallAntimalware Value" = Table.ReplaceValue(#"Replaced EncryptionOnVM Value","InstallAntimalware","#(tab)Install endpoint protection solution on your machines",Replacer.ReplaceText,{"Recommendation"}),
    #"Replaced UpgradePricingTierTaskParameters Value" = Table.ReplaceValue(#"Replaced InstallAntimalware Value","UpgradePricingTierTaskParameters","Enable Azure Security Center Standard tier on the Subscription",Replacer.ReplaceText,{"Recommendation"}),
    #"Filling Empty Categories" = Table.AddColumn(#"Replaced UpgradePricingTierTaskParameters Value", "Category2", each if [name] = "Enable Security Contact Configuration in Policy" then "IdentityAndAccess" else if [name] = "EncryptionOnVm" then "Compute" else if [name] = "UpgradePricingTierTaskParameters" then "IdentityAndAccess" else if [name] = "InstallAntimalware" then "Compute" else if [name] = "Enable auditing for the SQL server" then "Data" else if [name] = "Antimalware Health Issues" then "Compute" else if [name] = "Enable Transparent encryption for the database" then "Data" else if [name] = "RebootVm" then "Compute" else [resourceType]),
    #"Replaced Value" = Table.ReplaceValue(#"Filling Empty Categories","Subscription","IdentityAndAccess",Replacer.ReplaceText,{"Category2"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value","VirtualMachine","Compute",Replacer.ReplaceText,{"Category2"}),
    #"Replaced Value2" = Table.ReplaceValue(#"Replaced Value1","SqlServer","Data",Replacer.ReplaceText,{"Category2"}),
    #"Replaced Value3" = Table.ReplaceValue(#"Replaced Value2","Microsoft_ContainerService_managedClusters","AKS_RBAC",Replacer.ReplaceText,{"Category2"}),
    #"Replaced Value4" = Table.ReplaceValue(#"Replaced Value3","SqlDb","Data",Replacer.ReplaceText,{"Category2"}),
    #"Replaced Value5" = Table.ReplaceValue(#"Replaced Value4","Server","Compute",Replacer.ReplaceText,{"Category2"}),
    #"Filtered Rows" = Table.SelectRows(#"Replaced Value5", each ([resourceType] = "Microsoft_ContainerService_managedClusters"))
in
    #"Filtered Rows"