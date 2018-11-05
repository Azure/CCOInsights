// Virtual Networks
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId","displayName"}, {"Column1.subscriptionId","Column1.displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"Column1.subscriptionId", "SubscriptionId"}}),
    #"List VirtualNetworks" = Table.AddColumn(#"Renamed Columns", "ListVirtualNetworks", each ListVirtualNetworks([SubscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"List VirtualNetworks", {"ListVirtualNetworks"}),
    #"Expanded ListVirtualNetworks" = Table.ExpandTableColumn(#"Removed Errors", "ListVirtualNetworks", {"VNET Name", "VNET Id", "location", "provisioningState", "resourceGuid", "VNET addressPrefixes", "Subnet Name", "Subnet Id", "Subnet addressPrefix", "IP Configuration Id", "serviceEndpoints", "Route Table id", "VNET Peering Name", "VNET Peering Id", "VNET peeringState", "Remote VNET Id", "allowVirtualNetworkAccess", "allowForwardedTraffic", "allowGatewayTransit", "useRemoteGateways", "Remote VNET addressPrefixes", "enableDdosProtection", "enableVmProtection", "dnsServers", "Resource Group"}, {"VNET Name", "VNET Id", "location", "provisioningState", "resourceGuid", "VNET addressPrefixes", "Subnet Name", "Subnet Id", "Subnet addressPrefix", "IP Configuration Id", "serviceEndpoints", "Route Table id", "VNET Peering Name", "VNET Peering Id", "VNET peeringState", "Remote VNET Id", "allowVirtualNetworkAccess", "allowForwardedTraffic", "allowGatewayTransit", "useRemoteGateways", "Remote VNET addressPrefixes", "enableDdosProtection", "enableVmProtection", "dnsServers", "Resource Group"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded ListVirtualNetworks",{{"Column1.displayName", "Subscription Name"}}),
    #"Renamed Columns2" = Table.RenameColumns(#"Renamed Columns1",{{"Subnet addressPrefix", "Subnet Address Prefix"}}),
    #"Added Conditional Column" = Table.AddColumn(#"Renamed Columns2", "Available IPs", each if Text.Contains([Subnet Address Prefix], "/24") then 251 else if Text.Contains([Subnet Address Prefix], "/25") then 122 else if Text.Contains([Subnet Address Prefix], "/16") then 65530 else if Text.Contains([Subnet Address Prefix], "/26") then 58 else if Text.Contains([Subnet Address Prefix], "/27") then 26 else if Text.Contains([Subnet Address Prefix], "/28") then 10 else if Text.Contains([Subnet Address Prefix], "/29") then 4 else if Text.Contains([Subnet Address Prefix], "/23") then 506 else if Text.Contains([Subnet Address Prefix], "/22") then 1018 else if Text.Contains([Subnet Address Prefix], "/21") then 2042 else if Text.Contains([Subnet Address Prefix], "/20") then 4090 else if Text.Contains([Subnet Address Prefix], "/11") then 16777210 else if Text.Contains([Subnet Address Prefix], "/12") then 1048570 else null),
    #"Added Conditional Column1" = Table.AddColumn(#"Added Conditional Column", "IP", each if [IP Configuration Id] = null then 0 else 1),
    #"Changed Type" = Table.TransformColumnTypes(#"Added Conditional Column1",{{"IP", Int64.Type}, {"Available IPs", Int64.Type}}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Changed Type", "Remote VNET Id", "Remote VNET Id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(Table.TransformColumnTypes(#"Duplicated Column", {{"Remote VNET Id - Copy", type text}}, "en-US"), "Remote VNET Id - Copy", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"Remote VNET Id - Copy.1", "Remote VNET Id - Copy.2", "Remote VNET Id - Copy.3", "Remote VNET Id - Copy.4", "Remote VNET Id - Copy.5", "Remote VNET Id - Copy.6", "Remote VNET Id - Copy.7", "Remote VNET Id - Copy.8", "Remote VNET Id - Copy.9"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Remote VNET Id - Copy.1", type text}, {"Remote VNET Id - Copy.2", type text}, {"Remote VNET Id - Copy.3", type text}, {"Remote VNET Id - Copy.4", type text}, {"Remote VNET Id - Copy.5", type text}, {"Remote VNET Id - Copy.6", type text}, {"Remote VNET Id - Copy.7", type text}, {"Remote VNET Id - Copy.8", type text}, {"Remote VNET Id - Copy.9", type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type1",{"Remote VNET Id - Copy.1", "Remote VNET Id - Copy.2", "Remote VNET Id - Copy.3", "Remote VNET Id - Copy.4", "Remote VNET Id - Copy.5", "Remote VNET Id - Copy.6", "Remote VNET Id - Copy.7", "Remote VNET Id - Copy.8"}),
    #"Renamed Columns3" = Table.RenameColumns(#"Removed Columns",{{"Remote VNET Id - Copy.9", "Remote VNET Name"}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Renamed Columns3",{"SubscriptionId", "Subscription Name"}),
    #"Duplicated Column1" = Table.DuplicateColumn(#"Removed Columns1", "IP Configuration Id", "IP Configuration Id - Copy"),
    #"Split Column by Delimiter1" = Table.SplitColumn(#"Duplicated Column1", "IP Configuration Id - Copy", Splitter.SplitTextByDelimiter("/ipConfigurations", QuoteStyle.Csv), {"IP Configuration Id - Copy.1", "IP Configuration Id - Copy.2"}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Split Column by Delimiter1",{{"IP Configuration Id - Copy.1", type text}, {"IP Configuration Id - Copy.2", type text}}),
    #"Renamed Columns4" = Table.RenameColumns(#"Changed Type2",{{"IP Configuration Id - Copy.1", "NIC Id"}}),
    #"Removed Columns2" = Table.RemoveColumns(#"Renamed Columns4",{"IP Configuration Id - Copy.2"}),
    #"Replaced Value" = Table.ReplaceValue(#"Removed Columns2","Null","Azure Provided",Replacer.ReplaceText,{"dnsServers"}),
    #"Renamed Columns5" = Table.RenameColumns(#"Replaced Value",{{"enableDdosProtection", "DDoS Protection"}}),
    #"Changed Type3" = Table.TransformColumnTypes(#"Renamed Columns5",{{"DDoS Protection", type text}}),
    #"Replaced Value1" = Table.ReplaceValue(#"Changed Type3","false","Disabled",Replacer.ReplaceText,{"DDoS Protection"}),
    #"Replaced Value2" = Table.ReplaceValue(#"Replaced Value1","true","Enabled",Replacer.ReplaceText,{"DDoS Protection"})
