// This file contains your Data Connector logic
section CcoDashboardAzureConnector;

// Oauth info from azure portal
client_id_global = Text.FromBinary(Extension.Contents("client_id_global"));
redirect_uri_global = "https://de-users-preview.sqlazurelabs.com/account/reply/";
// Oauth info from azure portal government
client_id_gov = Text.FromBinary(Extension.Contents("client_id_govus"));
// redirect_uri_gov = "https://portal.azure.us/signin/index/?feature.refreshtokenbinding=true&feature.usemsallogin=true";
redirect_uri_gov = "https://de-users-preview.sqlazurelabs.com/account/reply/";


windowWidth = 800;
windowHeight = 800;




// main entry point to custom connector
[DataSource.Kind="CcoDashboardAzureConnector", Publish="CcoDashboardAzureConnector.Publish"]
shared CcoDashboardAzureConnector.Management = Value.ReplaceType(ManagementImpl, ManagementMeta);

ManagementMeta = type function(
    azureKind as (type text meta [
        Documentation.FieldCaption = "Azure kind",
        Documentation.FieldDescription = "Kind of azure: global or government",        
        Documentation.AllowedValues = { "global", "us-government"}
    ]))
    as table meta [
        Documentation.Name = "CCO Dashboard Custom Connector",
        Documentation.LongDescription = "Cloud Cost Optimization Dashboard Custom Connector"        
    ];

shared ManagementImpl = (gov as text) as table =>
    let
        objects = #table(
            {"Name",       "Key",        "Data",                           "ItemKind", "ItemName", "IsLeaf"},{
            {"Policies",   "policies",      GetPoliciesTable(gov),  "Table",    "Table",    true},                        
            {"Get entities Management Groups",   "alldescendantstrick",      GetAllDescendantsPortalWay(gov),  "Table",    "Table",    true},   
            {"All Resources", "allresources", GetAllResources(gov), "Table", "Table", true},
            {"Blueprints", "blueprints", GetAllBlueprintsByScope(gov), "Table", "Table", true},
            {"Blueprint Artifacts", "blueprintartifact", GetBlueprintArtifacts(gov), "Table", "Table", true},
            {"Published Blueprints", "blueprintspublished", GetPublishedBlueprints(gov), "Table", "Table", true},
            {"Policy definitions", "policydefinitions", GetPolicyDefinitions(gov), "Table", "Table", true},
            {"Subscriptions", "subscriptions", GetSubscriptionsTable(gov, ""), "Table", "Table", true},
            {"GetManagementUrl", "managementUrl", GetManagementBaseUri(gov), "Function", "Function", true}
        }),
        NavTable = Table.ToNavigationTable(objects, {"Key"}, "Name", "Data", "ItemKind", "ItemName", "IsLeaf")
    in
        NavTable;

// get the management api url for each azure kind 
GetManagementBaseUri=(govKind as text) as text =>
    let
        managementUrl = if govKind ="us-government" then "https://management.usgovcloudapi.net"
                    else "https://management.azure.com"
    in
        managementUrl;

// Prepare the final url request, taking the azure kind and the request path without the domain
GetManagementUri=(govKind as text, requestPath as text)=>
    let
        managementUrl = GetManagementBaseUri(govKind),
        result = managementUrl & "/" & requestPath
    in result;

// Get all descendants using the same api than portal.azure.com
shared GetAllDescendantsPortalWay=(govKind as text) as table =>
    let
        token = GetAccessToken(),        
        headers = [ Authorization = "Bearer " & token ],
        tenantList = Json.Document(Web.Contents(GetManagementUri(govKind, "tenants?api-version=2019-11-01"), 
            [Headers=headers, 
            ManualCredentials=true])),
        value=tenantList[value],
        #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        #"ExpandedColumns" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "tenantId", "countryCode", "displayName", "domains", "tenantCategory"}, {"id", "tenantId", "countryCode", "displayName", "domains", "tenantCategory"}),
        // loop all tenants to get its management groups
        #"RetrieveTenantManagementGroups"= Table.AddColumn(#"ExpandedColumns", "ManagementGroups", each GetTenantManagementGroups(govKind, [tenantId], token))
    in
        #"RetrieveTenantManagementGroups";
// Retrieve the management groups in a tenant. it uses the same api than azure portal
GetTenantManagementGroups=(govKind, tenanId, token)=>
    let
        headers = [Authorization="Bearer " & token],
        Source = try Json.Document(Web.Contents(GetManagementUri(govKind, "providers/Microsoft.Management/getEntities?api-version=2018-03-01-preview&%24filter=name%20eq%20%27" & tenanId & "%27"), 
            [ Headers = headers, 
              ManualStatusHandling={403},
              ManualCredentials = true, 
              Content=Text.ToBinary("")])) otherwise "Error retrieving data"
    in Source;

