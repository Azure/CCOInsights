// ListRBACRoleAssignments
let ListRBACRoleAssignments = (subscriptionId as text) =>
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.Authorization/roleAssignments?api-version=2015-07-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"properties", "id", "type", "name"}, {"properties", "id", "type", "name"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column1", "properties", {"roleDefinitionId", "principalId", "scope", "createdOn", "updatedOn", "createdBy", "updatedBy"}, {"roleDefinitionId", "principalId", "scope", "createdOn", "updatedOn", "createdBy", "updatedBy"})
in
    #"Expanded properties"

in
    ListRBACRoleAssignments

// RBAC Role Definitions
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId","displayName"}, {"Column1.subscriptionId","Column1.displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"Column1.subscriptionId", "SubscriptionId"}}),
    #"List RBACRoleDefinitions" = Table.AddColumn(#"Renamed Columns", "ListRBACRoleDefinitions", each ListRBACRoleDefinitions([SubscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"List RBACRoleDefinitions", {"ListRBACRoleDefinitions"}),
    #"Expanded ListRBACRoleDefinitions" = Table.ExpandTableColumn(#"Removed Errors", "ListRBACRoleDefinitions", {"roleName", "type.1", "description", "assignableScopes", "actions", "notActions", "createdOn", "updatedOn", "createdBy", "updatedBy", "id", "type", "name"}, {"roleName", "type.1", "description", "assignableScopes", "actions", "notActions", "createdOn", "updatedOn", "createdBy", "updatedBy", "id", "type", "name"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded ListRBACRoleDefinitions",{{"type.1", "roleType"}, {"Column1.displayName", "Subscription Name"}, {"id", "roleDefinitionId"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns1",{"type"})
in
    #"Removed Columns"

