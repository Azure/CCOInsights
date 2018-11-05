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

// All Subscriptions
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "subscriptionId", "displayName", "state", "subscriptionPolicies", "authorizationSource"}, {"id", "subscriptionId", "displayName", "state", "subscriptionPolicies", "authorizationSource"}),
    #"Expanded subscriptionPolicies" = Table.ExpandRecordColumn(#"Expanded Column1", "subscriptionPolicies", {"locationPlacementId", "quotaId", "spendingLimit"}, {"locationPlacementId", "quotaId", "spendingLimit"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded subscriptionPolicies",{"id"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"displayName", "Subscription Name"}})
in
    #"Renamed Columns"

// LastRefresh_Local
let
Source = #table(type table[LastRefresh=datetime], {{DateTime.LocalNow()}}),
    #"Renamed Columns" = Table.RenameColumns(Source,{{"LastRefresh", "Refresh"}})
in
#"Renamed Columns"

// TenantName
"XXXXXXXX" meta [IsParameterQuery=true, Type="Text", IsParameterQueryRequired=true]