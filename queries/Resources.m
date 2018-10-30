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