// ListRBACRoleDefinitions
let ListRBACRoleDefinitions = (subscriptionId as text) =>
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.Authorization/roleDefinitions?api-version=2015-07-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"properties", "id", "type", "name"}, {"properties", "id", "type", "name"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column1", "properties", {"roleName", "type", "description", "assignableScopes", "permissions", "createdOn", "updatedOn", "createdBy", "updatedBy"}, {"roleName", "type.1", "description", "assignableScopes", "permissions", "createdOn", "updatedOn", "createdBy", "updatedBy"}),
    #"Extracted Values" = Table.TransformColumns(#"Expanded properties", {"assignableScopes", each Text.Combine(List.Transform(_, Text.From)), type text}),
    #"Expanded permissions" = Table.ExpandListColumn(#"Extracted Values", "permissions"),
    #"Expanded permissions1" = Table.ExpandRecordColumn(#"Expanded permissions", "permissions", {"actions", "notActions"}, {"actions", "notActions"}),
    #"Extracted Values1" = Table.TransformColumns(#"Expanded permissions1", {"actions", each Text.Combine(List.Transform(_, Text.From)), type text}),
    #"Extracted Values2" = Table.TransformColumns(#"Extracted Values1", {"notActions", each Text.Combine(List.Transform(_, Text.From)), type text})
in
    #"Extracted Values2"
in
    ListRBACRoleDefinitions

// RBAC Role Users
// RBAC Role Assignments
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId","displayName"}, {"Column1.subscriptionId","Column1.displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"Column1.subscriptionId", "SubscriptionId"}}),
    #"List RBACRoleAssignments" = Table.AddColumn(#"Renamed Columns", "ListRBACRoleAssignments", each ListRBACRoleAssignments([SubscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"List RBACRoleAssignments", {"ListRBACRoleAssignments"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Errors",{{"Column1.displayName", "Subscription Name"}}),
    #"Expanded ListRBACRoleAssignments" = Table.ExpandTableColumn(#"Renamed Columns1", "ListRBACRoleAssignments", {"roleDefinitionId", "principalId", "scope", "createdOn", "updatedOn", "createdBy", "updatedBy", "id", "type", "name"}, {"roleDefinitionId", "principalId", "scope", "createdOn", "updatedOn", "createdBy", "updatedBy", "id", "type", "name"}),
    #"Split Column by Delimiter1" = Table.SplitColumn(#"Expanded ListRBACRoleAssignments", "scope", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"scope.1", "scope.2", "scope.3", "scope.4", "scope.5", "scope.6", "scope.7", "scope.8", "scope.9", "scope.10", "scope.11"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Split Column by Delimiter1",{{"scope.5", "Resource Group"}, {"scope.7", "Resource Provider"}, {"scope.8", "Resource Type"}, {"scope.9", "Resource Name"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns2",{"scope.1", "scope.2", "scope.3", "scope.4", "scope.6"}),
    #"Replaced Value" = Table.ReplaceValue(#"Removed Columns",null,"*",Replacer.ReplaceValue,{"Resource Group"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value",null,"*",Replacer.ReplaceValue,{"Resource Provider"}),
    #"Added Conditional Column" = Table.AddColumn(#"Replaced Value1", "Custom", each if [Resource Group] = "*" then "Subscription" else if [Resource Provider] = "*" then "Resource Group" else if [Resource Type] <> null then [Resource Type] else null),
    #"Renamed Columns3" = Table.RenameColumns(#"Added Conditional Column",{{"Resource Type", "Rtype"}, {"Custom", "Resource Type"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns3", "Users", each ListRBACUsers([principalId])),
    #"Removed Errors1" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"Users"}),
    #"Expanded Users" = Table.ExpandTableColumn(#"Removed Errors1", "Users", {"odata.type", "objectType", "objectId", "deletionTimestamp", "accountEnabled", "ageGroup", "city", "companyName", "consentProvidedForMinor", "country", "creationType", "department", "dirSyncEnabled", "displayName", "employeeId", "facsimileTelephoneNumber", "givenName", "immutableId", "isCompromised", "jobTitle", "lastDirSyncTime", "legalAgeGroupClassification", "mail", "mailNickname", "mobile", "onPremisesDistinguishedName", "onPremisesSecurityIdentifier", "passwordPolicies", "passwordProfile", "physicalDeliveryOfficeName", "postalCode", "preferredLanguage", "refreshTokensValidFromDateTime", "showInAddressList", "sipProxyAddress", "state", "streetAddress", "surname", "telephoneNumber", "thumbnailPhoto@odata.mediaContentType", "usageLocation", "userPrincipalName", "userType", "extension_18e31482d3fb4a8ea958aa96b662f508_SupervisorInd", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingName", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingID", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToPersonnelNbr", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToFullName", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToEmailName", "extension_18e31482d3fb4a8ea958aa96b662f508_CompanyCode", "extension_18e31482d3fb4a8ea958aa96b662f508_CostCenterCode", "extension_18e31482d3fb4a8ea958aa96b662f508_LocationAreaCode", "extension_18e31482d3fb4a8ea958aa96b662f508_PersonnelNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_PositionNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_ProfitCenterCode"}, {"odata.type", "objectType", "objectId", "deletionTimestamp", "accountEnabled", "ageGroup", "city", "companyName", "consentProvidedForMinor", "country", "creationType", "department", "dirSyncEnabled", "displayName", "employeeId", "facsimileTelephoneNumber", "givenName", "immutableId", "isCompromised", "jobTitle", "lastDirSyncTime", "legalAgeGroupClassification", "mail", "mailNickname", "mobile", "onPremisesDistinguishedName", "onPremisesSecurityIdentifier", "passwordPolicies", "passwordProfile", "physicalDeliveryOfficeName", "postalCode", "preferredLanguage", "refreshTokensValidFromDateTime", "showInAddressList", "sipProxyAddress", "state", "streetAddress", "surname", "telephoneNumber", "thumbnailPhoto@odata.mediaContentType", "usageLocation", "userPrincipalName", "userType", "extension_18e31482d3fb4a8ea958aa96b662f508_SupervisorInd", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingName", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingID", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToPersonnelNbr", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToFullName", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToEmailName", "extension_18e31482d3fb4a8ea958aa96b662f508_CompanyCode", "extension_18e31482d3fb4a8ea958aa96b662f508_CostCenterCode", "extension_18e31482d3fb4a8ea958aa96b662f508_LocationAreaCode", "extension_18e31482d3fb4a8ea958aa96b662f508_PersonnelNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_PositionNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_ProfitCenterCode"})
