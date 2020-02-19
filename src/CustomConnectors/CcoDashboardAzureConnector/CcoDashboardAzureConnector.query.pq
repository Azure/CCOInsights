// Use this file to write queries to test your data connector
let
    result = CcoDashboardAzureConnector.Management(){[Key="blueprintartifact"]}[Data]
in
    result

// let descendants = GetAllDescendants() in descendants