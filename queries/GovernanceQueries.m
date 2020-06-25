// All Subscriptions
let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
     Fullset = GetPages(GetManagementURL(AzureKind)&"/subscriptions?api-version=2020-01-01"),
     #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
     #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "authorizationSource", "managedByTenants", "subscriptionId", "tenantId", "displayName", "state", "subscriptionPolicies", "tags"}, {"id", "authorizationSource", "managedByTenants", "subscriptionId", "tenantId", "displayName", "state", "subscriptionPolicies", "tags"}),
     #"Removed Columns" = Table.RemoveColumns(#"Expanded Column1",{"managedByTenants"}),
     #"Expanded subscriptionPolicies" = Table.ExpandRecordColumn(#"Removed Columns", "subscriptionPolicies", {"locationPlacementId", "quotaId", "spendingLimit"}, {"locationPlacementId", "quotaId", "spendingLimit"}),
     #"Renamed Columns" = Table.RenameColumns(#"Expanded subscriptionPolicies",{{"displayName", "Subscription Name"}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Renamed Columns",{"tags"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns1",{{"id", "Subscription Resource Id"}})
in
    #"Renamed Columns1"

// GetManagementURL
let GetManagementBaseUri=(govKind as text) as text =>
    let
        managementUrl = if govKind ="us-government" then "https://management.usgovcloudapi.net"
                    else if govKind="germany-government" then""
                    else if govKind = "china" then ""
                    else "https://management.azure.com"

    in
        managementUrl

in GetManagementBaseUri

// AzureKind
"global" meta [IsParameterQuery=true, List={"us-government", "global"}, DefaultValue="global", Type="Text", IsParameterQueryRequired=true]

// SecureScoreControls_F
let
    Source = #"All Subscriptions",
    #"Removed Columns" = Table.RemoveColumns(Source,{"authorizationSource", "state", "locationPlacementId", "quotaId", "spendingLimit"}),
    #"Reordered Columns" = Table.ReorderColumns(#"Removed Columns",{"tenantId", "Subscription Name", "subscriptionId"}),
    #"Invoked Custom Function" = Table.AddColumn(#"Reordered Columns", "SecuirtyScoreControls", each SecureScoreControls([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"SecuirtyScoreControls"}),
    #"Expanded SecuirtyScoreControls" = Table.ExpandTableColumn(#"Removed Errors", "SecuirtyScoreControls", {"id", "name", "displayName", "score.max", "score.current", "healthyResourceCount", "unhealthyResourceCount", "notApplicableResourceCount"}, {"id", "name", "displayName", "score.max", "score.current", "healthyResourceCount", "unhealthyResourceCount", "notApplicableResourceCount"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded SecuirtyScoreControls",{{"id", "SecureControl Id"}, {"name", "SecureControl Name"}, {"displayName", "SecureControl Display Name"}})
in
    #"Renamed Columns"

// SecureScoreControls
let ListSecureScoreControls= (SubscriptionId as text) =>
let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
     Fullset = GetPages(GetManagementURL(AzureKind)&"/subscriptions/"&SubscriptionId&"/providers/Microsoft.Security/SecureScoreControls?api-version=2020-01-01-preview"),
     #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "name", "type", "properties"}, {"id", "name", "type", "properties"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column1", "properties", {"displayName", "score", "healthyResourceCount", "unhealthyResourceCount", "notApplicableResourceCount"}, {"displayName", "score", "healthyResourceCount", "unhealthyResourceCount", "notApplicableResourceCount"}),
    #"Expanded score" = Table.ExpandRecordColumn(#"Expanded properties", "score", {"max", "current"}, {"score.max", "score.current"})
in
    #"Expanded score"
in ListSecureScoreControls

// SecureScore
let
    Source = SecureScoreControls_F
in
    Source

// SecureScoreControlsDefinitions
let ListSecureScoreControlsDefinitions = (SubscriptionId as text) => 

let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
     Fullset = GetPages(GetManagementURL(AzureKind)&"/subscriptions/"&SubscriptionId&"/providers/Microsoft.Security/SecureScoreControlDefinitions?api-version=2020-01-01-preview"),
     #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "name", "type", "properties"}, {"id", "name", "type", "properties"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column1", "properties", {"displayName", "maxScore", "source", "assessmentsDefinition"}, {"displayName", "maxScore", "source", "assessmentsDefinition"}),
    #"Expanded source" = Table.ExpandRecordColumn(#"Expanded properties", "source", {"sourceType"}, {"sourceType"}),
    #"Expanded assessmentsDefinition" = Table.ExpandListColumn(#"Expanded source", "assessmentsDefinition")
in
    #"Expanded assessmentsDefinition"

in
ListSecureScoreControlsDefinitions

// SecureScoreControlDefinitions_F
let
    Source = #"All Subscriptions",
    #"Removed Columns" = Table.RemoveColumns(Source,{"authorizationSource", "state", "locationPlacementId", "quotaId", "spendingLimit"}),
    #"Reordered Columns" = Table.ReorderColumns(#"Removed Columns",{"tenantId", "Subscription Name", "subscriptionId"}),
    #"Invoked Custom Function" = Table.AddColumn(#"Reordered Columns", "SecureScoreControlDefinitions", each SecureScoreControlsDefinitions([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"SecureScoreControlDefinitions"}),
    #"Expanded SecureScoreControlDefinitions" = Table.ExpandTableColumn(#"Removed Errors", "SecureScoreControlDefinitions", {"id", "name", "displayName", "maxScore", "sourceType", "assessmentsDefinition"}, {"SecureScoreControlDefinitions.id", "SecureScoreControlDefinitions.name", "SecureScoreControlDefinitions.displayName", "SecureScoreControlDefinitions.maxScore", "SecureScoreControlDefinitions.sourceType", "SecureScoreControlDefinitions.assessmentsDefinition"}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Expanded SecureScoreControlDefinitions", "SecureScoreControlDefinitions.id", Splitter.SplitTextByDelimiter("/providers", QuoteStyle.Csv), {"SecureScoreControlDefinitions.id.1", "SecureScoreControlDefinitions.id.2"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"SecureScoreControlDefinitions.id.1", type text}, {"SecureScoreControlDefinitions.id.2", type text}}),
    #"Removed Columns2" = Table.RemoveColumns(#"Changed Type",{"SecureScoreControlDefinitions.id.1"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns2",{{"SecureScoreControlDefinitions.id.2", "SecureScoreControlDefinitions.id"}}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Renamed Columns",{{"SecureScoreControlDefinitions.maxScore", type number}}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Changed Type1", "SecureScoreControlDefinitions.assessmentsDefinition", "SecureScoreControlDefinitions.assessmentsDefinition - Copy"),
    #"Split Column by Delimiter1" = Table.SplitColumn(#"Duplicated Column", "SecureScoreControlDefinitions.assessmentsDefinition - Copy", Splitter.SplitTextByEachDelimiter({"/"}, QuoteStyle.Csv, true), {"SecureScoreControlDefinitions.assessmentsDefinition - Copy.1", "SecureScoreControlDefinitions.assessmentsDefinition - Copy.2"}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Split Column by Delimiter1",{{"SecureScoreControlDefinitions.assessmentsDefinition - Copy.1", type text}, {"SecureScoreControlDefinitions.assessmentsDefinition - Copy.2", type text}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Changed Type2",{"SecureScoreControlDefinitions.assessmentsDefinition - Copy.1"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns1",{{"SecureScoreControlDefinitions.assessmentsDefinition - Copy.2", "Assesstment name"}}),
    #"Removed Duplicates" = Table.Distinct(#"Renamed Columns1", {"SecureScoreControlDefinitions.assessmentsDefinition"}),
    #"Removed Columns3" = Table.RemoveColumns(#"Removed Duplicates",{"tenantId", "Subscription Name", "subscriptionId"})