// Get policy definitions
shared GetPolicyDefinitions = (govKind as text) as table =>
    let
        token = GetAccessToken(),        
        #"ExpandIdColumns" = GetSubscriptionsTable(govKind, token),
        // loop the subscription list to retrieve data
        #"Policies" = Table.AddColumn(#"ExpandIdColumns", "Policies", each try SubscriptionPolicyDefinitions(govKind, [subscriptionId], token)),
        #"ExpandedPolicies" = Table.ExpandRecordColumn(#"Policies", "Policies", {"HasError", "Value", "Error"}, {"HasError", "Value", "Error"}),
        #"PoliciesOk" = Table.SelectRows(#"ExpandedPolicies", each ([HasError] = false)),
        #"PoliciesNoErrorColumn" = Table.RemoveColumns(#"PoliciesOk",{"HasError", "Error"})
   in        
        #"PoliciesNoErrorColumn";

// Get the subscriptions of each policy
SubscriptionPolicyDefinitions=(govKind as text, subscriptionId as text, token as text)=>
    let
        url = GetManagementUri(govKind, "subscriptions/" & subscriptionId & "/providers/Microsoft.Authorization/policyDefinitions?api-version=2019-09-01"),
        definitions = ListAllGet(url)
    in definitions;

// Get published blueprints
shared GetPublishedBlueprints=(govKind as text) as table =>
    let
        blueprintsSanitized = GetAllBlueprintsSanitized(govKind),
        // loop subscription list to get blueprints
        blueprintArtifacts = Table.AddColumn(blueprintsSanitized, "Artifacts", each try GetSubscriptionPublishedBlueprints(govKind, [scopeId], [name])),
        #"Expanded Artifacts" = Table.ExpandRecordColumn(blueprintArtifacts, "Artifacts", {"HasError", "Error", "Value"}, {"HasError", "Error", "Value"}),
        #"Filtered Rows" = Table.SelectRows(#"Expanded Artifacts", each ([HasError] = false)),
        RemovedErrorColumns = Table.RemoveColumns(#"Filtered Rows",{"HasError", "Error"}),
        #"Expanded Value" = Table.ExpandTableColumn( RemovedErrorColumns, "Value", {"Name", "Value"}, {"Name.1", "Value.1"}),
        #"Expanded Value.1" = Table.ExpandRecordColumn(#"Expanded Value", "Value.1", {"properties", "id", "type", "name"}, {"properties.1", "id.1", "type.1", "name.2"}),
        publishedBlueprints = Table.ExpandRecordColumn(#"Expanded Value.1", "properties.1", {"blueprintName", "changeNotes", "parameters", "resourceGroups", "targetScope", "status", "displayName", "description"}, {"blueprintName", "changeNotes", "parameters", "resourceGroups", "targetScope", "status", "displayName.1", "description"})
    in publishedBlueprints;

// get published blueprints per susbscription
GetSubscriptionPublishedBlueprints=(govKind as text, scopeId as text, blueprintName as text)=>
    let
        Source = Json.Document(Web.Contents(GetManagementUri(govKind, scopeId & "/providers/Microsoft.Blueprint/blueprints/" & blueprintName & "/versions?api-version=2018-11-01-preview"))),
        value = Source[value],
        #"Converted to Table" = Record.ToTable(Source),
        #"Expanded Value" = Table.ExpandListColumn(#"Converted to Table", "Value")
    in #"Expanded Value";


// Gets the artifacts for all blueprints
shared GetBlueprintArtifacts=(govKind as text) as table =>
    let
        // gets all blueprints for which the user has permissions
        blueprintsSanitized = GetAllBlueprintsSanitized(govKind),
        // loops the blueprints to retrieve the artifacts
        blueprintArtifacts = Table.AddColumn(blueprintsSanitized, "Artifacts", each try GetArtifactsByBlueprint(govKind, [scopeId], [name])),
        // filter errors rows
        #"Expanded Artifacts" = Table.ExpandRecordColumn(blueprintArtifacts, "Artifacts", {"HasError", "Error", "Value"}, {"HasError", "Error", "Value"}),
        #"Filtered Rows" = Table.SelectRows(#"Expanded Artifacts", each ([HasError] = false)),
        #"Removed Columns" = Table.RemoveColumns(#"Filtered Rows",{"HasError", "Error"}),
        #"Expanded Value" = Table.ExpandRecordColumn(#"Removed Columns", "Value", {"value"}, {"value.1"}),
        #"Expanded value.1" = Table.ExpandListColumn(#"Expanded Value", "value.1"),
        #"Expanded value.2" = Table.ExpandRecordColumn(#"Expanded value.1", "value.1", {"properties", "kind", "id", "type", "name"}, {"properties.1", "kind", "id.1", "type.1", "name.1"})
    in #"Expanded value.2";

// gets the artifacts for a blueprint. a blueprint is identified by its subscription and the blueprint name
GetArtifactsByBlueprint=(govKind as text, scopeId as text, blueprintName as text)=>
    let
        url =GetManagementUri(govKind, scopeId & "/providers/Microsoft.Blueprint/blueprints/"&blueprintName&"/artifacts?api-version=2018-11-01-preview"),
        Source = Json.Document(Web.Contents(url))
    in Source;

// get all blueprints for all subscriptions
shared GetAllBlueprints=(govKind as text) as table =>
    let
        token= GetAccessToken(),
        subscriptions = GetSubscriptionsTable(govKind, token),
        blueprints = Table.AddColumn(subscriptions, "Blueprints", each GetSubscriptionBlueprints(govKind, [subscriptionId], token))
    in 
        blueprints;

// get all brueprints of a given subscription
GetSubscriptionBlueprints= (govKind as text, subscriptionId as text, token as text) =>
    let
        url = GetManagementUri(govKind, "subscriptions/" & subscriptionId & "/providers/Microsoft.Blueprint/blueprints?api-version=2018-11-01-preview"),
        Source = ListAllGet(url)
    in
        Source;

// try to get all blueprints, including the ones for which the user has no permissions
shared GetAllBlueprintsByScope=(govKind as text) as table =>
    let
        token= GetAccessToken(),
        descendants = GetAllDescendantsPortalWay(govKind),
        #"Expanded ManagementGroups" = Table.ExpandRecordColumn(descendants, "ManagementGroups", {"count", "value"}, {"ManagementGroups.count", "ManagementGroups.value"}),
        #"Expanded ManagementGroups.value" = Table.ExpandListColumn(#"Expanded ManagementGroups", "ManagementGroups.value"),
        #"Expanded ManagementGroups.value1" = Table.ExpandRecordColumn(#"Expanded ManagementGroups.value", "ManagementGroups.value", {"id"}, {"scopeId"}),
        #"Filtered Rows" = Table.SelectRows(#"Expanded ManagementGroups.value1", each ([scopeId] <> null)),
        #"Removed Columns2" = Table.RemoveColumns(#"Filtered Rows",{"countryCode", "Subscription Name", "domains", "tenantCategory", "ManagementGroups.count"}),
        blueprints = Table.AddColumn(#"Filtered Rows", "Blueprints", each GetScopeBlueprints(govKind, [scopeId], token))
    in 
        blueprints;

// gets the blueprints for a subscription
GetScopeBlueprints= (govKind as text, scope as text, token as text) =>
    let
        url = GetManagementUri(govKind, scope & "/providers/Microsoft.Blueprint/blueprints?api-version=2018-11-01-preview"),
        Source = ListAllGet(url)
    in
        Source;

// get all blueprints filtering the rows with errors, for instance the ones not authorized
GetAllBlueprintsSanitized= (govKind as text) as table=>
    let
        blueprints = GetAllBlueprintsByScope(govKind),

        noIdBlueprints = Table.RemoveColumns(blueprints, {"id"}),
        noErrorBlueprints = Table.RemoveRowsWithErrors(noIdBlueprints, {"Blueprints"}),
        ExpandedBlueprints = Table.ExpandTableColumn(noErrorBlueprints, "Blueprints", {"Column1"}, {"Column1"}),
        ExpandedColumn1 = Table.ExpandListColumn(ExpandedBlueprints, "Column1"),
        sanitizedBluebrints = Table.ExpandRecordColumn(ExpandedColumn1, "Column1", {"properties", "id", "type", "name"}, {"properties", "id", "type", "name"}),
        unnecessaryColumnsRemoved = Table.RemoveColumns(sanitizedBluebrints,{"countryCode", "domains", "tenantCategory", "ManagementGroups.count"})
    in unnecessaryColumnsRemoved;

// get all resources for all subscription for which the user has permissions
shared GetAllResources=(govKind as text) as table=>
    let
        token = GetAccessToken(),        
        // get all subscriptios
        #"ExpandIdColumns" = GetSubscriptionsTable(govKind, token),
        // loop the subscription to retrieve all resources
        #"allResources"=Table.AddColumn(#"ExpandIdColumns", "Resources", each try GetAllSubscriptionResources(govKind, [subscriptionId], token)),
        #"ExpandedResources" = Table.ExpandRecordColumn(#"allResources", "Resources", {"HasError", "Value"}, {"HasError", "Value"}),
        #"ResourcesOk" = Table.SelectRows(#"ExpandedResources", each ([HasError] = false)),
        #"ResourcesNoErrorColumn" = Table.RemoveColumns(#"ResourcesOk",{"HasError"}),
        #"ExpandedValue" = Table.ExpandTableColumn(#"ResourcesNoErrorColumn", "Value", {"Column1"}, {"ExpandedResourcesColumn"}),
        #"TableWithResources" = Table.ExpandListColumn(#"ExpandedValue", "ExpandedResourcesColumn")
     in
         #"TableWithResources";

// get the resources of a subscription, following pages if necessary
GetAllSubscriptionResources=(govKind as text, subscriptionId, token)=>
    let
        url = GetManagementUri(govKind, "subscriptions/"&subscriptionId&"/resources?api-version=2019-05-01"),        
        allSubscriptionResources=ListAllGet(url)
    in 
        allSubscriptionResources;

// Retrieves all policies for all subscriptions where the user has permissions
shared GetPoliciesTable = (govKind as text) as table =>
    let
        token = GetAccessToken(),        
        // get all user subscriptions
        #"ExpandIdColumns" = GetSubscriptionsTable(govKind, token),
        // loop all subscriptions to retrieve their policies
        #"Policies" = Table.AddColumn(#"ExpandIdColumns", "Policies", each try Policies(govKind, [subscriptionId], token)),
        // Filter errors
        #"ExpandedPolicies" = Table.ExpandRecordColumn(#"Policies", "Policies", {"HasError", "Value", "Error"}, {"HasError", "Value", "Error"}),
        #"PoliciesOk" = Table.SelectRows(#"ExpandedPolicies", each ([HasError] = false)),
        #"PoliciesNoErrorColumn" = Table.RemoveColumns(#"PoliciesOk",{"HasError", "Error"})
   in        
        #"PoliciesNoErrorColumn";

// Retrieve all policies for a subscription
Policies = (govKind, subscriptionId, token) =>
    let
        url = GetManagementUri(govKind, "subscriptions/"&subscriptionId&"/providers/Microsoft.PolicyInsights/policyStates/default/queryResults?api-version=2019-10-01"),
        // retrieve all policies, following continuation pages if needed
        #"PoliciesTable"= ListAllPost(url, token)
    in        
        #"PoliciesTable";

// HELPER FUNCTIONS

// get subscriptios for a given user in table format
shared GetSubscriptionsTable=(govKind as text, token as text) as table=>
    let
        subscriptionsUri = GetManagementUri(govKind, "subscriptions?api-version=2019-11-01"),
        sl =ListAllGet(subscriptionsUri),
        slExpanded = Table.ExpandListColumn(sl, "Column1"),
        ExpandIdColumns = Table.ExpandRecordColumn(slExpanded, "Column1", {"subscriptionId", "displayName"}, {"subscriptionId", "displayName"})
    in
        ExpandIdColumns;




// Connector methods needed for proper PowerBI integration

// Data Source Kind description
CcoDashboardAzureConnector = [
    // enable OAuth auth
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
        StartLoginResult = if Text.Contains(resourceUrl,"us-government")=true 
            then StartLoginUsGov(resourceUrl, state, display)
            else StartLoginGlobal(resourceUrl, state, display)
    in
        StartLoginResult;

// login for azure global
 StartLoginGlobal=(resourceUrl, state, display)=>
        let
        OAuthBaseUrl = "https://login.windows.net/common/oauth2",
        managementUrl = "https://management.azure.com",
        AuthorizeUrl = OAuthBaseUrl & "/authorize?" & Uri.BuildQueryString([
            client_id = client_id_global,
//             resource=resourceUrl,
            resource= managementUrl,
            response_type = "code",
            response_mode= "query",
            prompt="login",
            state = state,
            nonce= "nonce", // make it random
            redirect_uri = redirect_uri_global])
    in
        [
            LoginUri = AuthorizeUrl,
            CallbackUri = redirect_uri_global,
            WindowHeight = windowHeight,
            WindowWidth = windowWidth,
            Context = null
        ];

// login for azure us government
StartLoginUsGov=(resourceUrl, state, display)=>
    let
        OAuthBaseUrl = "https://login.microsoftonline.us/common/oauth2" ,
        managementUrl = "https://management.usgovcloudapi.net/",
        clientId=client_id_gov,
        redirectUri=redirect_uri_gov,
        AuthorizeUrl = OAuthBaseUrl & "/authorize?" & Uri.BuildQueryString([
            client_id = client_id_gov,
            resource= managementUrl,            
            response_type = "code",
            response_mode= "query",
            prompt="login",
            state = state,
            nonce= "nonce", // make it random
            redirect_uri = redirect_uri_gov])
    in
        [
            LoginUri = AuthorizeUrl,
            CallbackUri = redirect_uri_gov,
            WindowHeight = windowHeight,
            WindowWidth = windowWidth,
            Context = null
        ];

// complete the login process
FinishLogin = (context, callbackUri, state) =>
    let
        Parts = Uri.Parts(callbackUri)[Query],
        FinishLoginResult =  if Text.Contains(context,"us-government")=true then 
                                TokenMethodUsGov(Parts[code], "authorization_code")
                             else TokenMethodGlobal(Parts[code], "authorization_code")
    in
        FinishLoginResult;

// Get access token for azure global
TokenMethodGlobal = (code, grant_type) =>
    let
        OAuthBaseUrl = "https://login.windows.net/common/oauth2",
        Response = Web.Contents(OAuthBaseUrl & "/token", [
            Content = Text.ToBinary(Uri.BuildQueryString([
                client_id = client_id_global,
                code = code,
                grant_type = grant_type,
                redirect_uri = redirect_uri_global])),
            Headers=[#"Content-type" = "application/x-www-form-urlencoded",#"Accept" = "application/json"]]),
        Parts = Json.Document(Response)
    in
        Parts;
// Get access token for azure us government
TokenMethodUsGov = (code, grant_type) =>
    let
        OAuthBaseUrl = "https://login.microsoftonline.us/common/oauth2/",
        Response = Web.Contents(OAuthBaseUrl & "/token", [
            Content = Text.ToBinary(Uri.BuildQueryString([
                client_id = client_id_gov,
                code = code,
                grant_type = grant_type,
                redirect_uri = redirect_uri_gov])),
            Headers=[#"Content-type" = "application/x-www-form-urlencoded",#"Accept" = "application/json"]]),
        Parts = Json.Document(Response)
    in
        Parts;

// refresh token
Refresh = (resourceUrl, refresh_token) => 
    if Text.Contains(resourceUrl,"us-government")=true then 
         TokenMethodUsGov(refresh_token, "refresh_token") 
    else TokenMethodGlobal(refresh_token, "refresh_token");


// Common library code
shared GetAccessToken = () =>
let
    credential = Extension.CurrentCredential(),
        token = credential[access_token]
     in
         token;

// helper method that implements paging continuation implemented in azure management APIs with GET web method
// when there are more result it returns nextLink, this methods invokes the management api when nextLink is informed
ListAllGet = (url as text) =>
let
    // child method that returns a page and is invoke while there are results by its parent method (ListAllGet)
    FuncGetOnePage = (url) as record =>
    let 
       Source = Json.Document(Web.Contents(url)),
       data = try Source[value] otherwise null,
       next = try Source[nextLink] otherwise null,
       res = [Data=data, Next=next]
    in
        res,
    // loop while there are results
    GeneratedListOfPages = List.Generate(()=>[res = FuncGetOnePage(url)], //initializer
        each [res][Data]<>null, // continuation condition, while there is data
        each [res = FuncGetOnePage([res][Next])], // next
        each [res][Data]), // selector
    // generates the table with all pages
    #"Converted to Table" = Table.FromList(GeneratedListOfPages, Splitter.SplitByNothing(), null, null, ExtraValues.Error)
    in #"Converted to Table";

// helper method that implements paging continuation implemented in azure management APIs with POST web method
// when there are more result it returns nextLink, this methods invokes the management api when nextLink is informed
ListAllPost = (url as text, token as text) =>
let
    // child method that returns a page, using post method
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
    // loop while there are more pages
    GeneratedListOfPages = List.Generate(()=>[res = FuncPostOnePage(url, token)],
        each [res][Data]<>null,
        each [res = FuncPostOnePage([res][Next], token)],
        each [res][Data]),

    #"Converted to Table" = Table.FromList(GeneratedListOfPages, Splitter.SplitByNothing(), null, null, ExtraValues.Error)
    in #"Converted to Table";


// method to prepare a navigation table
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

// 
// Load common library functions
// 
Extension.LoadFunction = (name as text) =>
    let
        binary = Extension.Contents(name),
        asText = Text.FromBinary(binary)
    in
        Expression.Evaluate(asText, #shared);