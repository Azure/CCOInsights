// Resource Groups
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId", "displayName"}, {"subscriptionId", "displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"displayName", "Subscription Name"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns", "ListResourceGroups", each ListResourceGroups([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListResourceGroups"}),
    #"Expanded ListResourceGroups" = Table.ExpandTableColumn(#"Removed Errors", "ListResourceGroups", {"Resource Group Id", "Resource Group Name", "location", "provisioningState"}, {"Resource Group Id", "Resource Group Name", "location", "provisioningState"})
in
    #"Expanded ListResourceGroups"

// ListResourceGroups
let ListResourceGroups = (subscriptionId as text) =>
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/resourcegroups?api-version=2017-05-10")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "name", "location", "properties"}, {"id", "name", "location", "properties"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column1", "properties", {"provisioningState"}, {"provisioningState"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded properties",{{"id", "Resource Group Id"}, {"name", "Resource Group Name"}})
in
    #"Renamed Columns"

in
    ListResourceGroups

// ListResourceGroups (2)
let ListResourceGroups = (subscriptionId as text) =>
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/resourcegroups?api-version=2017-05-10")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "name", "location", "properties"}, {"id", "name", "location", "properties"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column1", "properties", {"provisioningState"}, {"provisioningState"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded properties",{{"id", "Resource Group Id"}, {"name", "Resource Group Name"}})
in
    #"Renamed Columns"

in
    ListResourceGroups