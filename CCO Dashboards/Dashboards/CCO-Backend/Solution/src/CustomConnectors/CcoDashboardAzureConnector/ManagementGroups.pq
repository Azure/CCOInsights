let
    Source = Json.Document(Web.Contents("https://management.azure.com/providers/Microsoft.Management/managementGroups?api-version=2019-11-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "type", "name", "properties"}, {"id", "type", "name", "properties"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column1", "properties", {"tenantId", "displayName"}, {"tenantId", "displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded properties",{{"id", "MG Resource Id"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns",{"type"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"name", "MG Name"}, {"displayName", "MG Display Name"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns1", "Descendants", each GetDescendants([MG Name])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"Descendants"}),
    #"Expanded Descendants" = Table.ExpandTableColumn(#"Removed Errors", "Descendants", {"name", "id", "type", "displayName", "Parent Id"}, {"name", "id", "type", "displayName", "Parent Id"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Expanded Descendants",{"MG Resource Id", "MG Name", "MG Display Name"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Removed Columns1",{{"name", "Resource Name"}, {"id", "Resource Id"}, {"displayName", "Resource Display Name"}}),
    #"Appended Query" = Table.Combine({#"Renamed Columns2", TopLevelMGs}),
    #"Removed Columns2" = Table.RemoveColumns(#"Appended Query",{"tenantId", "name", "displayName"}),
    #"Replaced Value" = Table.ReplaceValue(#"Removed Columns2",null,"TopLevelMG",Replacer.ReplaceValue,{"type"}),
    #"Added Conditional Column" = Table.AddColumn(#"Replaced Value", "Icon", each if [type] = "/subscriptions" then "https://azure.github.io/ccodashboard/assets/pictures/036_ASCTasks_Subscription.svg" else "https://azure.github.io/ccodashboard/assets/pictures/037_Management_Groups.svg"),
    #"Removed Duplicates" = Table.Distinct(#"Added Conditional Column", {"Resource Id"})
in
    #"Removed Duplicates"


let Descendants = (MGId as text) =>
 let
    Source = Json.Document(Web.Contents("https://management.azure.com/providers/Microsoft.Management/managementGroups/"&MGId&"/descendants?api-version=2019-11-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"name", "id", "type", "properties"}, {"name", "id", "type", "properties"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column1", "properties", {"displayName", "parent"}, {"displayName", "parent"}),
    #"Expanded parent" = Table.ExpandRecordColumn(#"Expanded properties", "parent", {"id"}, {"id.1"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded parent",{{"id.1", "Parent Id"}})
in
    #"Renamed Columns"
in
    Descendants