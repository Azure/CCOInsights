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