in
    #"Replaced Value2"

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
    #"Removed Columns" = Table.RemoveColumns(#"Expanded ListResources",{"subscriptionId", "Subscription Name"}),
    #"Filtered Rows" = Table.SelectRows(#"Removed Columns", each true),
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

// VNET Peerings
let
    Source = Table.NestedJoin(#"Virtual Networks",{"Remote VNET Id"},Resources,{"Resource Id"},"Resources",JoinKind.LeftOuter),
    #"Expanded Resources" = Table.ExpandTableColumn(Source, "Resources", {"location"}, {"location.1"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Resources",{{"location.1", "Remote VNET Location"}}),
    #"Filtered Rows" = Table.SelectRows(#"Renamed Columns", each [VNET Peering Id] <> null and [VNET Peering Id] <> ""),
    #"Merged Queries" = Table.NestedJoin(#"Filtered Rows",{"location"},#"Azure Regions",{"AzureLocation"},"Azure Regions",JoinKind.LeftOuter),
    #"Expanded Azure Regions" = Table.ExpandTableColumn(#"Merged Queries", "Azure Regions", {"Longitude", "Latitude"}, {"Longitude", "Latitude"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded Azure Regions",{{"Longitude", "Source Longitude"}, {"Latitude", "Source Latitude"}}),
    #"Merged Queries1" = Table.NestedJoin(#"Renamed Columns1",{"Remote VNET Location"},#"Azure Regions",{"AzureLocation"},"Azure Regions",JoinKind.LeftOuter),
    #"Expanded Azure Regions1" = Table.ExpandTableColumn(#"Merged Queries1", "Azure Regions", {"Longitude", "Latitude"}, {"Longitude", "Latitude"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Expanded Azure Regions1",{{"Longitude", "Remote Longitude"}, {"Latitude", "Remote Latitude"}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Renamed Columns2",{{"Source Longitude", type number}, {"Source Latitude", type number}, {"Remote Longitude", type number}, {"Remote Latitude", type number}}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Changed Type", "VNET Id", "VNET Id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "VNET Id - Copy", Splitter.SplitTextByDelimiter("/resourceGroup", QuoteStyle.Csv), {"VNET Id - Copy.1", "VNET Id - Copy.2"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"VNET Id - Copy.1", type text}, {"VNET Id - Copy.2", type text}}),
    #"Renamed Columns3" = Table.RenameColumns(#"Changed Type1",{{"VNET Id - Copy.1", "Subscription Id"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns3",{"VNET Id - Copy.2"}),
    #"Added Conditional Column" = Table.AddColumn(#"Removed Columns", "Peering Type", each if [location] = [Remote VNET Location] then "VNET Peering" else "Global VNET Peering"),
    #"Added Conditional Column1" = Table.AddColumn(#"Added Conditional Column", "PeeringImage", each if [Peering Type] = "VNET Peering" then "https://raw.githubusercontent.com/JSFCES/DashboardImages/master/VNETPeering.svg?sanitize=true" else "https://raw.githubusercontent.com/JSFCES/DashboardImages/master/GlobalVNETPeering.svg?sanitize=true")
in
    #"Added Conditional Column1"

// Azure Regions
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId","displayName"}, {"Column1.subscriptionId","Column1.displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"Column1.subscriptionId", "SubscriptionId"}, {"Column1.displayName", "Subscription Name"}}),
    #"List AzureLocations" = Table.AddColumn(#"Renamed Columns", " ListAzureLocations", each  ListAzureLocations([SubscriptionId])),
    #"Expanded  ListAzureLocations" = Table.ExpandTableColumn(#"List AzureLocations", " ListAzureLocations", {"Name", "Value.id", "Value.name", "Value.displayName", "Value.longitude", "Value.latitude"}, {" ListAzureLocations.Name", " ListAzureLocations.Value.id", " ListAzureLocations.Value.name", " ListAzureLocations.Value.displayName", " ListAzureLocations.Value.longitude", " ListAzureLocations.Value.latitude"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded  ListAzureLocations",{" ListAzureLocations.Name", " ListAzureLocations.Value.id"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{" ListAzureLocations.Value.name", "AzureLocation"}, {" ListAzureLocations.Value.displayName", "Azure Location Display Name"}, {" ListAzureLocations.Value.longitude", "Longitude"}, {" ListAzureLocations.Value.latitude", "Latitude"}}),
    #"Removed Duplicates" = Table.Distinct(#"Renamed Columns1", {"AzureLocation"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Removed Duplicates",{"SubscriptionId", "Subscription Name"})
in
    #"Removed Columns1"

// ListAzureLocations
let ListAzureLocations = (subscriptionId as text) =>
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/locations?api-version=2016-06-01")),
    #"Converted to Table" = Record.ToTable(Source),
    #"Expanded Value" = Table.ExpandListColumn(#"Converted to Table", "Value"),
    #"Expanded Value1" = Table.ExpandRecordColumn(#"Expanded Value", "Value", {"id", "name", "displayName", "longitude", "latitude"}, {"Value.id", "Value.name", "Value.displayName", "Value.longitude", "Value.latitude"})
in
    #"Expanded Value1"
in 
    ListAzureLocations