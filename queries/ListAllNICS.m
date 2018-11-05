// Network Interfaces
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId", "displayName"}, {"subscriptionId", "displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"displayName", "Subscription Name"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns", "ListAllNICs", each ListAllNICs([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListAllNICs"}),
    #"Expanded ListAllNICs" = Table.ExpandTableColumn(#"Removed Errors", "ListAllNICs", {"name", "NIC Id", "location", "provisioningState", "resourceGuid", "dnsServers", "appliedDnsServers", "macAddress", "enableAcceleratedNetworking", "enableIPForwarding", "NSG Id", "primary", "Virtual Machine Id", "type"}, {"name", "NIC Id", "location", "provisioningState", "resourceGuid", "dnsServers", "appliedDnsServers", "macAddress", "enableAcceleratedNetworking", "enableIPForwarding", "NSG Id", "primary", "Virtual Machine Id", "type"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded ListAllNICs",{"subscriptionId", "Subscription Name"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"name", "NIC Name"}})
in
    #"Renamed Columns1"

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

// Network Interfaces Details
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
    #"Removed Columns1" = Table.RemoveColumns(#"Renamed Columns2",{"Subnet Id - Copy.10", "Subnet Id - Copy.4", "Subnet Id - Copy.5", "Subnet Id - Copy.6", "Subnet Id - Copy.7", "Subnet Id - Copy.8", "Subnet Id - Copy.1", "Subnet Id - Copy.2", "Subnet Id - Copy.3", "name.1"})
in
    #"Removed Columns1"

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
