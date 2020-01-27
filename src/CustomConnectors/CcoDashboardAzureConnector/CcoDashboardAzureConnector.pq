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
shared CcoDashboardAzureConnector.Contents = () =>
        let
        credential = Extension.CurrentCredential(),
        token = if (credential[AuthenticationKind] = "Key") then credential[Key] else credential[access_token],        
        headers = [ Authorization = "Bearer " & token ],
        subscriptionList = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2019-11-01", [ Headers = headers, ManualCredentials = true])),
        value=subscriptionList[value],
        #"ConvertSubscriptionListToTable" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        #"ExpandIdColumns" = Table.ExpandRecordColumn(#"ConvertSubscriptionListToTable", "Column1", {"subscriptionId", "displayName"}, {"subscriptionId", "displayName"}),    
        // loop the subscription list to retrieve data
        #"Policies" = Table.AddColumn(#"ExpandIdColumns", "Policies", each try Policies([subscriptionId], token))
   in        
        #"Policies";

Policies = (subscriptionId, token) =>
        let
        headers = [ Authorization = "Bearer " & token ],
        policies = try Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.PolicyInsights/policyStates/latest/summarize?api-version=2019-10-01", 
            [ Headers = headers, 
              ManualCredentials = true, 
              ManualStatusHandling={403},
              Content=Text.ToBinary("") ])) otherwise "Cannot retrieve",
        value=policies[value],
        #"ConvertSubscriptionListToTable" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error)

    in        
        #"ConvertSubscriptionListToTable";

// Helper methods
// UserSubscriptions = () =>
//     let
//         credential = Extension.CurrentCredential(),
//         token = if (credential[AuthenticationKind] = "Key") then credential[Key] else credential[access_token],        
//         headers = [ Authorization = "Bearer " & token ],
//         subscriptionList = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2019-11-01", [ Headers = headers, ManualCredentials = true]))
//     in        
//         subscriptionList;


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
    LearnMoreUrl = "https://github.com/Azure/ccodashboard"
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
            nonce= "pepe",
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



    