in
    #"Removed Columns3"

// CC Applied Policies
let
    Source = CcoDashboardAzureConnector.Management(AzureKind),
    policies = Source{[Key="policies"]}[Data],
    #"Expanded Value" = Table.ExpandTableColumn(policies, "Value", {"Column1"}, {"Column1"}),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Expanded Value", {"Column1"}),
    #"Expanded Column1" = Table.ExpandListColumn(#"Removed Errors", "Column1"),
    #"Expanded Column3" = Table.ExpandRecordColumn(#"Expanded Column1", "Column1", {"timestamp", "resourceId", "policyAssignmentId", "policyDefinitionId", "effectiveParameters", "isCompliant", "resourceType", "resourceLocation", "resourceGroup", "policyAssignmentName", "policyAssignmentOwner", "policyAssignmentParameters", "policyAssignmentScope", "policyDefinitionName", "policyDefinitionAction", "policyDefinitionCategory", "policySetDefinitionId", "policySetDefinitionName", "policySetDefinitionOwner", "policySetDefinitionCategory", "policySetDefinitionParameters", "managementGroupIds", "policyDefinitionReferenceId", "complianceState"}, {"timestamp", "resourceId", "policyAssignmentId", "policyDefinitionId", "effectiveParameters", "isCompliant", "resourceType", "resourceLocation", "resourceGroup", "policyAssignmentName", "policyAssignmentOwner", "policyAssignmentParameters", "policyAssignmentScope", "policyDefinitionName", "policyDefinitionAction", "policyDefinitionCategory", "policySetDefinitionId", "policySetDefinitionName", "policySetDefinitionOwner", "policySetDefinitionCategory", "policySetDefinitionParameters", "managementGroupIds", "policyDefinitionReferenceId", "complianceState"}),
    #"Filtered Rows1" = Table.SelectRows(#"Expanded Column3", each [timestamp] <> null and [timestamp] <> ""),
    #"Lowercased Text" = Table.TransformColumns(#"Filtered Rows1",{{"policyAssignmentScope", Text.Lower, type text}}),
    #"Added Custom" = Table.AddColumn(#"Lowercased Text", "Policy Image", each "https://raw.githubusercontent.com/CristianEdwards/ccodashboard/master/docs/assets/2020_Icons/Policy.svg"),
    #"Added Conditional Column1" = Table.AddColumn(#"Added Custom", "ComplianceState Number", each if [complianceState] = "Compliant" then 1 else 0),
    #"Added Conditional Column" = Table.AddColumn(#"Added Conditional Column1", "Policy Scope", each if Text.Contains([policyAssignmentScope], "managementgroup") then "Management Group" else if Text.Contains([policyAssignmentScope], "resourcegroup") then "Resource Group" else "Subscription")
in
    #"Added Conditional Column"

// ListPolicySets
let listPolicySets = (SubscriptionId as text) =>
let
    Source = Json.Document(Web.Contents(GetManagementURL(AzureKind)&"/subscriptions/"&SubscriptionId&"/providers/Microsoft.Authorization/policySetDefinitions?api-version=2019-09-01")),
    #"Converted to Table" = Record.ToTable(Source)
in
    #"Converted to Table" 

    in listPolicySets

// ListPolicyDefinitions
let ListAllPolicies = (subscriptionId as text) =>
let
    Source = Json.Document(Web.Contents(GetManagementURL(AzureKind)&"/subscriptions/"&subscriptionId&"/providers/Microsoft.Authorization/policyDefinitions?api-version=2019-09-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"properties", "id", "type", "name"}, {"properties", "id", "type", "name"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column1", "properties", {"displayName", "policyType", "mode", "description", "metadata", "policyRule", "parameters"}, {"displayName", "policyType", "mode", "description", "metadata", "policyRule", "parameters"}),
    #"Expanded metadata" = Table.ExpandRecordColumn(#"Expanded properties", "metadata", {"category", "additionalMetadataId", "preview", "deprecated", "requiredProviders"}, {"metadata.category", "metadata.additionalMetadataId", "metadata.preview", "metadata.deprecated", "metadata.requiredProviders"}),
    #"Expanded parameters" = Table.ExpandRecordColumn(#"Expanded metadata", "parameters", {"effect"}, {"parameters.effect"}),
    #"Expanded parameters.effect" = Table.ExpandRecordColumn(#"Expanded parameters", "parameters.effect", {"defaultValue"}, {"parameters.effect.defaultValue"})
in
    #"Expanded parameters.effect"
    in
ListAllPolicies

// PolicyDefinitions
let
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "Definitions", each ListPolicyDefinitions([subscriptionId])),
    #"Removed Columns" = Table.RemoveColumns(#"Invoked Custom Function",{"authorizationSource", "state", "locationPlacementId", "quotaId", "spendingLimit"}),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Removed Columns", {"Definitions"}),
    #"Expanded Definitions" = Table.ExpandTableColumn(#"Removed Errors", "Definitions", {"displayName", "policyType", "mode", "description", "metadata.category", "metadata.additionalMetadataId", "metadata.preview", "metadata.deprecated", "metadata.requiredProviders", "policyRule", "parameters.effect.defaultValue", "id", "type", "name"}, {"Definitions.displayName", "Definitions.policyType", "Definitions.mode", "Definitions.description", "Definitions.metadata.category", "Definitions.metadata.additionalMetadataId", "Definitions.metadata.preview", "Definitions.metadata.deprecated", "Definitions.metadata.requiredProviders", "Definitions.policyRule", "Definitions.parameters.effect.defaultValue", "Definitions.id", "Definitions.type", "Definitions.name"}),
    #"Replaced Value" = Table.ReplaceValue(#"Expanded Definitions",null,false,Replacer.ReplaceValue,{"Definitions.metadata.preview"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value",null,false,Replacer.ReplaceValue,{"Definitions.metadata.deprecated"}),
    #"Removed Duplicates" = Table.Distinct(#"Replaced Value1", {"Definitions.id"}),
    #"Added Conditional Column" = Table.AddColumn(#"Removed Duplicates", "Preview?", each if [Definitions.metadata.preview] = false then 0 else 1),
    #"Added Conditional Column1" = Table.AddColumn(#"Added Conditional Column", "Deprecated", each if [Definitions.metadata.deprecated] = false then 0 else 1),
    #"Changed Type" = Table.TransformColumnTypes(#"Added Conditional Column1",{{"Deprecated", Int64.Type}, {"Preview?", Int64.Type}}),
    #"Added Conditional Column2" = Table.AddColumn(#"Changed Type", "Image", each if [Definitions.displayName] <> null then "https://raw.githubusercontent.com/josunefon/ccodashboard/master/install/DI_Images/Azure_Policy.png" else "https://raw.githubusercontent.com/josunefon/ccodashboard/master/install/DI_Images/Azure_Policy.png")
