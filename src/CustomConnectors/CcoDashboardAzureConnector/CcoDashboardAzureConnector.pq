// This file contains your Data Connector logic
section CcoDashboardAzureConnector;

// TODO: add your client id and secret to the embedded files
client_id = Text.FromBinary(Extension.Contents("client_id"));

redirect_uri = "https://de-users-preview.sqlazurelabs.com/account/reply/";
windowWidth = 800;
windowHeight = 800;

// BaseUrl = "https://api.data.world/v0";
OAuthBaseUrl = "https://login.windows.net/common/oauth2";

[DataSource.Kind="CcoDashboardAzureConnector", Publish="CcoDashboardAzureConnector.Publish"]
shared CcoDashboardAzureConnector.Management = () as table =>
    let
        objects = #table(
            {"Name",       "Key",        "Data",                           "ItemKind", "ItemName", "IsLeaf"},{
            {"Policies",   "policies",      GetPoliciesTable(),  "Table",    "Table",    true},                        
            {"Get entities Management Groups",   "alldescendantstrick",      GetAllDescendantsPortalWay(),  "Table",    "Table",    true},   
            {"All Resources", "allresources", GetAllResources(), "Table", "Table", true},
            {"Blueprints", "blueprints", GetAllBlueprints(), "Table", "Table", true},
            {"Blueprint Artifacts", "blueprintartifact", CcoDashboardAzureConnector.GetBlueprintArtifacts(), "Table", "Table", true},
            {"Published Blueprints", "blueprintspublished", GetPublisedBlueprints(), "Table", "Table", true},
            {"Policy definitions", "policydefinitions", GetPolicyDefinitions(), "Table", "Table", true}

            //{"Resource Policies", "resourcepolicies", GetAllResourcePolicies(), "Table", "Table", true},
            //{"All descendants",   "alldescendants",      GetAllDescendants(),  "Table",    "Table",    true},               
//             {"MakeAPost", "makeapost", HelperFunctions.MakeAPost(),       "Function", "Function", true},
//             {"MakeACost", "makeacost", HelperFunctions.MakeACost(),       "Function", "Function", true}
        }),
        NavTable = Table.ToNavigationTable(objects, {"Key"}, "Name", "Data", "ItemKind", "ItemName", "IsLeaf")
    in
        NavTable;

shared GetAllDescendantsPortalWay=() as table =>
    let
        credential = Extension.CurrentCredential(),
        token = if (credential[AuthenticationKind] = "Key") then credential[Key] else credential[access_token],        
        headers = [ Authorization = "Bearer " & token ],
        tenantList = Json.Document(Web.Contents("https://management.azure.com/tenants?api-version=2019-11-01", 
            [Headers=headers, 
            ManualCredentials=true])),
        value=tenantList[value],
        #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        #"ExpandedColumns" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "tenantId", "countryCode", "displayName", "domains", "tenantCategory"}, {"id", "tenantId", "countryCode", "displayName", "domains", "tenantCategory"}),
        #"RetrieveTenantManagementGroups"= Table.AddColumn(#"ExpandedColumns", "ManagementGroups", each GetTenantManagementGroups([tenantId], token))
    in
        #"RetrieveTenantManagementGroups";

shared GetPolicyDefinitions = () as table =>
    let
        token = GetAccessToken(),        
        #"ExpandIdColumns" = GetSubscriptionsTable(token),
        // loop the subscription list to retrieve data
        #"Policies" = Table.AddColumn(#"ExpandIdColumns", "Policies", each try SubscriptionPolicyDefinitions([subscriptionId], token)),
        #"ExpandedPolicies" = Table.ExpandRecordColumn(#"Policies", "Policies", {"HasError", "Value", "Error"}, {"HasError", "Value", "Error"}),
        #"PoliciesOk" = Table.SelectRows(#"ExpandedPolicies", each ([HasError] = false)),
        #"PoliciesNoErrorColumn" = Table.RemoveColumns(#"PoliciesOk",{"HasError", "Error"})
   in        
        #"PoliciesNoErrorColumn";

SubscriptionPolicyDefinitions=(subscriptionId as text, token as text)=>
    let
        url = "https://management.azure.com/subscriptions/" & subscriptionId & "/providers/Microsoft.Authorization/policyDefinitions?api-version=2018-05-01",
        definitions = ListAllGet(url)
    in definitions;

