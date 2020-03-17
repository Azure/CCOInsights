// Use this file to write queries to test your data connector
let
    result = CcoDashboardAzureConnector.Management(){[Key="batchjson"]}[Data]
in
    result

// let descendants = GetAllDescendants() in descendants