in
    #"Added Conditional Column2"

// AllBuiltInPoliciesDefinition
let
    Source = Json.Document(Web.Contents(GetManagementURL(AzureKind)&"/providers/Microsoft.Authorization/policyDefinitions?api-version=2019-09-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"properties", "id", "name"}, {"properties", "id", "name"}),
    #"Reordered Columns" = Table.ReorderColumns(#"Expanded Column1",{"id", "name", "properties"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Reordered Columns", "properties", {"displayName", "policyType", "mode", "description", "metadata"}, {"displayName", "policyType", "mode", "description", "metadata"}),
    #"Expanded metadata" = Table.ExpandRecordColumn(#"Expanded properties", "metadata", {"version", "category", "deprecated", "preview"}, {"version", "category", "deprecated", "preview"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded metadata",{{"id", "Policy Definition Id"}, {"name", "Policy Name"}, {"displayName", "Policy DisplayName"}}),
    #"Filtered Rows" = Table.SelectRows(#"Renamed Columns", each ([policyType] = "BuiltIn")),
    #"Added Conditional Column" = Table.AddColumn(#"Filtered Rows", "Image", each if [category] = "Key Vault" then "https://azure.github.io/ccodashboard/assets/2020_Icons/KeyVaults.svg" else if [category] = "Storage" then "https://azure.github.io/ccodashboard/assets/2020_Icons/StorageAccounts.svg" else if [category] = "SQL" then "https://azure.github.io/ccodashboard/assets/2020_Icons/SQLdatabases.svg" else if [category] = "Compute" then "https://azure.github.io/ccodashboard/assets/2020_Icons/VirtualMachines.svg" else if [category] = "Security Center" then "https://azure.github.io/ccodashboard/assets/2020_Icons/SecurityCenter.svg" else if [category] = "App Service" then "https://azure.github.io/ccodashboard/assets/2020_Icons/AppServices.svg" else if [category] = "Logic Apps" then "https://azure.github.io/ccodashboard/assets/2020_Icons/LogicApps.svg" else if [category] = "Monitoring" then "https://azure.github.io/ccodashboard/assets/2020_Icons/Monitor.svg" else if [category] = "Guest Configuration" then "https://azure.github.io/ccodashboard/assets/2020_Icons/GuestConfig.svg" else if [category] = "Data Lake" then "https://azure.github.io/ccodashboard/assets/2020_Icons/DataLake.svg" else if [category] = "Backup" then "https://azure.github.io/ccodashboard/assets/2020_Icons/Backup.svg" else if [category] = "Cognitive Services" then "https://azure.github.io/ccodashboard/assets/2020_Icons/CognitiveServices.svg" else if [category] = "Cosmos DB" then "https://azure.github.io/ccodashboard/assets/2020_Icons/AzureCosmosDB.svg" else if [category] = "Tags" then "https://azure.github.io/ccodashboard/assets/2020_Icons/Tags.svg" else if [category] = "Service Fabric" then "https://azure.github.io/ccodashboard/assets/2020_Icons/ServiceFabric.svg" else if [category] = "General" then "https://azure.github.io/ccodashboard/assets/2020_Icons/Subscriptions.svg" else if [category] = "Managed Application" then "https://azure.github.io/ccodashboard/assets/2020_Icons/ManagedApplications.svg" else if [category] = "Network" then "https://azure.github.io/ccodashboard/assets/2020_Icons/VirtualNetworks.svg" else if [category] = "Automation" then "https://azure.github.io/ccodashboard/assets/2020_Icons/AutomationAccounts.svg" else if [category] = "Internet of Things" then "https://azure.github.io/ccodashboard/assets/2020_Icons/IoT.svg" else if [category] = "Event Grid" then "https://azure.github.io/ccodashboard/assets/2020_Icons/EventGrid.svg" else if [category] = "Search" then "https://azure.github.io/ccodashboard/assets/2020_Icons/SearchServices.svg" else if [category] = "App Configuration" then "https://azure.github.io/ccodashboard/assets/2020_Icons/AppConfiguration.svg" else if [category] = "App Platform" then "https://azure.github.io/ccodashboard/assets/2020_Icons/AzureSpringCloud.svg" else if [category] = "Cache" then "https://azure.github.io/ccodashboard/assets/2020_Icons/AzureCacheRedis.svg" else if [category] = "Batch" then "https://azure.github.io/ccodashboard/assets/2020_Icons/BatchAccounts.svg" else if [category] = "Container Registry" then "https://azure.github.io/ccodashboard/assets/2020_Icons/ContainerRegistries.svg" else if [category] = "Lighthouse" then "https://azure.github.io/ccodashboard/assets/2020_Icons/AzureLighthouse.svg" else if [category] = "Event Hub" then "https://azure.github.io/ccodashboard/assets/2020_Icons/EventHubs.svg" else if [category] = "Service Bus" then "https://azure.github.io/ccodashboard/assets/2020_Icons/ServiceBus.svg" else if [category] = "Custom Provider" then "https://azure.github.io/ccodashboard/assets/2020_Icons/Resource.svg" else if [category] = "API Management" then "https://azure.github.io/ccodashboard/assets/2020_Icons/APIManagement.svg" else if [category] = "Kubernetes" then "https://azure.github.io/ccodashboard/assets/2020_Icons/Kubernetesservices.svg" else if [category] = "Kubernetes service" then "https://azure.github.io/ccodashboard/assets/2020_Icons/Kubernetesservices.svg" else if [category] = "Machine Learning" then "https://azure.github.io/ccodashboard/assets/2020_Icons/MachineLearning.svg" else if [category] = "Stream Analytics" then "https://azure.github.io/ccodashboard/assets/2020_Icons/StreamAnalytics.svg" else null)
in
    #"Added Conditional Column"

// ListResourcesFinal
let ListResources= (SubscriptionId as text) =>
let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
    Fullset = GetPages(GetManagementURL(AzureKind)&"/subscriptions/"&SubscriptionId&"/resources?api-version=2019-05-01"),
    #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error),

    #"Expanded Column2" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "name", "type", "location", "tags"}, {"id", "name", "type", "location", "tags"}),
 
    #"Added Conditional Column" = Table.AddColumn(#"Expanded Column2", "IsTagged", each if [tags] = null then "Untagged" else if [tags] = [] then "Untagged" else "Tagged"),
   
    #"Removed Columns1" = Table.RemoveColumns(#"Added Conditional Column",{"tags"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns1",{{"id", "Resource Id"}, {"name", "Resource Name"}, {"type", "Resource Type"}}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Renamed Columns", "Resource Id", "Resource Id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "Resource Id - Copy", Splitter.SplitTextByDelimiter("/providers", QuoteStyle.Csv), {"Resource Id - Copy.1", "Resource Id - Copy.2"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Resource Id - Copy.1", type text}, {"Resource Id - Copy.2", type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type",{"Resource Id - Copy.2"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"Resource Id - Copy.1", "Resource Group Id"}}),
    #"Duplicated Column1" = Table.DuplicateColumn(#"Renamed Columns1", "Resource Group Id", "Resource Group Id - Copy"),
    #"Split Column by Delimiter1" = Table.SplitColumn(#"Duplicated Column1", "Resource Group Id - Copy", Splitter.SplitTextByEachDelimiter({"/"}, QuoteStyle.Csv, true), {"Resource Group Id - Copy.1", "Resource Group Id - Copy.2"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Split Column by Delimiter1",{{"Resource Group Id - Copy.1", type text}, {"Resource Group Id - Copy.2", type text}}),
    #"Renamed Columns2" = Table.RenameColumns(#"Changed Type1",{{"Resource Group Id - Copy.2", "Resource Group Name"}}),
    #"Removed Columns2" = Table.RemoveColumns(#"Renamed Columns2",{"Resource Group Id - Copy.1"})
in
    #"Removed Columns2"
in
    ListResources

// Resources
let
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "ListOfResources", each ListResourcesFinal([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListOfResources"}),
    #"Expanded ListOfResources" = Table.ExpandTableColumn(#"Removed Errors", "ListOfResources", {"Resource Id", "Resource Name", "Resource Type", "location", "IsTagged", "Resource Group Id", "Resource Group Name"}, {"Resource Id", "Resource Name", "Resource Type", "location", "IsTagged", "Resource Group Id", "Resource Group Name"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded ListOfResources", each [Resource Id] <> null and [Resource Id] <> ""),
    #"Added Conditional Column" = Table.AddColumn(#"Filtered Rows", "IsTagged?", each if [IsTagged] = "Tagged" then 1 else 0),
    #"Duplicated Column" = Table.DuplicateColumn(#"Added Conditional Column", "Resource Type", "Resource Type - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "Resource Type - Copy", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"Resource Type - Copy.1", "Resource Type - Copy.2", "Resource Type - Copy.3"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Resource Type - Copy.1", type text}, {"Resource Type - Copy.2", type text}, {"Resource Type - Copy.3", type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type",{"Resource Type - Copy.1", "Resource Type - Copy.3"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"Resource Type - Copy.2", "Resource Type for Usage"}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Renamed Columns1",{"authorizationSource", "state", "locationPlacementId", "quotaId", "spendingLimit"})
in
    #"Removed Columns1"

// ListAssessments
let ListAllAssesssments = (SubscriptionId as text) =>
let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
     Fullset = GetPages(GetManagementURL(AzureKind)&"/subscriptions/"&SubscriptionId&"/providers/Microsoft.Security/assessments?api-version=2020-01-01"),
     #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"type", "id", "name", "properties"}, {"type", "id", "name", "properties"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column1", "properties", {"resourceDetails", "displayName", "status", "additionalData"}, {"resourceDetails", "displayName", "status", "additionalData"}),
    #"Expanded resourceDetails" = Table.ExpandRecordColumn(#"Expanded properties", "resourceDetails", {"Source", "Id"}, {"resourceDetails.Source", "resourceDetails.Id"}),
    #"Expanded status" = Table.ExpandRecordColumn(#"Expanded resourceDetails", "status", {"code", "cause", "description"}, {"status.code", "status.cause", "status.description"})
in
    #"Expanded status"
in ListAllAssesssments

// ASC_Assessments
let
    Source = #"All Subscriptions",
    #"Removed Columns" = Table.RemoveColumns(Source,{"authorizationSource", "state", "locationPlacementId", "quotaId", "spendingLimit"}),
    #"Reordered Columns" = Table.ReorderColumns(#"Removed Columns",{"tenantId", "Subscription Name", "subscriptionId"}),
    #"Invoked Custom Function" = Table.AddColumn(#"Reordered Columns", "Assesstments", each ListAssessments([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"Assesstments"}),
    #"Expanded Assesstments" = Table.ExpandTableColumn(#"Removed Errors", "Assesstments", {"id", "name", "resourceDetails.Source", "resourceDetails.Id", "displayName", "status.code", "status.cause", "status.description"}, {"Assesstments.id", "Assesstments.name", "Assesstments.resourceDetails.Source", "Assesstments.resourceDetails.Id", "Assesstments.displayName", "Assesstments.status.code", "Assesstments.status.cause", "Assesstments.status.description"}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Expanded Assesstments", "Assesstments.id", "Assesstments.id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "Assesstments.id - Copy", Splitter.SplitTextByDelimiter("providers", QuoteStyle.Csv), {"Assesstments.id - Copy.1", "Assesstments.id - Copy.2", "Assesstments.id - Copy.3"}),
    #"Added Conditional Column1" = Table.AddColumn(#"Split Column by Delimiter", "Assessment Id Final", each if [#"Assesstments.id - Copy.3"] = null then [#"Assesstments.id - Copy.2"] else [#"Assesstments.id - Copy.3"]),
    #"Removed Columns3" = Table.RemoveColumns(#"Added Conditional Column1",{"Assesstments.id - Copy.2", "Assesstments.id - Copy.3", "Assesstments.id - Copy.1"}),
    #"Lowercased Text" = Table.TransformColumns(#"Removed Columns3",{{"Assesstments.resourceDetails.Id", Text.Lower, type text}}),
    #"Duplicated Column1" = Table.DuplicateColumn(#"Lowercased Text", "Assesstments.resourceDetails.Id", "Assesstments.resourceDetails.Id - Copy"),
    #"Split Column by Delimiter1" = Table.SplitColumn(#"Duplicated Column1", "Assesstments.resourceDetails.Id - Copy", Splitter.SplitTextByEachDelimiter({"/"}, QuoteStyle.Csv, true), {"Assesstments.resourceDetails.Id - Copy.1", "Assesstments.resourceDetails.Id - Copy.2"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Split Column by Delimiter1",{{"Assesstments.resourceDetails.Id - Copy.2", "ResourceName"}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Renamed Columns1",{"Assesstments.resourceDetails.Id - Copy.1"}),
    #"Added Conditional Column" = Table.AddColumn(#"Removed Columns1", "ResourceScore", each if [Assesstments.status.code] = "Unhealthy" then 1 else if [Assesstments.status.code] = "NotApplicable" then 10 else 0),
    #"Removed Columns2" = Table.RemoveColumns(#"Added Conditional Column",{"Assesstments.id"}),
    #"Filtered Rows" = Table.SelectRows(#"Removed Columns2", each ([Assesstments.resourceDetails.Source] = "Azure")),
    #"Added Conditional Column2" = Table.AddColumn(#"Filtered Rows", "Image", each if [Assesstments.status.code] = "Healthy" then "https://azure.github.io/ccodashboard/assets/pictures/checkmark.svg" else if [Assesstments.status.code] = "NotApplicable" then "https://azure.github.io/ccodashboard/assets/pictures/crossout.svg" else "https://azure.github.io/ccodashboard/assets/pictures/crossout.svg")
in
    #"Added Conditional Column2"

// assessmentMetadata_F
let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
     Fullset = GetPages(GetManagementURL(AzureKind)&"/providers/Microsoft.Security/assessmentMetadata?api-version=2020-01-01"),
     #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
   #"Removed Errors" = Table.RemoveRowsWithErrors(#"Converted to Table", {"Column1"}),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Removed Errors", "Column1", {"id", "name", "type", "properties"}, {"id", "name", "type", "properties"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column1", "properties", {"displayName", "assessmentType", "policyDefinitionId", "description", "remediationDescription", "categories", "preview", "severity", "userImpact", "implementationEffort", "threats"}, {"displayName", "assessmentType", "policyDefinitionId", "description", "remediationDescription", "categories", "preview", "severity", "userImpact", "implementationEffort", "threats"}),
    #"Extracted Values" = Table.TransformColumns(#"Expanded properties", {"categories", each Text.Combine(List.Transform(_, Text.From), ","), type text}),
    #"Extracted Values1" = Table.TransformColumns(#"Extracted Values", {"threats", each Text.Combine(List.Transform(_, Text.From), ","), type text})
in
    #"Extracted Values1"

// Blueprints
let
    Source = CcoDashboardAzureConnector.Management(AzureKind),
    blueprints = Source{[Key="blueprints"]}[Data],
    #"Removed Columns" = Table.RemoveColumns(blueprints,{"id", "tenantId", "countryCode", "displayName", "domains", "tenantCategory", "ManagementGroups.count"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Columns", {"scopeId"}),
    #"Expanded Blueprints" = Table.ExpandTableColumn(#"Removed Duplicates", "Blueprints", {"Column1"}, {"Column1"}),
    #"Expanded Column1" = Table.ExpandListColumn(#"Expanded Blueprints", "Column1"),
    #"Expanded Column2" = Table.ExpandRecordColumn(#"Expanded Column1", "Column1", {"properties", "id", "name"}, {"properties", "id", "name"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded Column2", each [id] <> null and [id] <> ""),
    #"Renamed Columns" = Table.RenameColumns(#"Filtered Rows",{{"id", "Blueprint Id"}, {"name", "Blueprint Custom Name"}}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Renamed Columns", "properties", {"targetScope", "status", "displayName", "description"}, {"targetScope", "status", "displayName", "description"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded properties",{{"displayName", "Blueprint Official Name"}}),
    #"Replaced Value" = Table.ReplaceValue(#"Renamed Columns1",null,"Custom Blueprint",Replacer.ReplaceValue,{"Blueprint Official Name"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Replaced Value",{{"description", "Blueprint Descriptions"}}),
    #"Expanded status" = Table.ExpandRecordColumn(#"Renamed Columns2", "status", {"timeCreated", "lastModified"}, {"timeCreated", "lastModified"}),
    #"Renamed Columns3" = Table.RenameColumns(#"Expanded status",{{"scopeId", "Blueprint Store and Scope"}}),
    #"Added Conditional Column" = Table.AddColumn(#"Renamed Columns3", "Store Type", each if Text.Contains([Blueprint Store and Scope], "managementGroups") then "Management Group" else "Subscription"),
    #"Added Conditional Column1" = Table.AddColumn(#"Added Conditional Column", "Img", each if [Store Type] = "Subscription" then "https://azure.github.io/ccodashboard/assets/2020_Icons/Subscriptions.svg" else "https://azure.github.io/ccodashboard/assets/2020_Icons/ManagementGroups.svg")
in
    #"Added Conditional Column1"

// Published Blueprints
let
    Source = CcoDashboardAzureConnector.Management(AzureKind),
    blueprintspublished = Source{[Key="blueprintspublished"]}[Data],
    #"Renamed Columns" = Table.RenameColumns(blueprintspublished,{{"id.1", "Published Blueprint Version Id"}, {"description", "Published Blueprint Description"}, {"name.2", "Published Blueprint Version"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns",{"parameters", "resourceGroups"}),
    #"Expanded status" = Table.ExpandRecordColumn(#"Removed Columns", "status", {"timeCreated", "lastModified"}, {"timeCreated", "lastModified"}),
    #"Removed Columns3" = Table.RemoveColumns(#"Expanded status",{"properties"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Removed Columns3",{"Name.1"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns1",{{"id", "Blueprint Id"}}),
    #"Removed Columns2" = Table.RemoveColumns(#"Renamed Columns1",{"type.1"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Columns2", {"Blueprint Id"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Removed Duplicates",{{"displayName.1", "Blueprint Portal Name"}}),
    #"Renamed Columns3" = Table.RenameColumns(#"Renamed Columns2",{{"scopeId", "Blueprint Store"}}),
    #"Replaced Value" = Table.ReplaceValue(#"Renamed Columns3",null,"NOT PUBLISHED",Replacer.ReplaceValue,{"blueprintName"}),
    #"Renamed Columns4" = Table.RenameColumns(#"Replaced Value",{{"blueprintName", "Published Blueprint Name"}}),
    #"Replaced Value1" = Table.ReplaceValue(#"Renamed Columns4",null,"Draft",Replacer.ReplaceValue,{"Published Blueprint Version"})
in
    #"Replaced Value1"

// Blueprint Artifacts
let
    Source = CcoDashboardAzureConnector.Management(AzureKind),
    blueprintartifact = Source{[Key="blueprintartifact"]}[Data],
    #"Renamed Columns" = Table.RenameColumns(blueprintartifact,{{"id.1", "Blueprint Artifact Id"}, {"name.1", "Blueprint Artifact Name"}, {"id", "Blueprint Id"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns",{"tenantId", "displayName", "scopeId", "properties", "type"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"name", "Blueprint Custom Name"}}),
    #"Expanded properties.1" = Table.ExpandRecordColumn(#"Renamed Columns1", "properties.1", {"policyDefinitionId"}, {"policyDefinitionId"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Expanded properties.1",{"type.1"}),
    #"Added Conditional Column" = Table.AddColumn(#"Removed Columns1", "Img", each if [kind] = "policyAssignment" then "https://azure.github.io/ccodashboard/assets/2020_Icons/Policy.svg" else if [kind] = "template" then "https://azure.github.io/ccodashboard/assets/2020_Icons/BlueprintTemplateKind.svg" else if [kind] = "roleAssignment" then "https://azure.github.io/ccodashboard/assets/2020_Icons/BlueprintRoleContributorKind.svg" else null),
    #"Filtered Rows" = Table.SelectRows(#"Added Conditional Column", each [Blueprint Artifact Id] <> null and [Blueprint Artifact Id] <> "")
in
    #"Filtered Rows"

// ListBlueprintAssignments
let ListBlueprintAssignments = (SubscriptionId as text) =>
let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
     Fullset = GetPages(GetManagementURL(AzureKind)&"/subscriptions/"&SubscriptionId&"/providers/Microsoft.Blueprint/blueprintAssignments?api-version=2018-11-01-preview"),
     #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
     #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"identity", "location", "properties", "id", "name"}, {"identity", "location", "properties", "id", "name"}),
     #"Renamed Columns1" = Table.RenameColumns(#"Expanded Column1",{{"id", "Assigned Blueprint Id"}, {"name", "Assigned Blueprint Name"}}),
     #"Expanded properties" = Table.ExpandRecordColumn(#"Renamed Columns1", "properties", {"provisioningState", "blueprintId", "parameters", "resourceGroups", "status", "scope", "locks"}, {"provisioningState", "blueprintId", "parameters", "resourceGroups", "status", "scope", "locks"})
in
    #"Expanded properties"
in
    ListBlueprintAssignments

// Resource Groups
let
    Source = #"All Subscriptions",
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "ListOfResourceGroups", each ListResourceGroups([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListOfResourceGroups"}),
    #"Expanded ListOfResourceGroups" = Table.ExpandTableColumn(#"Removed Errors", "ListOfResourceGroups", {"Resource Group Id", "Resource Group Name", "type", "location", "IsTagged"}, {"Resource Group Id", "Resource Group Name", "type", "location", "IsTagged"}),
    #"Added Conditional Column" = Table.AddColumn(#"Expanded ListOfResourceGroups", "IsTaggedNumeric", each if [IsTagged] = "Tagged" then 1 else 0),
    #"Renamed Columns1" = Table.RenameColumns(#"Added Conditional Column",{{"IsTaggedNumeric", "IsTagged?"}})
in
    #"Renamed Columns1"

// ListResourceGroups
let ListResourceGroups = (SubscriptionId as text) =>
let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
    Fullset = GetPages(GetManagementURL(AzureKind)&"/subscriptions/"&SubscriptionId&"/resourcegroups?api-version=2019-05-01"),
    #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "name", "type", "location", "tags"}, {"id", "name", "type", "location", "tags"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"id", "Resource Group Id"}, {"name", "Resource Group Name"}}),
    #"Added Conditional Column" = Table.AddColumn(#"Renamed Columns", "IsTagged", each if [tags] = null  then "Untagged" else if [tags] = [] then "Untagged" else "Tagged"),
    #"Removed Columns" = Table.RemoveColumns(#"Added Conditional Column",{"tags"})
in
    #"Removed Columns"

in
    ListResourceGroups

// TaggedResourceGroups
let
    Source = #"All Subscriptions",
    #"Removed Columns" = Table.RemoveColumns(Source,{"authorizationSource", "state", "locationPlacementId", "quotaId", "spendingLimit"}),
    #"Invoked Custom Function" = Table.AddColumn(#"Removed Columns", "ListResourceGroupsTags", each ListResourceGroupsTags([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListResourceGroupsTags"}),
    #"Expanded ListResourceGroupsTags" = Table.ExpandTableColumn(#"Removed Errors", "ListResourceGroupsTags", {"id", "TagKey", "TagValue"}, {"id", "TagKey", "TagValue"}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Expanded ListResourceGroupsTags", "id", "Resource Group Id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "Resource Group Id - Copy", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"Resource Group Id - Copy.1", "Resource Group Id - Copy.2", "Resource Group Id - Copy.3", "Resource Group Id - Copy.4", "Resource Group Id - Copy.5"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Resource Group Id - Copy.1", type text}, {"Resource Group Id - Copy.2", type text}, {"Resource Group Id - Copy.3", type text}, {"Resource Group Id - Copy.4", type text}, {"Resource Group Id - Copy.5", type text}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Changed Type",{"Resource Group Id - Copy.1", "Resource Group Id - Copy.2", "Resource Group Id - Copy.3"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns1",{{"Resource Group Id - Copy.4", "Resource Type"}, {"Resource Group Id - Copy.5", "Resource Group Name"}})
in
    #"Renamed Columns"

// ListResourceGroupsTags
let ListResourceGroupsTags = (SubscriptionId as text) =>
let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
    Fullset = GetPages(GetManagementURL(AzureKind)&"/subscriptions/"&SubscriptionId&"/resourcegroups?api-version=2019-05-01"),
    #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "name","tags"}, {"id", "name","tags"}),
    ColumnContents = Table.Column(#"Expanded Column1", "tags"),
    ColumnsToExpand = List.Distinct(List.Combine(List.Transform(ColumnContents, each if _ is record then Record.FieldNames(_) else {}))),
    #"Expanded tags"= Table.ExpandRecordColumn(#"Expanded Column1", "tags", ColumnsToExpand, ColumnsToExpand),
    #"Unpivoted Other Columns" = Table.UnpivotOtherColumns(#"Expanded tags", {"id", "name"}, "Attribute", "Value"),
    #"Renamed Columns" = Table.RenameColumns(#"Unpivoted Other Columns",{{"Attribute", "TagKey"}, {"Value", "TagValue"}, {"name", "Resource Name"}})
in
    #"Renamed Columns"
in
    ListResourceGroupsTags

// GetGraphURL
let GetGraphBaseUri=(govKind as text) as text =>
    let
        GraphURL = if govKind ="us-government" then "https://graph.microsoft.us"
                    else if govKind="germany-government" then""
                    else if govKind = "china" then ""
                    else "https://graph.windows.net"

    in
        GraphURL

in GetGraphBaseUri

// CC GetEntities
let
    Source = CcoDashboardAzureConnector.Management(AzureKind),
    alldescendantstrick = Source{[Key="alldescendantstrick"]}[Data],
    #"Expanded ManagementGroups" = Table.ExpandRecordColumn(alldescendantstrick, "ManagementGroups", {"value"}, {"value"}),
    #"Expanded value" = Table.ExpandListColumn(#"Expanded ManagementGroups", "value"),
    #"Expanded value1" = Table.ExpandRecordColumn(#"Expanded value", "value", {"name", "id", "type", "properties"}, {"name", "id.1", "type", "properties"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded value1",{{"id.1", "Resource Id"}}),
    #"Filtered Rows" = Table.SelectRows(#"Renamed Columns", each [name] <> null and [name] <> ""),
    #"Renamed Columns1" = Table.RenameColumns(#"Filtered Rows",{{"name", "Resource Name"}, {"type", "Resource Type"}}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Renamed Columns1", "properties", {"numberOfChildren", "numberOfChildGroups", "numberOfDescendants", "displayName", "parentDisplayNameChain", "inheritedPermissions", "permissions"}, {"numberOfChildren", "numberOfChildGroups", "numberOfDescendants", "displayName.1", "parentDisplayNameChain", "inheritedPermissions", "permissions"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Expanded properties",{{"displayName.1", "Resource Display Name"}}),
    #"Extracted Values" = Table.TransformColumns(#"Renamed Columns2", {"parentDisplayNameChain", each Text.Combine(List.Transform(_, Text.From), "/"), type text}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Extracted Values", "parentDisplayNameChain", Splitter.SplitTextByEachDelimiter({"/"}, QuoteStyle.Csv, true), {"parentDisplayNameChain.1", "parentDisplayNameChain.2"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"parentDisplayNameChain.1", type text}, {"parentDisplayNameChain.2", type text}}),
    #"Added Conditional Column" = Table.AddColumn(#"Changed Type", "TempParentDisplayName", each if [parentDisplayNameChain.1] = "" then "IsRoot" else [parentDisplayNameChain.2]),
    #"Added Conditional Column1" = Table.AddColumn(#"Added Conditional Column", "Parent Display Name", each if [TempParentDisplayName] = null then [parentDisplayNameChain.1] else [TempParentDisplayName]),
    #"Removed Columns1" = Table.RemoveColumns(#"Added Conditional Column1",{"parentDisplayNameChain.1", "parentDisplayNameChain.2", "TempParentDisplayName"}),
    #"Replaced Value" = Table.ReplaceValue(#"Removed Columns1","Is Tenant Root Group",null,Replacer.ReplaceValue,{"Parent Display Name"}),
    #"Added Index" = Table.AddIndexColumn(#"Replaced Value", "Index", 1, 1),
    #"Added Conditional Column2" = Table.AddColumn(#"Added Index", "Image", each if [Resource Type] = "/providers/Microsoft.Management/managementGroups" then "https://azure.github.io/ccodashboard/assets/pictures/037_Management_Groups.svg" else "https://azure.github.io/ccodashboard/assets/pictures/036_ASCTasks_Subscription.svg"),
    #"Replaced Value1" = Table.ReplaceValue(#"Added Conditional Column2","IsRoot",null,Replacer.ReplaceValue,{"Parent Display Name"})
in
    #"Replaced Value1"

// ListAzureLocations
let ListAzureLocations = (SubscriptionId as text) =>
let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
    Fullset = GetPages(GetManagementURL(AzureKind)&"/subscriptions/"&SubscriptionId&"/locations?api-version=2020-01-01"),
    #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "name", "displayName", "regionalDisplayName", "metadata"}, {"id", "name", "displayName", "regionalDisplayName", "metadata"}),
    #"Expanded metadata" = Table.ExpandRecordColumn(#"Expanded Column1", "metadata", {"regionType", "regionCategory", "geographyGroup", "longitude", "latitude", "physicalLocation", "pairedRegion"}, {"regionType", "regionCategory", "geographyGroup", "longitude", "latitude", "physicalLocation", "pairedRegion"}),
    #"Expanded pairedRegion" = Table.ExpandListColumn(#"Expanded metadata", "pairedRegion"),
    #"Expanded pairedRegion1" = Table.ExpandRecordColumn(#"Expanded pairedRegion", "pairedRegion", {"name", "id"}, {"name.1", "id.1"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded pairedRegion1",{{"id", "Location Id"}, {"name", "Location Name"}, {"displayName", "Location Display Name"}, {"regionalDisplayName", "Location regionalDisplayName"}, {"name.1", "Paired Region Name"}, {"id.1", "Paired Region Id"}}),
    #"Filtered Rows" = Table.SelectRows(#"Renamed Columns", each ([regionType] = "Physical"))
in
    #"Filtered Rows"
in 
    ListAzureLocations

// Azure Regions
let
    Source = #"All Subscriptions",
    #"Removed Columns" = Table.RemoveColumns(Source,{"authorizationSource", "state", "locationPlacementId", "quotaId", "spendingLimit"}),
    #"Invoked Custom Function" = Table.AddColumn(#"Removed Columns", "ListAzureLocations", each ListAzureLocations([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListAzureLocations"}),
    #"Expanded ListAzureLocations" = Table.ExpandTableColumn(#"Removed Errors", "ListAzureLocations", {"Location Id", "Location Name", "Location Display Name", "Location regionalDisplayName", "regionType", "regionCategory", "geographyGroup", "longitude", "latitude", "physicalLocation", "Paired Region Name", "Paired Region Id"}, {"Location Id", "Location Name", "Location Display Name", "Location regionalDisplayName", "regionType", "regionCategory", "geographyGroup", "longitude", "latitude", "physicalLocation", "Paired Region Name", "Paired Region Id"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Expanded ListAzureLocations",{"Subscription Resource Id", "subscriptionId", "Subscription Name", "Location Id", "tenantId"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Columns1", {"Location Name"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Removed Duplicates",{{"longitude", type number}, {"latitude", type number}})
in
    #"Changed Type"

// Tagged Resources
let
    Source = #"All Subscriptions",
    #"Removed Columns" = Table.RemoveColumns(Source,{"authorizationSource", "state", "locationPlacementId", "quotaId", "spendingLimit"}),
    #"Invoked Custom Function" = Table.AddColumn(#"Removed Columns", "ListResourceTags", each ListResourceTags([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListResourceTags"}),
    #"Expanded ListResourceTags" = Table.ExpandTableColumn(#"Removed Errors", "ListResourceTags", {"id", "ResourceName", "TagKey", "TagValue"}, {"id", "ResourceName", "TagKey", "TagValue"})
in
    #"Expanded ListResourceTags"

// ListResourceTags
let ListResourceTags = (SubscriptionId as text) =>
let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
    Fullset = GetPages(GetManagementURL(AzureKind)&"/subscriptions/"&SubscriptionId&"/resources?api-version=2019-10-01"),
    #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error), 
    #"Expanded Column1" = Table.ExpandRecordColumn( #"Converted to Table", "Column1", {"id", "name", "tags"}, {"id", "name", "tags"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded Column1",{{"name", "ResourceName"}}),
    ColumnContents = Table.Column(#"Renamed Columns1", "tags"),
    ColumnsToExpand = List.Distinct(List.Combine(List.Transform(ColumnContents, each if _ is record then Record.FieldNames(_) else {}))),
    #"Expanded tags"= Table.ExpandRecordColumn(#"Renamed Columns1", "tags", ColumnsToExpand, ColumnsToExpand),
    #"Unpivoted Other Columns" = Table.UnpivotOtherColumns(#"Expanded tags", {"id", "ResourceName"}, "Attribute", "Value"),
    #"Renamed Columns" = Table.RenameColumns(#"Unpivoted Other Columns",{{"Attribute", "TagKey"}, {"Value", "TagValue"}})
in
    #"Renamed Columns" 
  
 in
    ListResourceTags

// Blueprint Subscription Assignments
let
    Source = #"All Subscriptions",
    #"Removed Columns" = Table.RemoveColumns(Source,{"authorizationSource", "state", "locationPlacementId", "quotaId", "spendingLimit"}),
    #"Invoked Custom Function" = Table.AddColumn(#"Removed Columns", "Blueprint Assignments", each ListBlueprintAssignments([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"Blueprint Assignments"}),
    #"Expanded Blueprint Assignments" = Table.ExpandTableColumn(#"Removed Errors", "Blueprint Assignments", {"identity", "location", "provisioningState", "blueprintId", "parameters", "resourceGroups", "status", "scope", "locks", "Assigned Blueprint Id", "Assigned Blueprint Name"}, {"identity", "location", "provisioningState", "blueprintId", "parameters", "resourceGroups", "status", "scope", "locks", "Assigned Blueprint Id", "Assigned Blueprint Name"}),
    #"Added Conditional Column" = Table.AddColumn(#"Expanded Blueprint Assignments", "Img", each if [provisioningState] = "succeeded" then "https://azure.github.io/ccodashboard/assets/2020_Icons/AssignedBlueprints.svg" else "https://azure.github.io/ccodashboard/assets/2020_Icons/AssignedBlueprints.svg"),
    #"Renamed Columns" = Table.RenameColumns(#"Added Conditional Column",{{"blueprintId", "Published Blueprint version Id"}}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Renamed Columns", "Published Blueprint version Id", "Published Blueprint version Id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "Published Blueprint version Id - Copy", Splitter.SplitTextByDelimiter("/versions/", QuoteStyle.Csv), {"Published Blueprint version Id - Copy.1", "Published Blueprint version Id - Copy.2"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Split Column by Delimiter",{{"Published Blueprint version Id - Copy.2", "Assigned Version"}}),
    #"Renamed Columns1" = Table.RenameColumns(#"Renamed Columns2",{{"Published Blueprint version Id - Copy.1", "Blueprint Id"}}),
    #"Added Conditional Column1" = Table.AddColumn(#"Renamed Columns1", "StateIcon", each if [provisioningState] = "failed" then 0 else 1),
    #"Changed Type" = Table.TransformColumnTypes(#"Added Conditional Column1",{{"StateIcon", Int64.Type}})
in
    #"Changed Type"

// RegulatoryCompliancesPolicies
let
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "ListPolicySets", each ListPolicySets([subscriptionId])),
    #"Removed Columns5" = Table.RemoveColumns(#"Invoked Custom Function",{"authorizationSource", "state", "locationPlacementId", "quotaId", "spendingLimit"}),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Removed Columns5", {"ListPolicySets"}),
    #"Expanded ListPolicySets" = Table.ExpandTableColumn(#"Removed Errors", "ListPolicySets", {"Value"}, {"Value"}),
    #"Expanded Value" = Table.ExpandListColumn(#"Expanded ListPolicySets", "Value"),
    #"Expanded Value1" = Table.ExpandRecordColumn(#"Expanded Value", "Value", {"properties", "id", "name"}, {"properties", "id", "name"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Value1", "properties", {"displayName", "policyType", "description", "metadata", "policyDefinitions"}, {"displayName", "policyType", "description", "metadata", "policyDefinitions"}),
    #"Expanded metadata" = Table.ExpandRecordColumn(#"Expanded properties", "metadata", {"version", "category"}, {"version", "category"}),
    #"Expanded policyDefinitions" = Table.ExpandListColumn(#"Expanded metadata", "policyDefinitions"),
    #"Expanded policyDefinitions1" = Table.ExpandRecordColumn(#"Expanded policyDefinitions", "policyDefinitions", {"policyDefinitionReferenceId", "policyDefinitionId"}, {"policyDefinitionReferenceId", "policyDefinitionId"}),
    #"Duplicated Column1" = Table.DuplicateColumn(#"Expanded policyDefinitions1", "description", "description - Copy"),
    #"Split Column by Delimiter2" = Table.SplitColumn(#"Duplicated Column1", "description - Copy", Splitter.SplitTextByDelimiter("visit", QuoteStyle.Csv), {"description - Copy.1", "description - Copy.2"}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Split Column by Delimiter2",{{"description - Copy.1", type text}, {"description - Copy.2", type text}}),
    #"Removed Columns4" = Table.RemoveColumns(#"Changed Type2",{"description - Copy.1"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns4",{{"description - Copy.2", "URL"}}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Renamed Columns", "URL", "URL - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "URL - Copy", Splitter.SplitTextByDelimiter("https://aka.ms/", QuoteStyle.Csv), {"URL - Copy.1", "URL - Copy.2"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"URL - Copy.1", type text}, {"URL - Copy.2", type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type",{"URL - Copy.1"}),
    #"Added Conditional Column" = Table.AddColumn(#"Removed Columns", "Regulatory Standard Name", each if [#"URL - Copy.2"] = null then [displayName] else [#"URL - Copy.2"]),
    #"Filtered Rows" = Table.SelectRows(#"Added Conditional Column", each true),
    #"Removed Columns1" = Table.RemoveColumns(#"Filtered Rows",{"URL - Copy.2"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns1",{{"id", "policySetDefinitionId"}, {"name", "policySetDefinitionName"}, {"displayName", "Regulatory Standard Long Name"}})
in
    #"Renamed Columns1"

// LastRefresh_Local
let
Source = #table(type table[LastRefresh=datetime], {{DateTime.LocalNow()}}),
    #"Renamed Columns" = Table.RenameColumns(Source,{{"LastRefresh", "Refresh"}})
in
#"Renamed Columns"