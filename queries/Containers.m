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
    #"Removed Columns2" = Table.RemoveColumns(#"Renamed Columns2",{"SubscriptionId", "Subscription Name"})
in
    #"Removed Columns2"

// ListACI
let ListResourceGroups= (subscriptionId as text) =>

let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.ContainerInstance/containerGroups?api-version=2018-02-01-preview")),
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