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
            {"All descendants",   "alldescendants",      GetAllDescendants(),  "Table",    "Table",    true},   
            {"Descendants portal way",   "alldescendantstrick",      GetAllDescendantsPortalWay(),  "Table",    "Table",    true},   
            {"MakeAPost", "makeapost", HelperFunctions.MakeAPost(),       "Function", "Function", true},
            {"MakeACost", "makeacost", HelperFunctions.MakeACost(),       "Function", "Function", true}
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
        credential = Extension.CurrentCredential(),
        token = if (credential[AuthenticationKind] = "Key") then credential[Key] else credential[access_token],        
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
     // GET https://management.azure.com/providers/Microsoft.Management/managementGroups/felipmg/descendants?api-version=2018-03-01-preview
    Source = try Json.Document(Web.Contents("https://management.azure.com/providers/Microsoft.Management/managementGroups/"&MgId&"/descendants?api-version=2019-11-01",
        [Headers=headers, 
        ManualCredentials = true, 
        ManualStatusHandling={403}])) otherwise "Seems you don't have permissions to get management group "&MgId,
    value = Source[value]
    
//     #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
//     #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"name", "id", "type", "properties"}, {"name", "id", "type", "properties"}),
//     #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column1", "properties", {"displayName", "parent"}, {"displayName", "parent"}),
//     #"Expanded parent" = Table.ExpandRecordColumn(#"Expanded properties", "parent", {"id"}, {"id.1"}),
//     #"Renamed Columns" = Table.RenameColumns(#"Expanded parent",{{"id.1", "Parent Id"}})
in
    value;


GetPoliciesTable = () as table =>
let
        credential = Extension.CurrentCredential(),
        token = if (credential[AuthenticationKind] = "Key") then credential[Key] else credential[access_token],        
        headers = [ Authorization = "Bearer " & token ],
        subscriptionList = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2019-11-01", [ Headers = headers, ManualCredentials = true])),
        value=subscriptionList[value],
        #"ConvertSubscriptionListToTable" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        #"ExpandIdColumns" = Table.ExpandRecordColumn(#"ConvertSubscriptionListToTable", "Column1", {"subscriptionId", "displayName"}, {"subscriptionId", "displayName"}),    
        // loop the subscription list to retrieve data
        #"Policies" = Table.AddColumn(#"ExpandIdColumns", "Policies", each try Policies([subscriptionId], token)),
        #"ExpandedPolicies" = Table.ExpandRecordColumn(#"Policies", "Policies", {"HasError", "Value", "Error"}, {"HasError", "Value", "Error"}),
        #"PoliciesOk" = Table.SelectRows(#"ExpandedPolicies", each ([HasError] = false)),
        #"PoliciesNoErrorColumn" = Table.RemoveColumns(#"PoliciesOk",{"HasError", "Error"})
   in        
        #"PoliciesNoErrorColumn";

// published helper functions

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

Policies = (subscriptionId, token) =>
        let
        headers = [ Authorization = "Bearer " & token ],
        policies = try Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.PolicyInsights/policyStates/default/queryResults?api-version=2019-10-01", 
            [ Headers = headers, 
              ManualCredentials = true, 
              ManualStatusHandling={403},
              Content=Text.ToBinary("") ])) otherwise "Cannot retrieve",
        value=policies[value],
        #"ConvertSubscriptionListToTable" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error)

    in        
        #"ConvertSubscriptionListToTable";

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
            state = state,
            nonce= "pepe", // make it randon
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
//                 client_secret = client_secret,
                code = code,
                grant_type = grant_type,
                redirect_uri = redirect_uri])),
            Headers=[#"Content-type" = "application/x-www-form-urlencoded",#"Accept" = "application/json"]]),
        Parts = Json.Document(Response)
    in
        Parts;

Refresh = (resourceUrl, refresh_token) => TokenMethod(refresh_token, "refresh_token");


// Common library code

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