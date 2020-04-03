// This file contains your Data Connector logic
section PostConnector;

windowWidth = 800;
windowHeight = 800;

// TODO: ASK FOR THIS INFORMATION AS A CONNECTOR PARAMETER
client_id = Text.FromBinary(Extension.Contents("client_id"));
redirect_uri = "https://de-users-preview.sqlazurelabs.com/account/reply/";
OAuthBaseUrl = "https://login.windows.net/common/oauth2";
resource = "https://management.azure.com";


[DataSource.Kind="PostConnector", Publish="PostConnector.Publish"]
shared PostConnector.Contents = (url as text, optional content as text) =>
    let
        token=GetAccessToken (),
        headers = GetAuthorizationHeader(token),
        postResults = Json.Document(Web.Contents(url, 
            [ Headers = headers,
               ManualCredentials = true, 
                      ManualStatusHandling={403}, 
                      Content=Text.ToBinary(if content<> null then content else "")]))
    in
        postResults;

// Data Source Kind description
PostConnector = [
    // enable both OAuth
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
PostConnector.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = PostConnector.Icons,
    SourceTypeImage = PostConnector.Icons
];

PostConnector.Icons = [
    Icon16 = { Extension.Contents("PostConnector16.png"), Extension.Contents("PostConnector20.png"), Extension.Contents("PostConnector24.png"), Extension.Contents("PostConnector32.png") },
    Icon32 = { Extension.Contents("PostConnector32.png"), Extension.Contents("PostConnector40.png"), Extension.Contents("PostConnector48.png"), Extension.Contents("PostConnector64.png") }
];

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

//
// OAuth2 flow definition
//

StartLogin = (resourceUrl, state, display) =>
    let
        AuthorizeUrl = OAuthBaseUrl & "/authorize?" & Uri.BuildQueryString([
            client_id = client_id,
            resource= resource,
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