shared GetPublisedBlueprints=() as table =>
    let
        blueprintsSanitized = GetAllBlueprintsSanitized(),
        blueprintArtifacts = Table.AddColumn(blueprintsSanitized, "Artifacts", each try GetSubscriptionPublishedBlueprints([subscriptionId], [name])),
        #"Expanded Artifacts" = Table.ExpandRecordColumn(blueprintArtifacts, "Artifacts", {"HasError", "Error", "Value"}, {"HasError", "Error", "Value"}),
        #"Filtered Rows" = Table.SelectRows(#"Expanded Artifacts", each ([HasError] = false)),
        RemovedErrorColumns = Table.RemoveColumns(#"Filtered Rows",{"HasError", "Error"}),
        #"Expanded Value" = Table.ExpandTableColumn( RemovedErrorColumns, "Value", {"Name", "Value"}, {"Name.1", "Value.1"}),
        #"Expanded Value.1" = Table.ExpandRecordColumn(#"Expanded Value", "Value.1", {"properties", "id", "type", "name"}, {"properties.1", "id.1", "type.1", "name.2"}),
        publishedBlueprints = Table.ExpandRecordColumn(#"Expanded Value.1", "properties.1", {"blueprintName", "changeNotes", "parameters", "resourceGroups", "targetScope", "status", "displayName", "description"}, {"blueprintName", "changeNotes", "parameters", "resourceGroups", "targetScope", "status", "displayName.1", "description"})
    in publishedBlueprints;

GetSubscriptionPublishedBlueprints=(subscriptionId as text, blueprintName as text)=>
    let
        Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.Blueprint/blueprints/"&blueprintName&"/versions?api-version=2018-11-01-preview")),
        value = Source[value],
        #"Converted to Table" = Record.ToTable(Source),
        #"Expanded Value" = Table.ExpandListColumn(#"Converted to Table", "Value")
    in #"Expanded Value";




shared GetAllBlueprints=() as table =>
    let
        token= GetAccessToken(),
        subscriptions = GetSubscriptionsTable(token),
        blueprints = Table.AddColumn(subscriptions, "Blueprints", each GetSubscriptionBlueprints([subscriptionId], token))
    in 
        blueprints;

shared CcoDashboardAzureConnector.GetBlueprintArtifacts=() as table =>
    let
        blueprintsSanitized = GetAllBlueprintsSanitized(),
        blueprintArtifacts = Table.AddColumn(blueprintsSanitized, "Artifacts", each try GetArtifactsByBlueprint([subscriptionId], [name])),
        #"Expanded Artifacts" = Table.ExpandRecordColumn(blueprintArtifacts, "Artifacts", {"HasError", "Error", "Value"}, {"HasError", "Error", "Value"}),
        #"Filtered Rows" = Table.SelectRows(#"Expanded Artifacts", each ([HasError] = false)),
        #"Removed Columns" = Table.RemoveColumns(#"Filtered Rows",{"HasError", "Error"}),
        #"Expanded Value" = Table.ExpandRecordColumn(#"Removed Columns", "Value", {"value"}, {"value.1"}),
        #"Expanded value.1" = Table.ExpandListColumn(#"Expanded Value", "value.1"),
        #"Expanded value.2" = Table.ExpandRecordColumn(#"Expanded value.1", "value.1", {"properties", "kind", "id", "type", "name"}, {"properties.1", "kind", "id.1", "type.1", "name.1"})
    in #"Expanded value.2";

GetAllBlueprintsSanitized= () as table=>
    let
        blueprints = GetAllBlueprints(),
        noErrorBlueprints = Table.RemoveRowsWithErrors(blueprints, {"Blueprints"}),
        ExpandedBlueprints = Table.ExpandTableColumn(noErrorBlueprints, "Blueprints", {"Column1"}, {"Column1"}),
        ExpandedColumn1 = Table.ExpandListColumn(ExpandedBlueprints, "Column1"),
        sanitizedBluebrints = Table.ExpandRecordColumn(ExpandedColumn1, "Column1", {"properties", "id", "type", "name"}, {"properties", "id", "type", "name"})
    in sanitizedBluebrints;

GetArtifactsByBlueprint=(subscriptionId as text, blueprintName as text)=>
    let
        url ="https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.Blueprint/blueprints/"&blueprintName&"/artifacts?api-version=2018-11-01-preview",
        Source = Json.Document(Web.Contents(url))
    in Source;

GetSubscriptionBlueprints= (subscriptionId as text, token as text) =>
    let
        url = "https://management.azure.com/subscriptions/" & subscriptionId & "/providers/Microsoft.Blueprint/blueprints?api-version=2018-11-01-preview",
        Source =  ListAllGet(url)
    in
        Source;

GetAllResourcePolicies = () as table =>
    let
        allresources = GetAllResources(),
        token = GetAccessToken(),
        ExpandedResourceId = Table.ExpandRecordColumn(allresources, "ExpandedResourcesColumn", {"id"}, {"id"}),
        resourcePolicies = Table.AddColumn(ExpandedResourceId, "Policies", each try GetResourcePolicies([id], token)),
        ExpandedPolicies = Table.ExpandRecordColumn(resourcePolicies, "Policies", {"HasError", "Value", "Error"}, {"HasError", "Value", "Error"}),
        FilteredErrors = Table.SelectRows(ExpandedPolicies, each ([HasError] = false)),
        RemovedErrorColumns = Table.RemoveColumns(FilteredErrors,{"HasError", "Error"})
    in RemovedErrorColumns;

 GetResourcePolicies=(resourceId as text, token as text)=>
    let
        url = "https://management.azure.com" & resourceId & "/providers/Microsoft.PolicyInsights/policyEvents/default/queryResults?api-version=2018-04-04",
        header = GetAuthorizationHeader(token),
        resourcePolicies = try Json.Document(Web.Contents(url, 
                                               [ Headers=header, 
                                                 ManualCredentials=true, 
                                                 ManualStatusHandling={403},
                                                 Content=Text.ToBinary("")])) otherwise "Cannot retrieve resource policies"
        
    in resourcePolicies;

GetAllResources=() as table=>
    let
        token = GetAccessToken(),        
        #"ExpandIdColumns" = GetSubscriptionsTable(token),
        #"allResources"=Table.AddColumn(#"ExpandIdColumns", "Resources", each try GetAllSubscriptionResources([subscriptionId], token)),
        #"ExpandedResources" = Table.ExpandRecordColumn(#"allResources", "Resources", {"HasError", "Value"}, {"HasError", "Value"}),
        #"ResourcesOk" = Table.SelectRows(#"ExpandedResources", each ([HasError] = false)),
        #"ResourcesNoErrorColumn" = Table.RemoveColumns(#"ResourcesOk",{"HasError"}),
        #"ExpandedValue" = Table.ExpandTableColumn(#"ResourcesNoErrorColumn", "Value", {"Column1"}, {"ExpandedResourcesColumn"}),
        #"TableWithResources" = Table.ExpandListColumn(#"ExpandedValue", "ExpandedResourcesColumn")
     in
         #"TableWithResources";

GetAllSubscriptionResources=(subscriptionId, token)=>
    let
        url = "https://management.azure.com/subscriptions/"&subscriptionId&"/resources?api-version=2019-05-01",        
        allSubscriptionResources=ListAllGet(url)
    in 
        allSubscriptionResources;

GetTenantManagementGroups=(tenanId, token)=>
    let
        headers = [Authorization="Bearer " & token],
        Source = try Json.Document(Web.Contents("https://management.azure.com/providers/Microsoft.Management/getEntities?api-version=2018-03-01-preview&%24filter=name%20eq%20%27" & tenanId & "%27", 
            [ Headers = headers, 
              ManualStatusHandling={403},
              ManualCredentials = true, 
              Content=Text.ToBinary("")])) otherwise "Error retrieving data"
    in Source;

GetAllDescendants=() as table =>
    let 
        token = GetAccessToken(),
        headers = [ Authorization = "Bearer " & token ],
        Source = try Json.Document(Web.Contents("https://management.azure.com/providers/Microsoft.Management/managementGroups?api-version=2019-11-01", 
            [Headers=headers, 
            ManualCredentials = true,
            ManualStatusHandling={403}])) otherwise "Seems you don't have permissions to get management groups",
        value = Source[value],
        #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "type", "name", "properties"}, {"id", "type", "name", "properties"}),
        #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column1", "properties", {"tenantId", "displayName"}, {"tenantId", "displayName"}),
        #"Invoked Custom Function" = Table.AddColumn(#"Expanded properties", "Descendants", each GetDescendants([name], token))
        in 
            #"Invoked Custom Function";

GetDescendants=(MgId as text, token as text)=>
 let
     headers = [ Authorization = "Bearer " & token ],
     
    Source = try Json.Document(Web.Contents("https://management.azure.com/providers/Microsoft.Management/managementGroups/"&MgId&"/descendants?api-version=2019-11-01",
        [Headers=headers, 
        ManualCredentials = true, 
        ManualStatusHandling={403}])) otherwise "Seems you don't have permissions to get management group "&MgId,
    value = Source[value]
in
    value;

shared GetSubscriptions=(token as text)=>
    let
        headers = [ Authorization = "Bearer " & token ],
        subscriptionList = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2019-11-01", 
            [ Headers = headers, ManualCredentials = true])),
        value = subscriptionList[value]
    in
        value;