in
    #"Expanded Users"

// TenantName
"repsol.com" meta [IsParameterQuery=true, Type="Text", IsParameterQueryRequired=true]

// ListRBACUsers
let ListRBACUsers = (principalId as text) =>
let
    Source = Json.Document(Web.Contents("https://graph.windows.net/"&TenantName&"/users?api-version=1.6&$filter=objectId eq '"&principalId&"'")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"odata.type", "objectType", "objectId", "deletionTimestamp", "accountEnabled", "ageGroup", "assignedLicenses", "assignedPlans", "city", "companyName", "consentProvidedForMinor", "country", "creationType", "department", "dirSyncEnabled", "displayName", "employeeId", "facsimileTelephoneNumber", "givenName", "immutableId", "isCompromised", "jobTitle", "lastDirSyncTime", "legalAgeGroupClassification", "mail", "mailNickname", "mobile", "onPremisesDistinguishedName", "onPremisesSecurityIdentifier", "otherMails", "passwordPolicies", "passwordProfile", "physicalDeliveryOfficeName", "postalCode", "preferredLanguage", "provisionedPlans", "provisioningErrors", "proxyAddresses", "refreshTokensValidFromDateTime", "showInAddressList", "signInNames", "sipProxyAddress", "state", "streetAddress", "surname", "telephoneNumber", "thumbnailPhoto@odata.mediaContentType", "usageLocation", "userIdentities", "userPrincipalName", "userType", "extension_18e31482d3fb4a8ea958aa96b662f508_SupervisorInd", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingName", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingID", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToPersonnelNbr", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToFullName", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToEmailName", "extension_18e31482d3fb4a8ea958aa96b662f508_CompanyCode", "extension_18e31482d3fb4a8ea958aa96b662f508_CostCenterCode", "extension_18e31482d3fb4a8ea958aa96b662f508_LocationAreaCode", "extension_18e31482d3fb4a8ea958aa96b662f508_PersonnelNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_PositionNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_ProfitCenterCode"}, {"odata.type", "objectType", "objectId", "deletionTimestamp", "accountEnabled", "ageGroup", "assignedLicenses", "assignedPlans", "city", "companyName", "consentProvidedForMinor", "country", "creationType", "department", "dirSyncEnabled", "displayName", "employeeId", "facsimileTelephoneNumber", "givenName", "immutableId", "isCompromised", "jobTitle", "lastDirSyncTime", "legalAgeGroupClassification", "mail", "mailNickname", "mobile", "onPremisesDistinguishedName", "onPremisesSecurityIdentifier", "otherMails", "passwordPolicies", "passwordProfile", "physicalDeliveryOfficeName", "postalCode", "preferredLanguage", "provisionedPlans", "provisioningErrors", "proxyAddresses", "refreshTokensValidFromDateTime", "showInAddressList", "signInNames", "sipProxyAddress", "state", "streetAddress", "surname", "telephoneNumber", "thumbnailPhoto@odata.mediaContentType", "usageLocation", "userIdentities", "userPrincipalName", "userType", "extension_18e31482d3fb4a8ea958aa96b662f508_SupervisorInd", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingName", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingID", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToPersonnelNbr", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToFullName", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToEmailName", "extension_18e31482d3fb4a8ea958aa96b662f508_CompanyCode", "extension_18e31482d3fb4a8ea958aa96b662f508_CostCenterCode", "extension_18e31482d3fb4a8ea958aa96b662f508_LocationAreaCode", "extension_18e31482d3fb4a8ea958aa96b662f508_PersonnelNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_PositionNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_ProfitCenterCode"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded Column1",{"assignedLicenses", "assignedPlans", "otherMails", "provisionedPlans", "provisioningErrors", "proxyAddresses", "signInNames", "userIdentities"})
in
    #"Removed Columns"
in
    ListRBACUsers