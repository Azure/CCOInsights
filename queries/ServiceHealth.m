// ListResourcesHealth
let ListResourcesHealth = (subscriptionId as text) =>
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.ResourceHealth/availabilityStatuses?api-version=2017-07-01&$expand=recommendedActions")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "name", "type", "location", "properties"}, {"id", "name", "type", "location", "properties"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column1", "properties", {"availabilityState", "summary", "detailedStatus", "reasonType", "recommendedActions", "occuredTime", "reasonChronicity", "reportedTime"}, {"availabilityState", "summary", "detailedStatus", "reasonType", "recommendedActions", "occuredTime", "reasonChronicity", "reportedTime"}),
    #"Expanded recommendedActions" = Table.ExpandListColumn(#"Expanded properties", "recommendedActions"),
    #"Expanded recommendedActions1" = Table.ExpandRecordColumn(#"Expanded recommendedActions", "recommendedActions", {"action", "actionUrl", "actionUrlText"}, {"action", "actionUrl", "actionUrlText"}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Expanded recommendedActions1", "id", "id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "id - Copy", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"id - Copy.1", "id - Copy.2", "id - Copy.3", "id - Copy.4", "id - Copy.5", "id - Copy.6", "id - Copy.7", "id - Copy.8", "id - Copy.9", "id - Copy.10", "id - Copy.11", "id - Copy.12", "id - Copy.13"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"id - Copy.1", type text}, {"id - Copy.2", type text}, {"id - Copy.3", type text}, {"id - Copy.4", type text}, {"id - Copy.5", type text}, {"id - Copy.6", type text}, {"id - Copy.7", type text}, {"id - Copy.8", type text}, {"id - Copy.9", type text}, {"id - Copy.10", type text}, {"id - Copy.11", type text}, {"id - Copy.12", type text}, {"id - Copy.13", type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type",{"id - Copy.1", "id - Copy.2", "id - Copy.3", "id - Copy.4"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"id - Copy.5", "Resource Group"}, {"id - Copy.8", "Resource Type"}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Renamed Columns",{"id - Copy.6", "id - Copy.7"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns1",{{"id - Copy.9", "Resource Name"}}),
    #"Removed Columns2" = Table.RemoveColumns(#"Renamed Columns1",{"id - Copy.10", "id - Copy.11", "id - Copy.12", "id - Copy.13"})
in
    #"Removed Columns2"
in
    ListResourcesHealth