shared GetSubscriptionsTable=(token as text)=>
    let
        subscriptions =GetSubscriptions(token),
        st = Table.FromList(subscriptions, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        ExpandIdColumns = Table.ExpandRecordColumn(st, "Column1", {"subscriptionId", "displayName"}, {"subscriptionId", "displayName"})
    in
        ExpandIdColumns;
 
shared GetPoliciesTable = () as table =>
    let
        token = GetAccessToken(),        
        #"ExpandIdColumns" = GetSubscriptionsTable(token),
        // loop the subscription list to retrieve data
        #"Policies" = Table.AddColumn(#"ExpandIdColumns", "Policies", each try Policies([subscriptionId], token)),
        #"ExpandedPolicies" = Table.ExpandRecordColumn(#"Policies", "Policies", {"HasError", "Value", "Error"}, {"HasError", "Value", "Error"}),
        #"PoliciesOk" = Table.SelectRows(#"ExpandedPolicies", each ([HasError] = false)),
        #"PoliciesNoErrorColumn" = Table.RemoveColumns(#"PoliciesOk",{"HasError", "Error"})
   in        
        #"PoliciesNoErrorColumn";

// published helper functions



Policies = (subscriptionId, token) =>
        let
//         headers = [ Authorization = "Bearer " & token ],
//         policies = try Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.PolicyInsights/policyStates/default/queryResults?api-version=2019-10-01", 
//             [ Headers = headers, 
//               ManualCredentials = true, 
//               ManualStatusHandling={403},
//               Content=Text.ToBinary("") ])) otherwise "Cannot retrieve",
//         value=policies[value],
//         #"ConvertSubscriptionListToTable" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error)
    url = "https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.PolicyInsights/policyStates/default/queryResults?api-version=2019-10-01",
    #"PoliciesTable"= ListAllPost(url, token)
    in        
        #"PoliciesTable";

// Helper methods

// Data Source Kind description
CcoDashboardAzureConnector = [
    // enable both OAuth and Key based auth
    Authentication = [
        OAuth = [
            StartLogin = StartLogin,
            FinishLogin = FinishLogin,
            Refresh=Refresh
        ]
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
CcoDashboardAzureConnector.Publish = [
    Beta = true,
    Category = "Azure",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://aka.ms/ccodashboard"
];

//
// OAuth2 flow definition
//

StartLogin = (resourceUrl, state, display) =>
    let
        AuthorizeUrl = OAuthBaseUrl & "/authorize?" & Uri.BuildQueryString([
            client_id = client_id,
            resource= "https://management.azure.com",
            response_type = "code",
            response_mode= "query",
            prompt="login",
            state = state,
            nonce= "pepe", // make it random
            redirect_uri = redirect_uri])
    in
        [
            LoginUri = AuthorizeUrl,
            CallbackUri = redirect_uri,
            WindowHeight = windowHeight,
            WindowWidth = windowWidth,
            Context = null
        ];

FinishLogin = (context, callbackUri, state) =>
    let
        Parts = Uri.Parts(callbackUri)[Query]
    in
        TokenMethod(Parts[code], "authorization_code");

TokenMethod = (code, grant_type) =>
    let
        Response = Web.Contents(OAuthBaseUrl & "/token", [
            Content = Text.ToBinary(Uri.BuildQueryString([
                client_id = client_id,
                code = code,
                grant_type = grant_type,
                redirect_uri = redirect_uri])),
            Headers=[#"Content-type" = "application/x-www-form-urlencoded",#"Accept" = "application/json"]]),
        Parts = Json.Document(Response)
    in
        Parts;

Refresh = (resourceUrl, refresh_token) => TokenMethod(refresh_token, "refresh_token");


// Common library code
shared GetAccessToken = () =>
let
    credential = Extension.CurrentCredential(),
        token = if (credential[AuthenticationKind] = "Key") then credential[Key] else credential[access_token]
     in
         token;

shared GetAuthorizationHeader = (token as text) =>
    let
        headers=[Authorization= "Bearer " & token]
    in 
        headers;

ListAllGet = (url as text) =>
let
    FuncGetOnePage = (url) as record =>
    let 
       Source = Json.Document(Web.Contents(url)),
       data = try Source[value] otherwise null,
       next = try Source[nextLink] otherwise null,
       res = [Data=data, Next=next]
    in
        res,
        GeneratedListOfPages = List.Generate(()=>[res = FuncGetOnePage(url)],
        each [res][Data]<>null,
        each [res = FuncGetOnePage([res][Next])],
        each [res][Data]),

    #"Converted to Table" = Table.FromList(GeneratedListOfPages, Splitter.SplitByNothing(), null, null, ExtraValues.Error)
    in #"Converted to Table";

ListAllPost = (url as text, token as text) =>
let
    FuncPostOnePage = (url, token) as record =>
    let 
       headers = [ Authorization = "Bearer " & token ],
       Source = try Json.Document(Web.Contents(url, 
                    [ Headers = headers, 
                      ManualCredentials = true, 
                      ManualStatusHandling={403}, 
                      Content=Text.ToBinary("")])) otherwise "cannot retrieve data",
       data = try Source[value] otherwise null,
       next = try Source[nextLink] otherwise null,
       res = [Data=data, Next=next]
    in
        res,
        GeneratedListOfPages = List.Generate(()=>[res = FuncPostOnePage(url, token)],
        each [res][Data]<>null,
        each [res = FuncPostOnePage([res][Next], token)],
        each [res][Data]),

    #"Converted to Table" = Table.FromList(GeneratedListOfPages, Splitter.SplitByNothing(), null, null, ExtraValues.Error)
    in #"Converted to Table";


// FuncGetOnePage = (url, token) as record =>
//     let 
//         headers = if token <> "" then [ Authorization = "Bearer " & token ] else [],     
//        Source = try Json.Document(Web.Contents(url, 
//                     [ Headers = headers, 
//                       ManualCredentials = true, 
//                       ManualStatusHandling={403}])) otherwise "cannot retrieve data",
//        data = try Source[value] otherwise null,
//        next = try Source[nextLink] otherwise null,
//        res = [Data=data, Next=next]
//     in
//         res;
// 
// shared GetAllItems = (url as text, token as text) =>
// let
//         GeneratedListOfPages = List.Generate(()=>[i=0, res = FuncGetOnePage(url, token)],
//         each [res]<>null and [res][Data]<>null,
//         each [res = FuncGetOnePage([res][Next])],
//         each [res][Data]),
//         #"AllItemsInATable" = try Table.FromList(GeneratedListOfPages, Splitter.SplitByNothing(), null, null, ExtraValues.Error) otherwise Table
// in 
//     #"AllItemsInATable";

Table.ToNavigationTable = (
    table as table,
    keyColumns as list,
    nameColumn as text,
    dataColumn as text,
    itemKindColumn as text,
    itemNameColumn as text,
    isLeafColumn as text
) as table =>
    let
        tableType = Value.Type(table),
        newTableType = Type.AddTableKey(tableType, keyColumns, true) meta 
        [
            NavigationTable.NameColumn = nameColumn, 
            NavigationTable.DataColumn = dataColumn,
            NavigationTable.ItemKindColumn = itemKindColumn, 
            Preview.DelayColumn = itemNameColumn, 
            NavigationTable.IsLeafColumn = isLeafColumn
        ],
        navigationTable = Value.ReplaceType(table, newTableType)
    in
        navigationTable;




HelperFunctions.MakeACost = () =>
    let
        credential = Extension.CurrentCredential(),
        token = if (credential[AuthenticationKind] = "Key") then credential[Key] else credential[access_token],
        headers = [ Authorization = "Bearer " & token ],
        policies = try Json.Document(Web.Contents("https://management.azure.com/subscriptions/98bc5d13-2aa1-45cb-bf49-45aa47e220bf/providers/Microsoft.PolicyInsights/policyStates/default/queryResults?api-version=2019-10-01", 
            [ Headers = headers, 
              ManualCredentials = true, 
              ManualStatusHandling={403},
              Content=Text.ToBinary("") ])) otherwise "Cannot retrieve, 403?",
        value=policies[value],
        #"ConvertSubscriptionListToTable" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error)

    in        
        #"ConvertSubscriptionListToTable";

HelperFunctions.MakeAPost = (address, content) =>
    let
        credential = Extension.CurrentCredential(),
        token = if (credential[AuthenticationKind] = "Key") then credential[Key] else credential[access_token],
        headers = [ Authorization = "Bearer " & token ],
        policies = try Json.Document(Web.Contents(address, 
            [ Headers = headers, 
              ManualCredentials = true, 
              ManualStatusHandling={403},
              Content=Text.ToBinary(content) ])) otherwise "Cannot retrieve, 403?",
        value=policies[value],
        #"ConvertSubscriptionListToTable" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error)

    in        
        #"ConvertSubscriptionListToTable";

// 
// Load common library functions
// 
Extension.LoadFunction = (name as text) =>
    let
        binary = Extension.Contents(name),
        asText = Text.FromBinary(binary)
    in
        Expression.Evaluate(asText, #shared);