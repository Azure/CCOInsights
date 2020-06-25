// All Subscriptions
//Developed by Cristian & Jordi

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
     #"Removed Columns1" = Table.RemoveColumns(#"Expanded subscriptionPolicies",{"tags"}),
     #"Renamed Columns" = Table.RenameColumns(#"Removed Columns1",{{"displayName", "Subscription Name"}}),
     #"Removed Columns2" = Table.RemoveColumns(#"Renamed Columns",{"id"})
 in
     #"Removed Columns2"

// GetManagementURL
let GetManagementBaseUri=(govKind as text) as text =>
    let
        managementUrl = if govKind ="us-government" then "https://management.usgovcloudapi.net"
                    else if govKind="germany-government" then""
                    else if govKind = "china" then "https://management.chinacloudapi.cn"
                    else "https://management.azure.com"

    in
        managementUrl

in GetManagementBaseUri

// AzureKind
"global" meta [IsParameterQuery=true, List={"us-government", "global", "china"}, DefaultValue="global", Type="Text", IsParameterQueryRequired=true]

// Network Interfaces
let
    Source = #"All Subscriptions",
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "ListOfNICs", each ListAllNICs([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListOfNICs"}),
    #"Expanded ListOfNICs" = Table.ExpandTableColumn(#"Removed Errors", "ListOfNICs", {"NIC Name", "NIC Id", "location", "IPConfig Name", "IPConfig Id", "privateIPAddress", "privateIPAllocationMethod", "Subnet Id", "Primary IP", "IP Version", "BackendAddressPool Id", "Public IP Id", "dnsServers", "appliedDnsServers", "internalDomainNameSuffix", "enableAcceleratedNetworking", "enableIPForwarding", "primary", "Virtual Machine Id", "hostedWorkloads", "tapConfigurations", "macAddress", "NSG Id", "VNET Name", "Subnet Name"}, {"NIC Name", "NIC Id", "location", "IPConfig Name", "IPConfig Id", "privateIPAddress", "privateIPAllocationMethod", "Subnet Id", "Primary IP", "IP Version", "BackendAddressPool Id", "Public IP Id", "dnsServers", "appliedDnsServers", "internalDomainNameSuffix", "enableAcceleratedNetworking", "enableIPForwarding", "primary", "Virtual Machine Id", "hostedWorkloads", "tapConfigurations", "macAddress", "NSG Id", "VNET Name", "Subnet Name"})
in
    #"Expanded ListOfNICs"

// ListAllNICs
let ListAllNICs= (SubscriptionId as text) =>
let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
    Fullset = GetPages(GetManagementURL(AzureKind)&"/subscriptions/"&SubscriptionId&"/providers/Microsoft.Network/networkInterfaces?api-version=2018-11-01"),
    #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"name", "id", "location", "properties"}, {"name", "id", "location", "properties"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"name", "NIC Name"}, {"id", "NIC Id"}}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Renamed Columns", "properties", {"ipConfigurations", "dnsSettings", "enableAcceleratedNetworking", "enableIPForwarding", "primary", "virtualMachine", "hostedWorkloads", "tapConfigurations", "macAddress", "networkSecurityGroup"}, {"ipConfigurations", "dnsSettings", "enableAcceleratedNetworking", "enableIPForwarding", "primary", "virtualMachine", "hostedWorkloads", "tapConfigurations", "macAddress", "networkSecurityGroup"}),
    #"Expanded ipConfigurations2" = Table.ExpandListColumn(#"Expanded properties", "ipConfigurations"),
    #"Expanded ipConfigurations3" = Table.ExpandRecordColumn(#"Expanded ipConfigurations2", "ipConfigurations", {"name", "id", "properties"}, {"name", "id", "properties"}),
    #"Expanded properties2" = Table.ExpandRecordColumn(#"Expanded ipConfigurations3", "properties", {"privateIPAddress", "privateIPAllocationMethod", "subnet", "primary", "privateIPAddressVersion", "loadBalancerBackendAddressPools", "publicIPAddress"}, {"privateIPAddress", "privateIPAllocationMethod", "subnet", "primary.1", "privateIPAddressVersion", "loadBalancerBackendAddressPools", "publicIPAddress"}),
    #"Expanded subnet" = Table.ExpandRecordColumn(#"Expanded properties2", "subnet", {"id"}, {"id.1"}),
    #"Expanded loadBalancerBackendAddressPools" = Table.ExpandListColumn(#"Expanded subnet", "loadBalancerBackendAddressPools"),
    #"Expanded loadBalancerBackendAddressPools1" = Table.ExpandRecordColumn(#"Expanded loadBalancerBackendAddressPools", "loadBalancerBackendAddressPools", {"id"}, {"id.2"}),
    #"Expanded publicIPAddress" = Table.ExpandRecordColumn(#"Expanded loadBalancerBackendAddressPools1", "publicIPAddress", {"id"}, {"id.3"}),
    #"Expanded dnsSettings" = Table.ExpandRecordColumn(#"Expanded publicIPAddress", "dnsSettings", {"dnsServers", "appliedDnsServers", "internalDomainNameSuffix"}, {"dnsServers", "appliedDnsServers", "internalDomainNameSuffix"}),
    #"Expanded dnsServers" = Table.ExpandListColumn(#"Expanded dnsSettings", "dnsServers"),
    #"Expanded appliedDnsServers" = Table.ExpandListColumn(#"Expanded dnsServers", "appliedDnsServers"),
    #"Expanded virtualMachine" = Table.ExpandRecordColumn(#"Expanded appliedDnsServers", "virtualMachine", {"id"}, {"id.4"}),
    #"Expanded hostedWorkloads" = Table.ExpandListColumn(#"Expanded virtualMachine", "hostedWorkloads"),
    #"Expanded tapConfigurations" = Table.ExpandListColumn(#"Expanded hostedWorkloads", "tapConfigurations"),
    #"Expanded networkSecurityGroup" = Table.ExpandRecordColumn(#"Expanded tapConfigurations", "networkSecurityGroup", {"id"}, {"id.5"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded networkSecurityGroup",{{"name", "IPConfig Name"}, {"id", "IPConfig Id"}, {"id.1", "Subnet Id"}, {"primary.1", "Primary IP"}, {"privateIPAddressVersion", "IP Version"}, {"id.2", "BackendAddressPool Id"}, {"id.3", "Public IP Id"}, {"id.4", "Virtual Machine Id"}, {"id.5", "NSG Id"}}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Renamed Columns1", "Subnet Id", "Subnet Id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "Subnet Id - Copy", Splitter.SplitTextByEachDelimiter({"/"}, QuoteStyle.Csv, true), {"Subnet Id - Copy.1", "Subnet Id - Copy.2"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Subnet Id - Copy.1", type text}, {"Subnet Id - Copy.2", type text}}),
    #"Renamed Columns2" = Table.RenameColumns(#"Changed Type",{{"Subnet Id - Copy.2", "Subnet Name"}}),
    #"Split Column by Delimiter1" = Table.SplitColumn(#"Renamed Columns2", "Subnet Id - Copy.1", Splitter.SplitTextByEachDelimiter({"/"}, QuoteStyle.Csv, true), {"Subnet Id - Copy.1.1", "Subnet Id - Copy.1.2"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Split Column by Delimiter1",{{"Subnet Id - Copy.1.1", type text}, {"Subnet Id - Copy.1.2", type text}}),
    #"Renamed Columns3" = Table.RenameColumns(#"Changed Type1",{{"Subnet Id - Copy.1.1", "VNET Id"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns3",{"Subnet Id - Copy.1.2"}),
    #"Split Column by Delimiter2" = Table.SplitColumn(#"Removed Columns", "VNET Id", Splitter.SplitTextByEachDelimiter({"/"}, QuoteStyle.Csv, true), {"VNET Id.1", "VNET Id.2"}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Split Column by Delimiter2",{{"VNET Id.1", type text}, {"VNET Id.2", type text}}),
    #"Renamed Columns4" = Table.RenameColumns(#"Changed Type2",{{"VNET Id.2", "VNET Name"}, {"VNET Id.1", "VNET Id"}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Renamed Columns4",{"VNET Id"})
in
    #"Removed Columns1"
in
    ListAllNICs

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
let ListResourceGroups= (SubscriptionId as text) =>
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

// Resources
let
    Source = #"All Subscriptions",
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "ListOfResources", each ListResources([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListOfResources"}),
    #"Expanded ListOfResources" = Table.ExpandTableColumn(#"Removed Errors", "ListOfResources", {"Resource Id", "Resource Name", "Resource Type", "location", "IsTagged", "Resource Group Id", "Resource Group Name"}, {"Resource Id", "Resource Name", "Resource Type", "location", "IsTagged", "Resource Group Id", "Resource Group Name"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded ListOfResources", each [Resource Id] <> null and [Resource Id] <> ""),
    #"Added Conditional Column" = Table.AddColumn(#"Filtered Rows", "IsTagged?", each if [IsTagged] = "Tagged" then 1 else 0),
    #"Duplicated Column" = Table.DuplicateColumn(#"Added Conditional Column", "Resource Type", "Resource Type - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "Resource Type - Copy", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"Resource Type - Copy.1", "Resource Type - Copy.2", "Resource Type - Copy.3"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Resource Type - Copy.1", type text}, {"Resource Type - Copy.2", type text}, {"Resource Type - Copy.3", type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type",{"Resource Type - Copy.1", "Resource Type - Copy.3"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"Resource Type - Copy.2", "Resource Type for Usage"}})
in
    #"Renamed Columns1"

// ListResources
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

// Public IPs
let
    Source = #"All Subscriptions",
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "ListPublicIPs", each ListPublicIPs([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListPublicIPs"}),
    #"Expanded ListPublicIPs" = Table.ExpandTableColumn(#"Removed Errors", "ListPublicIPs", {"Public IP Name", "Public IP Resource Id", "location", "provisioningState", "resourceGuid", "ipAddress", "publicIPAddressVersion", "publicIPAllocationMethod", "idleTimeoutInMinutes", "domainNameLabel", "fqdn", "ipTags", "IP Configuration Id", "type", "sku", "Resource Group Id"}, {"Public IP Name", "Public IP Resource Id", "location", "provisioningState", "resourceGuid", "ipAddress", "publicIPAddressVersion", "publicIPAllocationMethod", "idleTimeoutInMinutes", "domainNameLabel", "fqdn", "ipTags", "IP Configuration Id", "type", "sku", "Resource Group Id"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded ListPublicIPs",{{"ipAddress", "Public IP Address"}})
in
    #"Renamed Columns1"

// ListPublicIPs
let ListPublicIPs = (SubscriptionId as text) =>
let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
    Fullset = GetPages(GetManagementURL(AzureKind)&"/subscriptions/"&SubscriptionId&"/providers/Microsoft.Network/publicIPAddresses?api-version=2017-10-01"),
    #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"name", "id", "location", "properties", "type", "sku", "tags"}, {"name", "id", "location", "properties", "type", "sku", "tags"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"name", "Public IP Name"}, {"id", "Public IP Resource Id"}}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Renamed Columns", "properties", {"provisioningState", "resourceGuid", "ipAddress", "publicIPAddressVersion", "publicIPAllocationMethod", "idleTimeoutInMinutes", "dnsSettings", "ipTags", "ipConfiguration"}, {"provisioningState", "resourceGuid", "ipAddress", "publicIPAddressVersion", "publicIPAllocationMethod", "idleTimeoutInMinutes", "dnsSettings", "ipTags", "ipConfiguration"}),
    #"Expanded dnsSettings" = Table.ExpandRecordColumn(#"Expanded properties", "dnsSettings", {"domainNameLabel", "fqdn"}, {"domainNameLabel", "fqdn"}),
    #"Expanded ipTags" = Table.ExpandListColumn(#"Expanded dnsSettings", "ipTags"),
    #"Expanded ipConfiguration" = Table.ExpandRecordColumn(#"Expanded ipTags", "ipConfiguration", {"id"}, {"id"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded ipConfiguration",{{"id", "IP Configuration Id"}}),
    #"Expanded sku" = Table.ExpandRecordColumn(#"Renamed Columns1", "sku", {"name"}, {"name"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Expanded sku",{{"name", "sku"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns2",{"tags"}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Removed Columns", "Public IP Resource Id", "Public IP Resource Id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "Public IP Resource Id - Copy", Splitter.SplitTextByDelimiter("/providers", QuoteStyle.Csv), {"Public IP Resource Id - Copy.1", "Public IP Resource Id - Copy.2"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Public IP Resource Id - Copy.1", type text}, {"Public IP Resource Id - Copy.2", type text}}),
    #"Renamed Columns3" = Table.RenameColumns(#"Changed Type",{{"Public IP Resource Id - Copy.1", "Resource Group Id"}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Renamed Columns3",{"Public IP Resource Id - Copy.2"})
in
    #"Removed Columns1"


in
    ListPublicIPs

// Virtual Machines
let
    Source = #"All Subscriptions",
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "ListVirtualMachines", each ListVirtualMachines([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListVirtualMachines"}),
    #"Expanded ListVirtualMachines" = Table.ExpandTableColumn(#"Removed Errors", "ListVirtualMachines", {"Availability Set Id", "vmSize", "publisher", "offer", "sku", "version", "osType", "name", "createOption", "vhd uri", "caching", "diskSizeGB", "storageAccountType", "Managed Disk Id", "lun", "name.1", "createOption.1", "Data vhd uri", "caching.1", "diskSizeGB.1", "computerName", "adminUsername", "provisionVMAgent", "enableAutomaticUpdates", "Network Inteface Id", "provisioningState", "enabled", "storageUri", "Extensions Resource Id", "type", "location", "creationSource", "orchestrator", "poolName", "resourceNameSuffix", "VM Resource Id", "VM Name"}, {"Availability Set Id", "vmSize", "publisher", "offer", "sku", "version", "osType", "name", "createOption", "vhd uri", "caching", "diskSizeGB", "storageAccountType", "Managed Disk Id", "lun", "name.1", "createOption.1", "Data vhd uri", "caching.1", "diskSizeGB.1", "computerName", "adminUsername", "provisionVMAgent", "enableAutomaticUpdates", "Network Inteface Id", "provisioningState", "enabled", "storageUri", "Extensions Resource Id", "type", "location", "creationSource", "orchestrator", "poolName", "resourceNameSuffix", "VM Resource Id", "VM Name"}),
    #"Removed Duplicates" = Table.Distinct(#"Expanded ListVirtualMachines", {"VM Resource Id"}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Removed Duplicates", "VM Resource Id", "VM Resource Id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "VM Resource Id - Copy", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"VM Resource Id - Copy.1", "VM Resource Id - Copy.2", "VM Resource Id - Copy.3", "VM Resource Id - Copy.4", "VM Resource Id - Copy.5", "VM Resource Id - Copy.6", "VM Resource Id - Copy.7", "VM Resource Id - Copy.8", "VM Resource Id - Copy.9"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"VM Resource Id - Copy.1", type text}, {"VM Resource Id - Copy.2", type text}, {"VM Resource Id - Copy.3", type text}, {"VM Resource Id - Copy.4", type text}, {"VM Resource Id - Copy.5", type text}, {"VM Resource Id - Copy.6", type text}, {"VM Resource Id - Copy.7", type text}, {"VM Resource Id - Copy.8", type text}, {"VM Resource Id - Copy.9", type text}}),
    #"Renamed Columns1" = Table.RenameColumns(#"Changed Type",{{"VM Resource Id - Copy.5", "Resource Group Name"}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Renamed Columns1",{"VM Resource Id - Copy.1", "VM Resource Id - Copy.2", "VM Resource Id - Copy.3", "VM Resource Id - Copy.4", "VM Resource Id - Copy.6", "VM Resource Id - Copy.7", "VM Resource Id - Copy.8", "VM Resource Id - Copy.9"}),
    #"Added Conditional Column" = Table.AddColumn(#"Removed Columns1", "Is Using Managed Disks", each if [Managed Disk Id] = null then false else true),
    #"Duplicated Column1" = Table.DuplicateColumn(#"Added Conditional Column", "Extensions Resource Id", "Extensions Resource Id - Copy"),
    #"Split Column by Delimiter1" = Table.SplitColumn(#"Duplicated Column1", "Extensions Resource Id - Copy", Splitter.SplitTextByDelimiter("/extensions/", QuoteStyle.Csv), {"Extensions Resource Id - Copy.1", "Extensions Resource Id - Copy.2"}),
    #"Removed Columns2" = Table.RemoveColumns(#"Split Column by Delimiter1",{"Extensions Resource Id - Copy.1"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Removed Columns2",{{"Extensions Resource Id - Copy.2", "VM Extension"}}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Renamed Columns2",{{"creationSource", type text}}),
    #"Replaced Value1" = Table.ReplaceValue(#"Changed Type2",null,"noContainers",Replacer.ReplaceValue,{"creationSource"}),
    #"Added Conditional Column1" = Table.AddColumn(#"Replaced Value1", "IsRunningContainers", each if [creationSource] = "noContainers" then "VM without Containers" else "VM with Containers"),
    #"Replaced Value" = Table.ReplaceValue(#"Added Conditional Column1",null,"Custom",Replacer.ReplaceValue,{"offer"}),
    #"Added Conditional Column2" = Table.AddColumn(#"Replaced Value", "OS Type", each if [osType] = "Windows" then "https://azure.github.io/ccodashboard/assets/pictures/001_Compute_WindowsLogo.svg" else if [osType] = "Linux" then "https://azure.github.io/ccodashboard/assets/pictures/002_Compute_LinuxLogo.svg" else null),
    #"Changed Type1" = Table.TransformColumnTypes(#"Added Conditional Column2",{{"OS Type", type text}, {"Is Using Managed Disks", type text}}),
    #"Replaced Value2" = Table.ReplaceValue(#"Changed Type1","false","0",Replacer.ReplaceText,{"Is Using Managed Disks"}),
    #"Replaced Value3" = Table.ReplaceValue(#"Replaced Value2","true","1",Replacer.ReplaceText,{"Is Using Managed Disks"})
in
    #"Replaced Value3"

// ListVirtualMachines
let ListVirtualMachines = (SubscriptionId as text) =>
let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
    Fullset = GetPages(GetManagementURL(AzureKind)&"/subscriptions/"&SubscriptionId&"/providers/Microsoft.Compute/virtualMachines?api-version=2017-12-01"),
    #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"properties", "resources", "type", "location", "tags", "id", "name"}, {"properties", "resources", "type", "location", "tags", "id", "name"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"id", "VM Resource Id"}, {"name", "VM Name"}}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Renamed Columns", "properties", {"vmId", "availabilitySet", "hardwareProfile", "storageProfile", "osProfile", "networkProfile", "provisioningState", "diagnosticsProfile"}, {"vmId", "availabilitySet", "hardwareProfile", "storageProfile", "osProfile", "networkProfile", "provisioningState", "diagnosticsProfile"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded properties",{"vmId"}),
    #"Expanded availabilitySet" = Table.ExpandRecordColumn(#"Removed Columns", "availabilitySet", {"id"}, {"id"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded availabilitySet",{{"id", "Availability Set Id"}}),
    #"Expanded hardwareProfile" = Table.ExpandRecordColumn(#"Renamed Columns1", "hardwareProfile", {"vmSize"}, {"vmSize"}),
    #"Expanded storageProfile" = Table.ExpandRecordColumn(#"Expanded hardwareProfile", "storageProfile", {"imageReference", "osDisk", "dataDisks"}, {"imageReference", "osDisk", "dataDisks"}),
    #"Expanded imageReference" = Table.ExpandRecordColumn(#"Expanded storageProfile", "imageReference", {"publisher", "offer", "sku", "version"}, {"publisher", "offer", "sku", "version"}),
    #"Expanded osDisk" = Table.ExpandRecordColumn(#"Expanded imageReference", "osDisk", {"osType", "name", "createOption", "vhd", "caching", "diskSizeGB", "managedDisk"}, {"osType", "name", "createOption", "vhd", "caching", "diskSizeGB", "managedDisk"}),
    #"Expanded vhd" = Table.ExpandRecordColumn(#"Expanded osDisk", "vhd", {"uri"}, {"uri"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Expanded vhd",{{"uri", "vhd uri"}}),
    #"Expanded managedDisk" = Table.ExpandRecordColumn(#"Renamed Columns2", "managedDisk", {"storageAccountType", "id"}, {"storageAccountType", "id"}),
    #"Renamed Columns3" = Table.RenameColumns(#"Expanded managedDisk",{{"id", "Managed Disk Id"}}),
    #"Expanded dataDisks" = Table.ExpandListColumn(#"Renamed Columns3", "dataDisks"),
    #"Expanded dataDisks1" = Table.ExpandRecordColumn(#"Expanded dataDisks", "dataDisks", {"lun", "name", "createOption", "vhd", "caching", "diskSizeGB"}, {"lun", "name.1", "createOption.1", "vhd", "caching.1", "diskSizeGB.1"}),
    #"Expanded vhd1" = Table.ExpandRecordColumn(#"Expanded dataDisks1", "vhd", {"uri"}, {"uri"}),
    #"Renamed Columns4" = Table.RenameColumns(#"Expanded vhd1",{{"uri", "Data vhd uri"}}),
    #"Expanded osProfile" = Table.ExpandRecordColumn(#"Renamed Columns4", "osProfile", {"computerName", "adminUsername", "linuxConfiguration", "secrets", "windowsConfiguration"}, {"computerName", "adminUsername", "linuxConfiguration", "secrets", "windowsConfiguration"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Expanded osProfile",{"linuxConfiguration", "secrets"}),
    #"Expanded windowsConfiguration" = Table.ExpandRecordColumn(#"Removed Columns1", "windowsConfiguration", {"provisionVMAgent", "enableAutomaticUpdates"}, {"provisionVMAgent", "enableAutomaticUpdates"}),
    #"Expanded networkProfile" = Table.ExpandRecordColumn(#"Expanded windowsConfiguration", "networkProfile", {"networkInterfaces"}, {"networkInterfaces"}),
    #"Expanded networkInterfaces" = Table.ExpandListColumn(#"Expanded networkProfile", "networkInterfaces"),
    #"Expanded networkInterfaces1" = Table.ExpandRecordColumn(#"Expanded networkInterfaces", "networkInterfaces", {"id"}, {"id"}),
    #"Renamed Columns5" = Table.RenameColumns(#"Expanded networkInterfaces1",{{"id", "Network Inteface Id"}}),
    #"Expanded diagnosticsProfile" = Table.ExpandRecordColumn(#"Renamed Columns5", "diagnosticsProfile", {"bootDiagnostics"}, {"bootDiagnostics"}),
    #"Expanded bootDiagnostics" = Table.ExpandRecordColumn(#"Expanded diagnosticsProfile", "bootDiagnostics", {"enabled", "storageUri"}, {"enabled", "storageUri"}),
    #"Expanded resources" = Table.ExpandListColumn(#"Expanded bootDiagnostics", "resources"),
    #"Expanded resources1" = Table.ExpandRecordColumn(#"Expanded resources", "resources", {"id"}, {"id"}),
    #"Renamed Columns6" = Table.RenameColumns(#"Expanded resources1",{{"id", "Extensions Resource Id"}}),
    #"Expanded tags" = Table.ExpandRecordColumn(#"Renamed Columns6", "tags", {"creationSource", "orchestrator", "poolName", "resourceNameSuffix"}, {"creationSource", "orchestrator", "poolName", "resourceNameSuffix"})
in
    #"Expanded tags"

in
    ListVirtualMachines

// Get Recommendations
let
    Source = #"All Subscriptions",
    #"List Recommendations" = Table.AddColumn(#"All Subscriptions", "ListRecommendations", each ListRecommendations([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"List Recommendations", {"ListRecommendations"}),
    #"Expanded ListRecommendations" = Table.ExpandTableColumn(#"Removed Errors", "ListRecommendations", {"category", "impact", "impactedField", "impactedValue", "lastUpdated", "recommendationTypeId", "problem", "solution", "assessmentKey", "score", "clusterName", "region.1", "vmSku", "instanceCount", "savingsAmount", "annualSavingsAmount", "savingsCurrency", "recGeneratedOn", "ServerName", "DatabaseName", "IsInReplication", "ResourceGroup", "DatabaseSize", "Region", "ObservationPeriodStartDate", "ObservationPeriodEndDate", "Recommended_DTU", "Recommended_SKU", "HasRecommendation", "id", "name"}, {"category", "impact", "impactedField", "impactedValue", "lastUpdated", "recommendationTypeId", "problem", "solution", "assessmentKey", "score", "clusterName", "region.1", "vmSku", "instanceCount", "savingsAmount", "annualSavingsAmount", "savingsCurrency", "recGeneratedOn", "ServerName", "DatabaseName", "IsInReplication", "ResourceGroup", "DatabaseSize", "Region", "ObservationPeriodStartDate", "ObservationPeriodEndDate", "Recommended_DTU", "Recommended_SKU", "HasRecommendation", "id", "name"}),
    #"Removed Columns2" = Table.RemoveColumns(#"Expanded ListRecommendations",{"authorizationSource", "state", "locationPlacementId", "quotaId", "spendingLimit"}),
    #"Added Conditional Column" = Table.AddColumn(#"Removed Columns2", "Recommendation URL", each if [category] = "Security" then "https://docs.microsoft.com/en-us/azure/advisor/advisor-security-recommendations" else if [category] = "HighAvailability" then "https://docs.microsoft.com/en-us/azure/advisor/advisor-high-availability-recommendations" else if [category] = "Cost" then "https://docs.microsoft.com/en-us/azure/advisor/advisor-cost-recommendations" else if [category] = "Performance" then "https://docs.microsoft.com/en-us/azure/advisor/advisor-performance-recommendations" else if [category] = "OperationalExcellence" then "https://docs.microsoft.com/en-us/azure/advisor/advisor-operational-excellence-recommendations" else null),
    #"Changed Type" = Table.TransformColumnTypes(#"Added Conditional Column",{{"Recommendation URL", type text}}),
    #"Added Image Column1" = Table.AddColumn(#"Changed Type", "Image", each if [category] = "Security" then "https://azure.github.io/ccodashboard/assets/2020_Icons/AdvisorSecurity.svg" else if [category] = "HighAvailability" then "https://azure.github.io/ccodashboard/assets/2020_Icons/AdvisorHighAvailability.svg" else if [category] = "OperationalExcellence" then "https://azure.github.io/ccodashboard/assets/2020_Icons/AdvisorOperationalExcellence.svg" else if [category] = "Cost" then "https://azure.github.io/ccodashboard/assets/2020_Icons/AdvisorCost.svg" else if [category] = "Performance" then "https://azure.github.io/ccodashboard/assets/2020_Icons/AdvisorPerformance.svg" else "https://azure.github.io/ccodashboard/assets/pictures/034_ASCTasks_NinjaCat.svg"),
    #"Filtered Rows1" = Table.SelectRows(#"Added Image Column1", each [impactedField] <> null and [impactedField] <> ""),
    #"Duplicated Column" = Table.DuplicateColumn(#"Filtered Rows1", "id", "id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "id - Copy", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"id - Copy.1", "id - Copy.2", "id - Copy.3", "id - Copy.4", "id - Copy.5", "id - Copy.6", "id - Copy.7", "id - Copy.8", "id - Copy.9", "id - Copy.10", "id - Copy.11", "id - Copy.12", "id - Copy.13", "id - Copy.14", "id - Copy.15"}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"id - Copy.1", type text}, {"id - Copy.2", type text}, {"id - Copy.3", type text}, {"id - Copy.4", type text}, {"id - Copy.5", type text}, {"id - Copy.6", type text}, {"id - Copy.7", type text}, {"id - Copy.8", type text}, {"id - Copy.9", type text}, {"id - Copy.10", type text}, {"id - Copy.11", type text}, {"id - Copy.12", type text}, {"id - Copy.13", type text}, {"id - Copy.14", type text}, {"id - Copy.15", type text}}),
    #"Renamed Columns1" = Table.RenameColumns(#"Changed Type2",{{"id - Copy.5", "Resource Group Name"}, {"id - Copy.8", "Resource Type"}, {"id - Copy.9", "Resource Name"}, {"id - Copy.11", "Subnet"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns1",{"id - Copy.1", "id - Copy.2", "id - Copy.3", "id - Copy.4", "id - Copy.6", "id - Copy.7", "id - Copy.10", "id - Copy.12", "id - Copy.13", "id - Copy.14", "id - Copy.15"}),
    #"Replaced Value" = Table.ReplaceValue(#"Removed Columns",null,"Subscription",Replacer.ReplaceValue,{"Resource Type"}),
    #"Added Conditional Column2" = Table.AddColumn(#"Replaced Value", "Resource Name Final", each if [Resource Name] = null then [Subscription Name] else [Resource Name]),
    #"Replaced Value1" = Table.ReplaceValue(#"Added Conditional Column2","Configure DNS Time to Live to 60 seconds","Time to Live (TTL) affects how recent of a response a client will get when it makes a request to Azure Traffic Manager. Reducing the TTL value means that the client will be routed to a functioning endpoint faster in the case of a failover. Configure your TTL to 60 seconds to route traffic to a health endpoint as quickly as possible.",Replacer.ReplaceText,{"solution"}),
    #"Replaced Value2" = Table.ReplaceValue(#"Replaced Value1","Add at least one more endpoint to the profile, preferably in another Azure region","Profiles should have more than one endpoint to ensure availability if one of the endpoints fails. It is also recommended that endpoints be in different regions",Replacer.ReplaceText,{"solution"}),
    #"Replaced Value3" = Table.ReplaceValue(#"Replaced Value2","Add an endpoint configured to ""All (World)""","For geographic routing, traffic is routed to endpoints based on defined regions. When a region fails, there is no pre-defined failover. Having an endpoint where the Regional Grouping is configured to \""All (World)\"" for geographic profiles will avoid traffic black holing and guarantee service remains available.",Replacer.ReplaceText,{"solution"}),
    #"Replaced Value4" = Table.ReplaceValue(#"Replaced Value3","Create an Azure service health alert","Service health alerts help you stay notified when Azure service issues affect you. Create a service health alert for the regions and services that you care about",Replacer.ReplaceText,{"solution"}),
    #"Replaced Value5" = Table.ReplaceValue(#"Replaced Value4","Right-size underutilized SQL Databases","We've analyzed the DTU consumption of your SQL Database over the past 14 days and identified SQL Databases with low usage. You can save money by right-sizing to the recommended SKU based on the 95th percentile of your every day workload",Replacer.ReplaceText,{"solution"}),
    #"Duplicated Column1" = Table.DuplicateColumn(#"Replaced Value5", "id", "Recommendation Id - Copy"),
    #"Split Column by Delimiter1" = Table.SplitColumn(#"Duplicated Column1", "Recommendation Id - Copy", Splitter.SplitTextByDelimiter("/providers/Microsoft.Advisor", QuoteStyle.Csv), {"Recommendation Id - Copy.1", "Recommendation Id - Copy.2"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Split Column by Delimiter1",{{"Recommendation Id - Copy.1", type text}, {"Recommendation Id - Copy.2", type text}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Changed Type1",{"Recommendation Id - Copy.2"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Removed Columns1",{{"Recommendation Id - Copy.1", "Resource Id"}}),
    #"Changed Type with Locale" = Table.TransformColumnTypes(#"Renamed Columns2", {{"savingsAmount", Currency.Type}}, "en-US"),
    #"Changed Type with Locale1" = Table.TransformColumnTypes(#"Changed Type with Locale", {{"annualSavingsAmount", Currency.Type}}, "en-US")
in
    #"Changed Type with Locale1"

// ListRecommendations
let ListRecommendations = (SubscriptionId as text) =>
let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
    Fullset = GetPages(GetManagementURL(AzureKind)&"/subscriptions/"&SubscriptionId&"/providers/Microsoft.Advisor/recommendations?api-version=2020-01-01"),
    #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"properties", "id"}, {"properties", "id"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column1", "properties", {"category", "impact", "impactedField", "impactedValue", "lastUpdated", "recommendationTypeId", "shortDescription", "extendedProperties"}, {"category", "impact", "impactedField", "impactedValue", "lastUpdated", "recommendationTypeId", "shortDescription", "extendedProperties"}),
    #"Expanded shortDescription" = Table.ExpandRecordColumn(#"Expanded properties", "shortDescription", {"problem", "solution"}, {"problem", "solution"}),
    #"Expanded extendedProperties" = Table.ExpandRecordColumn(#"Expanded shortDescription", "extendedProperties", {"assessmentKey", "score", "clusterName", "region", "vmSku", "instanceCount", "savingsAmount", "annualSavingsAmount", "savingsCurrency", "recGeneratedOn", "ServerName", "DatabaseName", "IsInReplication", "ResourceGroup", "DatabaseSize", "Region", "ObservationPeriodStartDate", "ObservationPeriodEndDate", "Recommended_DTU", "Recommended_SKU", "HasRecommendation"}, {"assessmentKey", "score", "clusterName", "region.1", "vmSku", "instanceCount", "savingsAmount", "annualSavingsAmount", "savingsCurrency", "recGeneratedOn", "ServerName", "DatabaseName", "IsInReplication", "ResourceGroup", "DatabaseSize", "Region", "ObservationPeriodStartDate", "ObservationPeriodEndDate", "Recommended_DTU", "Recommended_SKU", "HasRecommendation"})
in
    #"Expanded extendedProperties"
in
    ListRecommendations

// Get Security Center Alerts
let
    Source = #"All Subscriptions",
    #"Renamed Columns" = Table.RenameColumns(Source,{{"state", "Subscription.state"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "ListSecurityCenterAlerts", each ListSecurityCenterAlerts([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListSecurityCenterAlerts"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Removed Errors",{{"state", "Subscription.state"}}),
    #"Expanded ListSecurityCenterAlerts" = Table.ExpandTableColumn(#"Renamed Columns2", "ListSecurityCenterAlerts", {"Alert Id", "alertDisplayName", "alertName", "detectedTimeUtc", "description", "remediationSteps", "actionTaken", "reportedSeverity", "compromisedEntity", "associatedResource", "subscriptionId", "instanceId", "alert Start Time (UTC)", "source", "non-Existent Users", "existing Users", "failed Attempts", "successful Logins", "successful User Logons", "account Logon Ids", "failed User Logons", "end Time UTC", "enrichment_tas_threat__reports", "state", "reportedTimeUtc", "workspaceArmId", "confidenceReasons", "canBeInvestigated", "Unique Alert Id", "Resource Type", "dnsDomain", "hostName", "azureID", "omsAgentID", "name.1", "address"}, {"Alert Id", "alertDisplayName", "alertName", "detectedTimeUtc", "description", "remediationSteps", "actionTaken", "reportedSeverity", "compromisedEntity", "associatedResource", "subscriptionId.1", "instanceId", "alert Start Time (UTC)", "source", "non-Existent Users", "existing Users", "failed Attempts", "successful Logins", "successful User Logons", "account Logon Ids", "failed User Logons", "end Time UTC", "enrichment_tas_threat__reports", "state", "reportedTimeUtc", "workspaceArmId", "confidenceReasons", "canBeInvestigated", "Unique Alert Id", "Resource Type", "dnsDomain", "hostName", "azureID", "omsAgentID", "name.1", "address"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded ListSecurityCenterAlerts",{{"alertDisplayName", "Attack Type"}, {"compromisedEntity", "Impacted Resource"}, {"remediationSteps", "Potential Remediation"}, {"detectedTimeUtc", "Detected Time UTC"}, {"end Time UTC", "End Time UTC"}, {"source", "Attack Source IP Address"}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Renamed Columns1",{{"Detected Time UTC", type datetime}}),
    #"Added AttackImage Column" = Table.AddColumn(#"Changed Type", "AttackImage", each if Text.Contains([Attack Type], "Failed RDP Brute Force Attack") then "https://rawhttps://azure.github.io/ccodashboard/assets/pictures/000_ASCAlerts_UnderAttack.svg" else if Text.Contains([Attack Type], "Possible incoming SQL brute force") then "https://azure.github.io/ccodashboard/assets/pictures/001_ASCAlerts_SQLUnderAttack.svg" else if Text.Contains([Attack Type], "network activity") then "https://azure.github.io/ccodashboard/assets/pictures/002_ASCAlerts_SubnetUnderAttack.svg" else if Text.Contains([Attack Type], "Suspicious authentication activity") then "https://azure.github.io/ccodashboard/assets/pictures/003_ASCAlerts_Suspicious.svg" else if Text.Contains([Attack Type], "[Preview] ") then "https://azure.github.io/ccodashboard/assets/pictures/004_ASCAlerts_Preview.svg" else "https://azure.github.io/ccodashboard/assets/pictures/034_ASCTasks_NinjaCat.svg"),
    #"Removed Errors1" = Table.RemoveRowsWithErrors(#"Added AttackImage Column", {"AttackImage"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Removed Errors1",{{"Potential Remediation", type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type1",{"confidenceReasons"})
in
    #"Removed Columns"

// ListSecurityCenterAlerts
let ListSecurityCenterAlerts = (subscriptionId as text) =>
let
    url = GetManagementURL(AzureKind)&"/subscriptions/"&subscriptionId&"/providers/microsoft.Security/alerts?api-version=2015-06-01-preview",
    iterations = 10,
    FuncGetOnePage = (url) as record =>
    let 
       Source = Json.Document(Web.Contents(url)),
       data = try Source[value] otherwise null,
       next = try Source[nextLink] otherwise null,
       res = [Data=data, Next=next]
    in
        res,
        GeneratedListOfPages = List.Generate(()=>[i=0, res = FuncGetOnePage(url)],
        each [i]<iterations and [res][Data]<>null,
        each [i=[i]+1, res = FuncGetOnePage([res][Next])],
        each [res][Data]),

    #"Converted to Table" = Table.FromList(GeneratedListOfPages, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandListColumn(#"Converted to Table", "Column1"),
    #"Expanded Column2" = Table.ExpandRecordColumn(#"Expanded Column1", "Column1", {"id", "name", "type", "properties"}, {"id", "name", "type", "properties"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column2", "properties", {"vendorName", "alertDisplayName", "alertName", "detectedTimeUtc", "description", "remediationSteps", "actionTaken", "reportedSeverity", "compromisedEntity", "associatedResource", "subscriptionId", "instanceId", "extendedProperties", "state", "reportedTimeUtc", "workspaceArmId", "confidenceReasons", "canBeInvestigated", "entities"}, {"vendorName", "alertDisplayName", "alertName", "detectedTimeUtc", "description", "remediationSteps", "actionTaken", "reportedSeverity", "compromisedEntity", "associatedResource", "subscriptionId", "instanceId", "extendedProperties", "state", "reportedTimeUtc", "workspaceArmId", "confidenceReasons", "canBeInvestigated", "entities"}),
    #"Expanded extendedProperties" = Table.ExpandRecordColumn(#"Expanded properties", "extendedProperties", {"alert Start Time (UTC)", "source", "non-Existent Users", "existing Users", "failed Attempts", "successful Logins", "successful User Logons", "account Logon Ids", "failed User Logons", "end Time UTC", "enrichment_tas_threat__reports"}, {"alert Start Time (UTC)", "source", "non-Existent Users", "existing Users", "failed Attempts", "successful Logins", "successful User Logons", "account Logon Ids", "failed User Logons", "end Time UTC", "enrichment_tas_threat__reports"}),
    #"Extracted Values" = Table.TransformColumns(#"Expanded extendedProperties", {"confidenceReasons", each Text.Combine(List.Transform(_, Text.From)), type text}),
    #"Expanded entities" = Table.ExpandListColumn(#"Extracted Values", "entities"),
    #"Expanded entities1" = Table.ExpandRecordColumn(#"Expanded entities", "entities", {"$id", "type", "dnsDomain", "hostName", "azureID", "omsAgentID", "name", "address"}, {"$id", "type.1", "dnsDomain", "hostName", "azureID", "omsAgentID", "name.1", "address"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded entities1",{{"id", "Alert Id"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns",{"name", "type", "vendorName"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"type.1", "Resource Type"}, {"$id", "Unique Alert Id"}})
in
    #"Renamed Columns1"
in
    ListSecurityCenterAlerts

// Azure Regions
let
    Source = #"All Subscriptions",
    #"List AzureLocations" = Table.AddColumn(#"All Subscriptions", " ListAzureLocations", each  ListAzureLocations([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"List AzureLocations", {" ListAzureLocations"}),
    #"Expanded  ListAzureLocations" = Table.ExpandTableColumn(#"Removed Errors", " ListAzureLocations", {"Name", "Value.id", "Value.name", "Value.displayName", "Value.longitude", "Value.latitude"}, {" ListAzureLocations.Name", " ListAzureLocations.Value.id", " ListAzureLocations.Value.name", " ListAzureLocations.Value.displayName", " ListAzureLocations.Value.longitude", " ListAzureLocations.Value.latitude"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded  ListAzureLocations",{" ListAzureLocations.Name", " ListAzureLocations.Value.id"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{" ListAzureLocations.Value.name", "AzureLocation"}, {" ListAzureLocations.Value.displayName", "Azure Location Display Name"}, {" ListAzureLocations.Value.longitude", "Longitude"}, {" ListAzureLocations.Value.latitude", "Latitude"}}),
    #"Removed Duplicates" = Table.Distinct(#"Renamed Columns1", {"AzureLocation"})
in
    #"Removed Duplicates"

// ListAzureLocations
let ListAzureLocations = (subscriptionId as text) =>
let
    Source = Json.Document(Web.Contents(GetManagementURL(AzureKind)&"/subscriptions/"&subscriptionId&"/locations?api-version=2016-06-01")),
    #"Converted to Table" = Record.ToTable(Source),
    #"Expanded Value" = Table.ExpandListColumn(#"Converted to Table", "Value"),
    #"Expanded Value1" = Table.ExpandRecordColumn(#"Expanded Value", "Value", {"id", "name", "displayName", "longitude", "latitude"}, {"Value.id", "Value.name", "Value.displayName", "Value.longitude", "Value.latitude"})
in
    #"Expanded Value1"
in 
    ListAzureLocations

// LastRefresh_Local
let
Source = #table(type table[LastRefresh=datetime], {{DateTime.LocalNow()}}),
    #"Renamed Columns" = Table.RenameColumns(Source,{{"LastRefresh", "Refresh"}})
in
#"Renamed Columns"

// ListRBACRoleAssignments
let ListRBACRoleAssignments = (SubscriptionId as text) =>
let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
    Fullset = GetPages(GetManagementURL(AzureKind)&"/subscriptions/"&SubscriptionId&"/providers/Microsoft.Authorization/roleAssignments?api-version=2015-07-01"),
    #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    //#"Expanded Column1" = Table.ExpandListColumn(#"Converted to Table", "Column1"),
    #"Expanded Column2" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"properties", "id", "type", "name"}, {"properties", "id", "type", "name"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column2", "properties", {"roleDefinitionId", "principalId", "scope", "createdOn", "updatedOn", "createdBy", "updatedBy"}, {"roleDefinitionId", "principalId", "scope", "createdOn", "updatedOn", "createdBy", "updatedBy"})
in
    #"Expanded properties"

in
    ListRBACRoleAssignments

// RBAC Role Definitions
let
    Source = #"All Subscriptions",
    #"List RBACRoleDefinitions" = Table.AddColumn(#"All Subscriptions", "ListRBACRoleDefinitions", each ListRBACRoleDefinitions([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"List RBACRoleDefinitions", {"ListRBACRoleDefinitions"}),
    #"Expanded ListRBACRoleDefinitions" = Table.ExpandTableColumn(#"Removed Errors", "ListRBACRoleDefinitions", {"roleName", "type.1", "description", "assignableScopes", "actions", "notActions", "createdOn", "updatedOn", "createdBy", "updatedBy", "id", "type", "name"}, {"roleName", "type.1", "description", "assignableScopes", "actions", "notActions", "createdOn", "updatedOn", "createdBy", "updatedBy", "id", "type", "name"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded ListRBACRoleDefinitions",{{"type.1", "roleType"}, {"id", "roleDefinitionId"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns1",{"type"})
in
    #"Removed Columns"

// ListRBACRoleDefinitions
let ListRBACRoleDefinitions = (subscriptionId as text) =>
let
    url = GetManagementURL(AzureKind)&"/subscriptions/"&subscriptionId&"/providers/Microsoft.Authorization/roleDefinitions?api-version=2015-07-01",
    iterations = 10,
    FuncGetOnePage = (url) as record =>
    let 
       Source = Json.Document(Web.Contents(url)),
       data = try Source[value] otherwise null,
       next = try Source[nextLink] otherwise null,
       res = [Data=data, Next=next]
    in
        res,
        GeneratedListOfPages = List.Generate(()=>[i=0, res = FuncGetOnePage(url)],
        each [i]<iterations and [res][Data]<>null,
        each [i=[i]+1, res = FuncGetOnePage([res][Next])],
        each [res][Data]),

    #"Converted to Table" = Table.FromList(GeneratedListOfPages, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandListColumn(#"Converted to Table", "Column1"),
    #"Expanded Column2" = Table.ExpandRecordColumn(#"Expanded Column1", "Column1", {"properties", "id", "type", "name"}, {"properties", "id", "type", "name"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column2", "properties", {"roleName", "type", "description", "assignableScopes", "permissions", "createdOn", "updatedOn", "createdBy", "updatedBy"}, {"roleName", "type.1", "description", "assignableScopes", "permissions", "createdOn", "updatedOn", "createdBy", "updatedBy"}),
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
    Source = #"All Subscriptions",
    #"List RBACRoleAssignments" = Table.AddColumn(#"All Subscriptions", "ListRBACRoleAssignments", each ListRBACRoleAssignments([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"List RBACRoleAssignments", {"ListRBACRoleAssignments"}),
    #"Expanded ListRBACRoleAssignments" = Table.ExpandTableColumn(#"Removed Errors", "ListRBACRoleAssignments", {"roleDefinitionId", "principalId", "scope", "createdOn", "updatedOn", "createdBy", "updatedBy", "id", "type", "name"}, {"roleDefinitionId", "principalId", "scope", "createdOn", "updatedOn", "createdBy", "updatedBy", "id", "type", "name"}),
    #"Split Column by Delimiter1" = Table.SplitColumn(#"Expanded ListRBACRoleAssignments", "scope", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"scope.1", "scope.2", "scope.3", "scope.4", "scope.5", "scope.6", "scope.7", "scope.8", "scope.9", "scope.10", "scope.11"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Split Column by Delimiter1",{{"scope.5", "Resource Group"}, {"scope.7", "Resource Provider"}, {"scope.8", "Resource Type"}, {"scope.9", "Resource Name"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns2",{"scope.1", "scope.2", "scope.3", "scope.4", "scope.6"}),
    #"Replaced Value" = Table.ReplaceValue(#"Removed Columns",null,"*",Replacer.ReplaceValue,{"Resource Group"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value",null,"*",Replacer.ReplaceValue,{"Resource Provider"}),
    #"Added Conditional Column" = Table.AddColumn(#"Replaced Value1", "Custom", each if [Resource Group] = "*" then "Subscription" else if [Resource Provider] = "*" then "Resource Group" else if [Resource Type] <> null then [Resource Type] else null),
    #"Renamed Columns3" = Table.RenameColumns(#"Added Conditional Column",{{"Resource Type", "Rtype"}, {"Custom", "Resource Type"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns3", "Users", each ListRBACUsers([principalId])),
    #"Removed Errors1" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"Users"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Errors1",{{"state", "Subscription.state"}}),
    #"Expanded Users" = Table.ExpandTableColumn(#"Renamed Columns", "Users", {"odata.type", "objectType", "objectId", "deletionTimestamp", "accountEnabled", "ageGroup", "city", "companyName", "consentProvidedForMinor", "country", "creationType", "department", "dirSyncEnabled", "displayName", "employeeId", "facsimileTelephoneNumber", "givenName", "immutableId", "isCompromised", "jobTitle", "lastDirSyncTime", "legalAgeGroupClassification", "mail", "mailNickname", "mobile", "onPremisesDistinguishedName", "onPremisesSecurityIdentifier", "passwordPolicies", "passwordProfile", "physicalDeliveryOfficeName", "postalCode", "preferredLanguage", "refreshTokensValidFromDateTime", "showInAddressList", "sipProxyAddress", "state", "streetAddress", "surname", "telephoneNumber", "thumbnailPhoto@odata.mediaContentType", "usageLocation", "userPrincipalName", "userType", "extension_18e31482d3fb4a8ea958aa96b662f508_SupervisorInd", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingName", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingID", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToPersonnelNbr", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToFullName", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToEmailName", "extension_18e31482d3fb4a8ea958aa96b662f508_CompanyCode", "extension_18e31482d3fb4a8ea958aa96b662f508_CostCenterCode", "extension_18e31482d3fb4a8ea958aa96b662f508_LocationAreaCode", "extension_18e31482d3fb4a8ea958aa96b662f508_PersonnelNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_PositionNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_ProfitCenterCode"}, {"odata.type", "objectType", "objectId", "deletionTimestamp", "accountEnabled", "ageGroup", "city", "companyName", "consentProvidedForMinor", "country", "creationType", "department", "dirSyncEnabled", "displayName", "employeeId", "facsimileTelephoneNumber", "givenName", "immutableId", "isCompromised", "jobTitle", "lastDirSyncTime", "legalAgeGroupClassification", "mail", "mailNickname", "mobile", "onPremisesDistinguishedName", "onPremisesSecurityIdentifier", "passwordPolicies", "passwordProfile", "physicalDeliveryOfficeName", "postalCode", "preferredLanguage", "refreshTokensValidFromDateTime", "showInAddressList", "sipProxyAddress", "state", "streetAddress", "surname", "telephoneNumber", "thumbnailPhoto@odata.mediaContentType", "usageLocation", "userPrincipalName", "userType", "extension_18e31482d3fb4a8ea958aa96b662f508_SupervisorInd", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingName", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingID", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToPersonnelNbr", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToFullName", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToEmailName", "extension_18e31482d3fb4a8ea958aa96b662f508_CompanyCode", "extension_18e31482d3fb4a8ea958aa96b662f508_CostCenterCode", "extension_18e31482d3fb4a8ea958aa96b662f508_LocationAreaCode", "extension_18e31482d3fb4a8ea958aa96b662f508_PersonnelNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_PositionNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_ProfitCenterCode"})
in
    #"Expanded Users"

// GetGraphURL
let GetGraphBaseUri=(govKind as text) as text =>
    let
        GraphURL = if govKind ="us-government" then "https://graph.microsoft.us"
                    else if govKind="germany-government" then""
                    else if govKind = "china" then "https://graph.chinacloudapi.cn"
                    else "https://graph.windows.net"

    in
        GraphURL

in GetGraphBaseUri

// TenantName
"microsoft.com" meta [IsParameterQuery=true, Type="Text", IsParameterQueryRequired=true]

// ListRBACUsers
let ListRBACUsers = (principalId as text) =>
let
    url = GetGraphURL(AzureKind)&"/"&TenantName&"/users?api-version=1.6&$filter=objectId eq '"&principalId&"'",
    iterations = 10,
    FuncGetOnePage = (url) as record =>
    let 
       Source = Json.Document(Web.Contents(url)),
       data = try Source[value] otherwise null,
       next = try Source[nextLink] otherwise null,
       res = [Data=data, Next=next]
    in
        res,
        GeneratedListOfPages = List.Generate(()=>[i=0, res = FuncGetOnePage(url)],
        each [i]<iterations and [res][Data]<>null,
        each [i=[i]+1, res = FuncGetOnePage([res][Next])],
        each [res][Data]),

    #"Converted to Table" = Table.FromList(GeneratedListOfPages, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandListColumn(#"Converted to Table", "Column1"),
    #"Expanded Column2" = Table.ExpandRecordColumn(#"Expanded Column1", "Column1", {"odata.type", "objectType", "objectId", "deletionTimestamp", "accountEnabled", "ageGroup", "assignedLicenses", "assignedPlans", "city", "companyName", "consentProvidedForMinor", "country", "creationType", "department", "dirSyncEnabled", "displayName", "employeeId", "facsimileTelephoneNumber", "givenName", "immutableId", "isCompromised", "jobTitle", "lastDirSyncTime", "legalAgeGroupClassification", "mail", "mailNickname", "mobile", "onPremisesDistinguishedName", "onPremisesSecurityIdentifier", "otherMails", "passwordPolicies", "passwordProfile", "physicalDeliveryOfficeName", "postalCode", "preferredLanguage", "provisionedPlans", "provisioningErrors", "proxyAddresses", "refreshTokensValidFromDateTime", "showInAddressList", "signInNames", "sipProxyAddress", "state", "streetAddress", "surname", "telephoneNumber", "thumbnailPhoto@odata.mediaContentType", "usageLocation", "userIdentities", "userPrincipalName", "userType", "extension_18e31482d3fb4a8ea958aa96b662f508_SupervisorInd", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingName", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingID", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToPersonnelNbr", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToFullName", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToEmailName", "extension_18e31482d3fb4a8ea958aa96b662f508_CompanyCode", "extension_18e31482d3fb4a8ea958aa96b662f508_CostCenterCode", "extension_18e31482d3fb4a8ea958aa96b662f508_LocationAreaCode", "extension_18e31482d3fb4a8ea958aa96b662f508_PersonnelNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_PositionNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_ProfitCenterCode"}, {"odata.type", "objectType", "objectId", "deletionTimestamp", "accountEnabled", "ageGroup", "assignedLicenses", "assignedPlans", "city", "companyName", "consentProvidedForMinor", "country", "creationType", "department", "dirSyncEnabled", "displayName", "employeeId", "facsimileTelephoneNumber", "givenName", "immutableId", "isCompromised", "jobTitle", "lastDirSyncTime", "legalAgeGroupClassification", "mail", "mailNickname", "mobile", "onPremisesDistinguishedName", "onPremisesSecurityIdentifier", "otherMails", "passwordPolicies", "passwordProfile", "physicalDeliveryOfficeName", "postalCode", "preferredLanguage", "provisionedPlans", "provisioningErrors", "proxyAddresses", "refreshTokensValidFromDateTime", "showInAddressList", "signInNames", "sipProxyAddress", "state", "streetAddress", "surname", "telephoneNumber", "thumbnailPhoto@odata.mediaContentType", "usageLocation", "userIdentities", "userPrincipalName", "userType", "extension_18e31482d3fb4a8ea958aa96b662f508_SupervisorInd", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingName", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingID", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToPersonnelNbr", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToFullName", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToEmailName", "extension_18e31482d3fb4a8ea958aa96b662f508_CompanyCode", "extension_18e31482d3fb4a8ea958aa96b662f508_CostCenterCode", "extension_18e31482d3fb4a8ea958aa96b662f508_LocationAreaCode", "extension_18e31482d3fb4a8ea958aa96b662f508_PersonnelNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_PositionNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_ProfitCenterCode"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded Column2",{"assignedLicenses", "assignedPlans", "otherMails", "provisionedPlans", "provisioningErrors", "proxyAddresses", "signInNames", "userIdentities"})
in
    #"Removed Columns"
in
    ListRBACUsers

// TaggedResourceGroups
let
   Source = #"All Subscriptions",
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "ListAllRGTags", each ListAllRGTags([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListAllRGTags"}),
    #"Expanded ListAllRGTags" = Table.ExpandTableColumn(#"Removed Errors", "ListAllRGTags", {"id", "name", "TagKey", "TagValue"}, {"id", "name", "TagKey", "TagValue"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded ListAllRGTags",{{"Subscription Name", "Subscription Name"}, {"id", "Resource Group Id"}}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Renamed Columns", "Resource Group Id", "Resource Group Id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "Resource Group Id - Copy", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"Resource Id - Copy.1", "Resource Id - Copy.2", "Resource Id - Copy.3", "Resource Id - Copy.4", "Resource Id - Copy.5"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Resource Id - Copy.1", type text}, {"Resource Id - Copy.2", type text}, {"Resource Id - Copy.3", type text}, {"Resource Id - Copy.4", type text}, {"Resource Id - Copy.5", type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type",{"Resource Id - Copy.1", "Resource Id - Copy.2", "Resource Id - Copy.3"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"Resource Id - Copy.4", "Resource Type"}, {"Resource Id - Copy.5", "Resource Group Name"}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Renamed Columns1",{"name"})
in
    #"Removed Columns1"

// ListAllRGTags
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

// TaggedResources
let
    Source = #"All Subscriptions",
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "AllResourceTags", each ListAllResourceTags([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"AllResourceTags"}),
    #"Expanded AllResourceTags" = Table.ExpandTableColumn(#"Removed Errors", "AllResourceTags", {"id", "ResourceName", "TagKey", "TagValue"}, {"id", "ResourceName", "TagKey", "TagValue"}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Expanded AllResourceTags", "id", "id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "id - Copy", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"id - Copy.1", "id - Copy.2", "id - Copy.3", "id - Copy.4", "id - Copy.5", "id - Copy.6", "id - Copy.7", "id - Copy.8", "id - Copy.9"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"id - Copy.1", type text}, {"id - Copy.2", type text}, {"id - Copy.3", type text}, {"id - Copy.4", type text}, {"id - Copy.5", type text}, {"id - Copy.6", type text}, {"id - Copy.7", type text}, {"id - Copy.8", type text}, {"id - Copy.9", type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type",{"id - Copy.1", "id - Copy.2", "id - Copy.3", "id - Copy.4", "id - Copy.5", "id - Copy.6", "id - Copy.7", "id - Copy.9"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"id - Copy.8", "Resource Type"}, {"Subscription Name", "Subscription Name"}, {"id", "Resource Id"}}),
    #"Filtered Rows" = Table.SelectRows(#"Renamed Columns", each not Text.Contains([TagKey], "hidden-") and not Text.Contains([TagKey], "Link:/"))
in
    #"Filtered Rows"

// ListAllResourceTags
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

// RBAC Role groups
// RBAC Role Assignments
let
    Source = #"All Subscriptions",
    #"List RBACRoleAssignments" = Table.AddColumn(#"All Subscriptions", "ListRBACRoleAssignments", each ListRBACRoleAssignments([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"List RBACRoleAssignments", {"ListRBACRoleAssignments"}),
    #"Expanded ListRBACRoleAssignments" = Table.ExpandTableColumn(#"Removed Errors", "ListRBACRoleAssignments", {"roleDefinitionId", "principalId", "scope", "createdOn", "updatedOn", "createdBy", "updatedBy", "id", "type", "name"}, {"roleDefinitionId", "principalId", "scope", "createdOn", "updatedOn", "createdBy", "updatedBy", "id", "type", "name"}),
    #"Split Column by Delimiter1" = Table.SplitColumn(#"Expanded ListRBACRoleAssignments", "scope", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"scope.1", "scope.2", "scope.3", "scope.4", "scope.5", "scope.6", "scope.7", "scope.8", "scope.9", "scope.10", "scope.11"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Split Column by Delimiter1",{{"scope.5", "Resource Group"}, {"scope.7", "Resource Provider"}, {"scope.8", "Resource Type"}, {"scope.9", "Resource Name"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns2",{"scope.1", "scope.2", "scope.3", "scope.4", "scope.6"}),
    #"Replaced Value" = Table.ReplaceValue(#"Removed Columns",null,"*",Replacer.ReplaceValue,{"Resource Group"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value",null,"*",Replacer.ReplaceValue,{"Resource Provider"}),
    #"Added Conditional Column" = Table.AddColumn(#"Replaced Value1", "Custom", each if [Resource Group] = "*" then "Subscription" else if [Resource Provider] = "*" then "Resource Group" else if [Resource Type] <> null then [Resource Type] else null),
    #"Renamed Columns3" = Table.RenameColumns(#"Added Conditional Column",{{"Resource Type", "Rtype"}, {"Custom", "Resource Type"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns3", "Users", each ListRBACgroups([principalId])),
    #"Removed Errors1" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"Users"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Errors1",{{"state", "Subscription state"}}),
    #"Expanded Users" = Table.ExpandTableColumn(#"Renamed Columns", "Users", {"odata.type", "objectType", "objectId", "accountEnabled", "ageGroup", "city", "companyName", "country", "creationType", "department", "dirSyncEnabled", "employeeId", "givenName", "immutableId", "isCompromised", "lastDirSyncTime", "mail", "mailNickname", "onPremisesDistinguishedName", "onPremisesSecurityIdentifier", "state", "streetAddress", "surname", "usageLocation", "userPrincipalName", "userType"}, {"odata.type", "objectType", "objectId", "accountEnabled", "ageGroup", "city", "companyName", "country", "creationType", "department", "dirSyncEnabled", "employeeId", "givenName", "immutableId", "isCompromised", "lastDirSyncTime", "mail", "mailNickname", "onPremisesDistinguishedName", "onPremisesSecurityIdentifier", "state", "streetAddress", "surname", "usageLocation", "userPrincipalName", "userType"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Expanded Users",{"accountEnabled", "ageGroup", "city", "companyName", "country", "creationType", "department", "employeeId", "givenName", "immutableId", "isCompromised", "onPremisesDistinguishedName", "onPremisesSecurityIdentifier", "state", "streetAddress", "surname", "usageLocation", "userPrincipalName", "userType"})
in
    #"Removed Columns1"

// ListRBACgroups
let ListRBACUsers = (principalId as text) =>
let
    url = GetGraphURL(AzureKind)&"/"&#"TenantName"&"/groups?api-version=1.6&$filter=objectId eq '"&principalId&"'",
    iterations = 10,
    FuncGetOnePage = (url) as record =>
    let 
       Source = Json.Document(Web.Contents(url)),
       data = try Source[value] otherwise null,
       next = try Source[nextLink] otherwise null,
       res = [Data=data, Next=next]
    in
        res,
        GeneratedListOfPages = List.Generate(()=>[i=0, res = FuncGetOnePage(url)],
        each [i]<iterations and [res][Data]<>null,
        each [i=[i]+1, res = FuncGetOnePage([res][Next])],
        each [res][Data]),

    #"Converted to Table" = Table.FromList(GeneratedListOfPages, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandListColumn(#"Converted to Table", "Column1"),
    #"Expanded Column2" = Table.ExpandRecordColumn(#"Expanded Column1", "Column1", {"odata.type", "objectType", "objectId", "deletionTimestamp", "accountEnabled", "ageGroup", "assignedLicenses", "assignedPlans", "city", "companyName", "consentProvidedForMinor", "country", "creationType", "department", "dirSyncEnabled", "displayName", "employeeId", "facsimileTelephoneNumber", "givenName", "immutableId", "isCompromised", "jobTitle", "lastDirSyncTime", "legalAgeGroupClassification", "mail", "mailNickname", "mobile", "onPremisesDistinguishedName", "onPremisesSecurityIdentifier", "otherMails", "passwordPolicies", "passwordProfile", "physicalDeliveryOfficeName", "postalCode", "preferredLanguage", "provisionedPlans", "provisioningErrors", "proxyAddresses", "refreshTokensValidFromDateTime", "showInAddressList", "signInNames", "sipProxyAddress", "state", "streetAddress", "surname", "telephoneNumber", "thumbnailPhoto@odata.mediaContentType", "usageLocation", "userIdentities", "userPrincipalName", "userType", "extension_18e31482d3fb4a8ea958aa96b662f508_SupervisorInd", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingName", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingID", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToPersonnelNbr", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToFullName", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToEmailName", "extension_18e31482d3fb4a8ea958aa96b662f508_CompanyCode", "extension_18e31482d3fb4a8ea958aa96b662f508_CostCenterCode", "extension_18e31482d3fb4a8ea958aa96b662f508_LocationAreaCode", "extension_18e31482d3fb4a8ea958aa96b662f508_PersonnelNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_PositionNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_ProfitCenterCode"}, {"odata.type", "objectType", "objectId", "deletionTimestamp", "accountEnabled", "ageGroup", "assignedLicenses", "assignedPlans", "city", "companyName", "consentProvidedForMinor", "country", "creationType", "department", "dirSyncEnabled", "displayName", "employeeId", "facsimileTelephoneNumber", "givenName", "immutableId", "isCompromised", "jobTitle", "lastDirSyncTime", "legalAgeGroupClassification", "mail", "mailNickname", "mobile", "onPremisesDistinguishedName", "onPremisesSecurityIdentifier", "otherMails", "passwordPolicies", "passwordProfile", "physicalDeliveryOfficeName", "postalCode", "preferredLanguage", "provisionedPlans", "provisioningErrors", "proxyAddresses", "refreshTokensValidFromDateTime", "showInAddressList", "signInNames", "sipProxyAddress", "state", "streetAddress", "surname", "telephoneNumber", "thumbnailPhoto@odata.mediaContentType", "usageLocation", "userIdentities", "userPrincipalName", "userType", "extension_18e31482d3fb4a8ea958aa96b662f508_SupervisorInd", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingName", "extension_18e31482d3fb4a8ea958aa96b662f508_BuildingID", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToPersonnelNbr", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToFullName", "extension_18e31482d3fb4a8ea958aa96b662f508_ReportsToEmailName", "extension_18e31482d3fb4a8ea958aa96b662f508_CompanyCode", "extension_18e31482d3fb4a8ea958aa96b662f508_CostCenterCode", "extension_18e31482d3fb4a8ea958aa96b662f508_LocationAreaCode", "extension_18e31482d3fb4a8ea958aa96b662f508_PersonnelNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_PositionNumber", "extension_18e31482d3fb4a8ea958aa96b662f508_ProfitCenterCode"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded Column2",{"assignedLicenses", "assignedPlans", "otherMails", "provisionedPlans", "provisioningErrors", "proxyAddresses", "signInNames", "userIdentities"})
in
    #"Removed Columns"
in
    ListRBACUsers

// RBAC Role Users and Groups
let
    Source = Table.Combine({#"RBAC Role groups", #"RBAC Role Users"}),
    #"Filtered Rows" = Table.SelectRows(Source, each true)
in
    #"Filtered Rows"

// ListServicePrincipals
let ListRBACUsers = (principalId as text) =>
let
    url = GetGraphURL(AzureKind)&"/myorganization/servicePrincipals?api-version=1.6&$filter=objectId eq '"&principalId&"'",
    iterations = 10,
    FuncGetOnePage = (url) as record =>
    let 
       Source = Json.Document(Web.Contents(url)),
       data = try Source[value] otherwise null,
       next = try Source[nextLink] otherwise null,
       res = [Data=data, Next=next]
    in
        res,
        GeneratedListOfPages = List.Generate(()=>[i=0, res = FuncGetOnePage(url)],
        each [i]<iterations and [res][Data]<>null,
        each [i=[i]+1, res = FuncGetOnePage([res][Next])],
        each [res][Data]),

    #"Converted to Table" = Table.FromList(GeneratedListOfPages, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandListColumn(#"Converted to Table", "Column1")
   
 in
    #"Expanded Column1"
in
    ListRBACUsers

// Service Principals
// RBAC Role Assignments
let
    Source = #"All Subscriptions",
    #"List RBACRoleAssignments" = Table.AddColumn(#"All Subscriptions", "ListRBACRoleAssignments", each ListRBACRoleAssignments([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"List RBACRoleAssignments", {"ListRBACRoleAssignments"}),
    #"Expanded ListRBACRoleAssignments" = Table.ExpandTableColumn(#"Removed Errors", "ListRBACRoleAssignments", {"roleDefinitionId", "principalId", "scope", "createdOn", "updatedOn", "createdBy", "updatedBy", "id", "type", "name"}, {"roleDefinitionId", "principalId", "scope", "createdOn", "updatedOn", "createdBy", "updatedBy", "id", "type", "name"}),
    #"Invoked Custom Function" = Table.AddColumn(#"Expanded ListRBACRoleAssignments", "Users", each ListServicePrincipals([principalId])),
    #"Removed Errors1" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"Users"}),
    #"Expanded Users" = Table.ExpandTableColumn(#"Removed Errors1", "Users", {"Column1"}, {"Column1"}),
    #"Expanded Column2" = Table.ExpandRecordColumn(#"Expanded Users", "Column1", {"odata.type", "objectType", "objectId", "deletionTimestamp", "accountEnabled", "addIns", "alternativeNames", "appDisplayName", "appId", "appOwnerTenantId", "appRoleAssignmentRequired", "appRoles", "displayName", "errorUrl", "homepage", "keyCredentials", "logoutUrl", "oauth2Permissions", "passwordCredentials", "preferredTokenSigningKeyThumbprint", "publisherName", "replyUrls", "samlMetadataUrl", "servicePrincipalNames", "servicePrincipalType", "signInAudience", "tags", "tokenEncryptionKeyId"}, {"odata.type", "objectType", "objectId", "deletionTimestamp", "accountEnabled", "addIns", "alternativeNames", "appDisplayName", "appId", "appOwnerTenantId", "appRoleAssignmentRequired", "appRoles", "displayName", "errorUrl", "homepage", "keyCredentials", "logoutUrl", "oauth2Permissions", "passwordCredentials", "preferredTokenSigningKeyThumbprint", "publisherName", "replyUrls", "samlMetadataUrl", "servicePrincipalNames", "servicePrincipalType", "signInAudience", "tags", "tokenEncryptionKeyId"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded Column2",{"replyUrls", "servicePrincipalNames", "tags", "passwordCredentials"}),
    #"Expanded oauth2Permissions" = Table.ExpandListColumn(#"Removed Columns", "oauth2Permissions"),
    #"Expanded oauth2Permissions1" = Table.ExpandRecordColumn(#"Expanded oauth2Permissions", "oauth2Permissions", {"adminConsentDescription", "adminConsentDisplayName", "id", "isEnabled", "type", "userConsentDescription", "userConsentDisplayName", "value"}, {"adminConsentDescription", "adminConsentDisplayName", "id.1", "isEnabled", "type.1", "userConsentDescription", "userConsentDisplayName", "value"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Expanded oauth2Permissions1",{"addIns", "alternativeNames", "appRoles", "errorUrl"}),
    #"Expanded keyCredentials" = Table.ExpandListColumn(#"Removed Columns1", "keyCredentials"),
    #"Removed Columns2" = Table.RemoveColumns(#"Expanded keyCredentials",{"keyCredentials", "logoutUrl"}),
    #"Filtered Rows" = Table.SelectRows(#"Removed Columns2", each not Text.StartsWith([displayName], "AzureContainerService") and not Text.StartsWith([displayName], "azure-cli-")),
    #"Filtered Rows1" = Table.SelectRows(#"Filtered Rows", each true),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Filtered Rows1", "scope", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"scope.1", "scope.2", "scope.3", "scope.4", "scope.5", "scope.6", "scope.7", "scope.8", "scope.9", "scope.10", "scope.11"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Split Column by Delimiter",{{"scope.5", "Resource Group"}, {"scope.7", "Resource Provider"}, {"scope.8", "Resource Type"}, {"scope.9", "Resource Name"}}),
    #"Removed Columns3" = Table.RemoveColumns(#"Renamed Columns2",{"scope.1", "scope.2", "scope.3", "scope.4", "scope.6"}),
    #"Replaced Value" = Table.ReplaceValue(#"Removed Columns3",null,"*",Replacer.ReplaceValue,{"Resource Group"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value",null,"*",Replacer.ReplaceValue,{"Resource Provider"}),
    #"Added Conditional Column" = Table.AddColumn(#"Replaced Value1", "Custom", each if [Resource Group] = "*" then "Subscription" else if [Resource Provider] = "*" then "Resource Group" else if [Resource Type] <> null then [Resource Type] else null),
    #"Renamed Columns3" = Table.RenameColumns(#"Added Conditional Column",{{"scope.11", "Integration Runtime Name"}, {"scope.10", "DataFactory Resource Type"}}),
    #"Replaced Value2" = Table.ReplaceValue(#"Renamed Columns3",null,"resourcegroup",Replacer.ReplaceValue,{"Resource Type"})

in
    #"Replaced Value2"

// RBAC Role SP, Users and Groups
let
    Source = Table.Combine({#"RBAC Role Users and Groups", #"Service Principals"}),
    #"Added Conditional Column" = Table.AddColumn(Source, "Custon Name", each if [displayName] = "" then [mailNickname] else if [objectType] = "ServicePrincipal" then [displayName] else [mailNickname]),
    #"Renamed Columns" = Table.RenameColumns(#"Added Conditional Column",{{"Custon Name", "Custom Name"}})
in
    #"Renamed Columns"

// NSGs
let
   Source = #"All Subscriptions",
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "ListNSGs", each ListNSGs([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListNSGs"}),
    #"Expanded ListNSGs" = Table.ExpandTableColumn(#"Removed Errors", "ListNSGs", {"Column1"}, {"Column1"}),
    #"Expanded Column2" = Table.ExpandRecordColumn(#"Expanded ListNSGs", "Column1", {"name", "id", "location", "properties"}, {"name", "id", "location", "properties"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded Column2", each [name] <> null and [name] <> ""),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Filtered Rows", "properties", {"securityRules", "subnets", "networkInterfaces"}, {"securityRules", "subnets", "networkInterfaces"}),
    //#"Added Conditional Column" = Table.AddColumn(#"Expanded properties", "NSGonSubnetOrVM", each if ([subnets] <> null and [networkInterface] <> null) then "NSG on Subnet and VM" else if [subnets] = null and [networkInterfaces] <> null then "NSG on VM" else null)

    #"Added Conditional Column" = Table.AddColumn(#"Expanded properties", "NSGonSubnetOrVM", each if ([subnets] <> null and [networkInterfaces] <> null) then "NSG on Subnet and VM" else if [subnets] = null and [networkInterfaces] <> null then "NSG on NIC" else if [subnets] <> null and [networkInterfaces] = null then "NSG on Subnet" else "NSG not assigned"),
    #"Expanded subnets" = Table.ExpandListColumn(#"Added Conditional Column", "subnets"),
    #"Expanded subnets1" = Table.ExpandRecordColumn(#"Expanded subnets", "subnets", {"id"}, {"id.1"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded subnets1",{{"id.1", "Subnet Id"}}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Renamed Columns1", "Subnet Id", "Subnet Id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "Subnet Id - Copy", Splitter.SplitTextByEachDelimiter({"/"}, QuoteStyle.Csv, true), {"Subnet Id - Copy.1", "Subnet Id - Copy.2"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Subnet Id - Copy.1", type text}, {"Subnet Id - Copy.2", type text}}),
    #"Renamed Columns2" = Table.RenameColumns(#"Changed Type",{{"Subnet Id - Copy.2", "Subnet Name"}}),
    #"Split Column by Delimiter1" = Table.SplitColumn(#"Renamed Columns2", "Subnet Id - Copy.1", Splitter.SplitTextByEachDelimiter({"/"}, QuoteStyle.Csv, true), {"Subnet Id - Copy.1.1", "Subnet Id - Copy.1.2"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Split Column by Delimiter1",{{"Subnet Id - Copy.1.1", type text}, {"Subnet Id - Copy.1.2", type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type1",{"Subnet Id - Copy.1.2"}),
    #"Renamed Columns3" = Table.RenameColumns(#"Removed Columns",{{"Subnet Id - Copy.1.1", "VNET Id"}}),
    #"Duplicated Column1" = Table.DuplicateColumn(#"Renamed Columns3", "VNET Id", "VNET Id - Copy"),
    #"Split Column by Delimiter2" = Table.SplitColumn(#"Duplicated Column1", "VNET Id - Copy", Splitter.SplitTextByEachDelimiter({"/"}, QuoteStyle.Csv, true), {"VNET Id - Copy.1", "VNET Id - Copy.2"}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Split Column by Delimiter2",{{"VNET Id - Copy.1", type text}, {"VNET Id - Copy.2", type text}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Changed Type2",{"VNET Id - Copy.1"}),
    #"Renamed Columns4" = Table.RenameColumns(#"Removed Columns1",{{"VNET Id - Copy.2", "VNET Name"}}),
    #"Expanded networkInterfaces" = Table.ExpandListColumn(#"Renamed Columns4", "networkInterfaces"),
    #"Expanded networkInterfaces1" = Table.ExpandRecordColumn(#"Expanded networkInterfaces", "networkInterfaces", {"id"}, {"id.1"}),
    #"Renamed Columns5" = Table.RenameColumns(#"Expanded networkInterfaces1",{{"id.1", "NIC Id"}}),
    #"Duplicated Column2" = Table.DuplicateColumn(#"Renamed Columns5", "NIC Id", "NIC Id - Copy"),
    #"Split Column by Delimiter3" = Table.SplitColumn(#"Duplicated Column2", "NIC Id - Copy", Splitter.SplitTextByEachDelimiter({"/"}, QuoteStyle.Csv, true), {"NIC Id - Copy.1", "NIC Id - Copy.2"}),
    #"Changed Type3" = Table.TransformColumnTypes(#"Split Column by Delimiter3",{{"NIC Id - Copy.1", type text}, {"NIC Id - Copy.2", type text}}),
    #"Removed Columns2" = Table.RemoveColumns(#"Changed Type3",{"NIC Id - Copy.1"}),
    #"Renamed Columns6" = Table.RenameColumns(#"Removed Columns2",{{"NIC Id - Copy.2", "NIC Name"}}),
    #"Expanded securityRules" = Table.ExpandListColumn(#"Renamed Columns6", "securityRules"),
    #"Expanded securityRules1" = Table.ExpandRecordColumn(#"Expanded securityRules", "securityRules", {"name", "id", "properties"}, {"name.1", "id.1", "properties"}),
    #"Renamed Columns7" = Table.RenameColumns(#"Expanded securityRules1",{{"name.1", "Security Rule Name"}, {"id.1", "Security Rule Id"}}),
    #"Expanded properties1" = Table.ExpandRecordColumn(#"Renamed Columns7", "properties", {"description", "protocol", "sourcePortRange", "destinationPortRange", "sourceAddressPrefix", "destinationAddressPrefix", "access", "priority", "direction", "sourcePortRanges", "destinationPortRanges", "sourceAddressPrefixes", "destinationAddressPrefixes", "destinationApplicationSecurityGroups", "sourceApplicationSecurityGroups"}, {"description", "protocol", "sourcePortRange", "destinationPortRange", "sourceAddressPrefix", "destinationAddressPrefix", "access", "priority", "direction", "sourcePortRanges", "destinationPortRanges", "sourceAddressPrefixes", "destinationAddressPrefixes", "destinationApplicationSecurityGroups", "sourceApplicationSecurityGroups"}),
    #"Expanded sourcePortRanges" = Table.ExpandListColumn(#"Expanded properties1", "sourcePortRanges"),
    #"Expanded destinationPortRanges" = Table.ExpandListColumn(#"Expanded sourcePortRanges", "destinationPortRanges"),
    #"Expanded sourceAddressPrefixes" = Table.ExpandListColumn(#"Expanded destinationPortRanges", "sourceAddressPrefixes"),
    #"Expanded destinationAddressPrefixes" = Table.ExpandListColumn(#"Expanded sourceAddressPrefixes", "destinationAddressPrefixes"),
    #"Expanded destinationApplicationSecurityGroups" = Table.ExpandListColumn(#"Expanded destinationAddressPrefixes", "destinationApplicationSecurityGroups"),
    #"Expanded sourceApplicationSecurityGroups" = Table.ExpandListColumn(#"Expanded destinationApplicationSecurityGroups", "sourceApplicationSecurityGroups"),
    #"Expanded destinationApplicationSecurityGroups1" = Table.ExpandRecordColumn(#"Expanded sourceApplicationSecurityGroups", "destinationApplicationSecurityGroups", {"id"}, {"id.1"}),
    #"Renamed Columns8" = Table.RenameColumns(#"Expanded destinationApplicationSecurityGroups1",{{"id.1", "Destination ASG Id"}}),
    #"Expanded sourceApplicationSecurityGroups1" = Table.ExpandRecordColumn(#"Renamed Columns8", "sourceApplicationSecurityGroups", {"id"}, {"id.1"}),
    #"Renamed Columns9" = Table.RenameColumns(#"Expanded sourceApplicationSecurityGroups1",{{"id.1", "Source ASG Id"}}),
    #"Merged Columns" = Table.CombineColumns(Table.TransformColumnTypes(#"Renamed Columns9", {{"destinationPortRanges", type text}}, "en-US"),{"destinationPortRange", "destinationPortRanges"},Combiner.CombineTextByDelimiter("", QuoteStyle.None),"DestinationPorts"),
    #"Merged Columns1" = Table.CombineColumns(Table.TransformColumnTypes(#"Merged Columns", {{"sourcePortRanges", type text}}, "en-US"),{"sourcePortRange", "sourcePortRanges"},Combiner.CombineTextByDelimiter("", QuoteStyle.None),"SourcePorts")
in
    #"Merged Columns1"

// ListNSGs
let ListPublicIPs = (subscriptionId as text) =>
let
    url = GetManagementURL(AzureKind)&"/subscriptions/"&subscriptionId&"/providers/Microsoft.Network/networkSecurityGroups?api-version=2018-08-01",
    iterations = 10,
    FuncGetOnePage = (url) as record =>
    let 
       Source = Json.Document(Web.Contents(url)),
       data = try Source[value] otherwise null,
       next = try Source[nextLink] otherwise null,
       res = [Data=data, Next=next]
    in
        res,
        GeneratedListOfPages = List.Generate(()=>[i=0, res = FuncGetOnePage(url)],
        each [i]<iterations and [res][Data]<>null,
        each [i=[i]+1, res = FuncGetOnePage([res][Next])],
        each [res][Data]),

    #"Converted to Table" = Table.FromList(GeneratedListOfPages, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandListColumn(#"Converted to Table", "Column1")
   
in
    #"Expanded Column1"
in
    ListPublicIPs

// List Security tasks
let ListSecurityTasks = (subscriptionId as text)=>
let
    url = GetManagementURL(AzureKind)&"/subscriptions/"&subscriptionId&"/providers/microsoft.Security/tasks?api-version=2015-06-01-preview",
    iterations = 10,
    FuncGetOnePage = (url) as record =>
    let 
       Source = Json.Document(Web.Contents(url)),
       data = try Source[value] otherwise null,
       next = try Source[nextLink] otherwise null,
       res = [Data=data, Next=next]
    in
        res,
        GeneratedListOfPages = List.Generate(()=>[i=0, res = FuncGetOnePage(url)],
        each [i]<iterations and [res][Data]<>null,
        each [i=[i]+1, res = FuncGetOnePage([res][Next])],
        each [res][Data]),

    #"Converted to Table" = Table.FromList(GeneratedListOfPages, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandListColumn(#"Converted to Table", "Column1"),
    #"Expanded Column2" = Table.ExpandRecordColumn(#"Expanded Column1", "Column1", {"id", "properties"}, {"id", "properties"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column2",{{"id", "Security Center Task Id"}}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Renamed Columns", "properties", {"state", "subState", "creationTimeUtc", "lastStateChangeTimeUtc", "securityTaskParameters"}, {"state", "subState", "creationTimeUtc", "lastStateChangeTimeUtc", "securityTaskParameters"}),
    #"Expanded securityTaskParameters" = Table.ExpandRecordColumn(#"Expanded properties", "securityTaskParameters", {"subscriptionId", "id", "title", "classification", "totalNumberOfImpactedMachines", "severity", "osType", "isMandatory", "workspaces", "name", "uniqueKey", "resourceId", "baselineRuleId", "baselineName", "baselineCceId", "osName", "ruleType", "totalNumberOfDefectedMachines", "resourceType", "category", "assessmentKey", "policyName", "policyDefinitionId", "details", "vmId", "vmName", "isOsDiskEncrypted", "isDataDiskEncrypted"}, {"subscriptionId", "id", "title", "classification", "totalNumberOfImpactedMachines", "severity", "osType", "isMandatory", "workspaces", "name", "uniqueKey", "resourceId", "baselineRuleId", "baselineName", "baselineCceId", "osName", "ruleType", "totalNumberOfDefectedMachines", "resourceType", "category", "assessmentKey", "policyName", "policyDefinitionId", "details", "vmId", "vmName", "isOsDiskEncrypted", "isDataDiskEncrypted"}),
     #"Filtered Rows" = Table.SelectRows(#"Expanded securityTaskParameters", each ([subscriptionId] = null))  
in
    #"Filtered Rows"
in
    ListSecurityTasks

// VNET Peerings
let
    Source = #"All Subscriptions",
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "ListOfPeerings", each #"Unique VNET Peerings"([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListOfPeerings"}),
    #"Expanded ListOfPeerings" = Table.ExpandTableColumn(#"Removed Errors", "ListOfPeerings", {"VNET Name", "VNET Id", "location", "VNET Peering Name", "VNET Peering Id", "peeringState", "Remote VNET Id", "allowVirtualNetworkAccess", "allowForwardedTraffic", "allowGatewayTransit", "useRemoteGateways", "doNotVerifyRemoteGateways", "addressPrefixes", "Remote VNET Name", "Remote VNET Location", "Peering Type", "PeeringImage", "Source Longitude", "Source Latitude", "Remote Longitude", "Remote Latitude"}, {"VNET Name", "VNET Id", "location", "VNET Peering Name", "VNET Peering Id", "peeringState", "Remote VNET Id", "allowVirtualNetworkAccess", "allowForwardedTraffic", "allowGatewayTransit", "useRemoteGateways", "doNotVerifyRemoteGateways", "addressPrefixes", "Remote VNET Name", "Remote VNET Location", "Peering Type", "PeeringImage", "Source Longitude", "Source Latitude", "Remote Longitude", "Remote Latitude"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded ListOfPeerings", each [VNET Name] <> null and [VNET Name] <> ""),
    #"Removed Duplicates" = Table.Distinct(#"Filtered Rows", {"VNET Peering Id"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Removed Duplicates",{{"allowForwardedTraffic", Int64.Type}, {"allowGatewayTransit", Int64.Type}})
in
    #"Changed Type"

// Unique VNET Peerings
let ListVNETPeerings = (SubscriptionId as text) =>
let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
    Fullset = GetPages(GetManagementURL(AzureKind)&"/subscriptions/"&SubscriptionId&"/providers/Microsoft.Network/virtualNetworks?api-version=2018-11-01"),
    #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"name", "id", "location", "properties"}, {"name", "id", "location", "properties"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"name", "VNET Name"}, {"id", "VNET Id"}}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Renamed Columns", "properties", {"virtualNetworkPeerings"}, {"virtualNetworkPeerings"}),
    #"Expanded virtualNetworkPeerings" = Table.ExpandListColumn(#"Expanded properties", "virtualNetworkPeerings"),
    #"Expanded virtualNetworkPeerings1" = Table.ExpandRecordColumn(#"Expanded virtualNetworkPeerings", "virtualNetworkPeerings", {"name", "id", "properties"}, {"name", "id", "properties"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded virtualNetworkPeerings1",{{"name", "VNET Peering Name"}, {"id", "VNET Peering Id"}}),
    #"Filtered Rows" = Table.SelectRows(#"Renamed Columns1", each [VNET Peering Name] <> null and [VNET Peering Name] <> ""),
    #"Expanded properties1" = Table.ExpandRecordColumn(#"Filtered Rows", "properties", {"peeringState", "remoteVirtualNetwork", "allowVirtualNetworkAccess", "allowForwardedTraffic", "allowGatewayTransit", "useRemoteGateways", "doNotVerifyRemoteGateways", "remoteAddressSpace"}, {"peeringState", "remoteVirtualNetwork", "allowVirtualNetworkAccess", "allowForwardedTraffic", "allowGatewayTransit", "useRemoteGateways", "doNotVerifyRemoteGateways", "remoteAddressSpace"}),
    #"Expanded remoteVirtualNetwork" = Table.ExpandRecordColumn(#"Expanded properties1", "remoteVirtualNetwork", {"id"}, {"id"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Expanded remoteVirtualNetwork",{{"id", "Remote VNET Id"}}),
    #"Expanded remoteAddressSpace" = Table.ExpandRecordColumn(#"Renamed Columns2", "remoteAddressSpace", {"addressPrefixes"}, {"addressPrefixes"}),
    #"Expanded addressPrefixes" = Table.ExpandListColumn(#"Expanded remoteAddressSpace", "addressPrefixes"),
    #"Duplicated Column" = Table.DuplicateColumn(#"Expanded addressPrefixes", "Remote VNET Id", "Remote VNET Id - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Duplicated Column", "Remote VNET Id - Copy", Splitter.SplitTextByEachDelimiter({"/"}, QuoteStyle.Csv, true), {"Remote VNET Id - Copy.1", "Remote VNET Id - Copy.2"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Remote VNET Id - Copy.1", type text}, {"Remote VNET Id - Copy.2", type text}}),
    #"Renamed Columns3" = Table.RenameColumns(#"Changed Type",{{"Remote VNET Id - Copy.2", "Remote VNET Name"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns3",{"Remote VNET Id - Copy.1"}),
    #"Merged Queries" = Table.NestedJoin(#"Removed Columns", {"Remote VNET Id"}, Resources, {"Resource Id"}, "Resources", JoinKind.LeftOuter),
    #"Expanded Resources" = Table.ExpandTableColumn(#"Merged Queries", "Resources", {"location"}, {"location.1"}),
    #"Renamed Columns4" = Table.RenameColumns(#"Expanded Resources",{{"location.1", "Remote VNET Location"}}),
    #"Added Conditional Column" = Table.AddColumn(#"Renamed Columns4", "Peering Type", each if [location] = [Remote VNET Location] then "VNET Peering" else "Global VNET Peering"),
    #"Added Conditional Column1" = Table.AddColumn(#"Added Conditional Column", "PeeringImage", each if [Peering Type] = "VNET Peering" then "https://azure.github.io/ccodashboard/assets/2020_Icons/VNETPeerings.svg" else "https://azure.github.io/ccodashboard/assets/2020_Icons/VNETPeerings.svg"),
    #"Merged Queries1" = Table.NestedJoin(#"Added Conditional Column1", {"location"}, #"Azure Regions", {"AzureLocation"}, "Azure Regions", JoinKind.LeftOuter),
    #"Expanded Azure Regions" = Table.ExpandTableColumn(#"Merged Queries1", "Azure Regions", {"Longitude", "Latitude"}, {"Longitude", "Latitude"}),
    #"Renamed Columns5" = Table.RenameColumns(#"Expanded Azure Regions",{{"Longitude", "Source Longitude"}, {"Latitude", "Source Latitude"}}),
    #"Merged Queries2" = Table.NestedJoin(#"Renamed Columns5", {"Remote VNET Location"}, #"Azure Regions", {"AzureLocation"}, "Azure Regions", JoinKind.LeftOuter),
    #"Expanded Azure Regions1" = Table.ExpandTableColumn(#"Merged Queries2", "Azure Regions", {"Longitude", "Latitude"}, {"Longitude", "Latitude"}),
    #"Renamed Columns6" = Table.RenameColumns(#"Expanded Azure Regions1",{{"Longitude", "Remote Longitude"}, {"Latitude", "Remote Latitude"}})
in
    #"Renamed Columns6"

in ListVNETPeerings

// Virtual Networks
let
    Source = #"All Subscriptions",
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "ListOfVNETs", each ListUniqueVnets([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListOfVNETs"}),
    #"Expanded ListOfVNETs" = Table.ExpandTableColumn(#"Removed Errors", "ListOfVNETs", {"VNET Name", "VNET Id", "location", "addressPrefixes", "VNET Peering Id", "enableDdosProtection", "enableVmProtection", "dnsServers"}, {"VNET Name", "VNET Id", "location", "addressPrefixes", "VNET Peering Id", "enableDdosProtection", "enableVmProtection", "dnsServers"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded ListOfVNETs",{{"enableDdosProtection", type text}, {"enableVmProtection", type text}}),
    #"Replaced Value" = Table.ReplaceValue(#"Changed Type","true","1",Replacer.ReplaceText,{"enableDdosProtection"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value","false","0",Replacer.ReplaceText,{"enableDdosProtection"}),
    #"Replaced Value2" = Table.ReplaceValue(#"Replaced Value1","true","https://azure.github.io/ccodashboard/assets/pictures/checkmark.svg",Replacer.ReplaceText,{"enableVmProtection"}),
    #"Replaced Value3" = Table.ReplaceValue(#"Replaced Value2","false","https://azure.github.io/ccodashboard/assets/pictures/crossout.svg",Replacer.ReplaceText,{"enableVmProtection"})
in
    #"Replaced Value3"

// ListUniqueVnets
let ListUniqueVNETS= (SubscriptionId as text) =>
let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
    Fullset = GetPages(GetManagementURL(AzureKind)&"/subscriptions/"&SubscriptionId&"/providers/Microsoft.Network/virtualNetworks?api-version=2018-11-01"),
    #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Converted to Table", {"Column1"}),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Removed Errors", "Column1", {"name", "id", "location", "properties"}, {"name", "id", "location", "properties"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"name", "VNET Name"}, {"id", "VNET Id"}}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Renamed Columns", "properties", {"addressSpace", "virtualNetworkPeerings", "enableDdosProtection", "enableVmProtection", "dhcpOptions"}, {"addressSpace", "virtualNetworkPeerings", "enableDdosProtection", "enableVmProtection", "dhcpOptions"}),
    #"Expanded addressSpace" = Table.ExpandRecordColumn(#"Expanded properties", "addressSpace", {"addressPrefixes"}, {"addressPrefixes"}),
    #"Extracted Values" = Table.TransformColumns(#"Expanded addressSpace", {"addressPrefixes", each Text.Combine(List.Transform(_, Text.From), ";"), type text}),
    #"Expanded dhcpOptions" = Table.ExpandRecordColumn(#"Extracted Values", "dhcpOptions", {"dnsServers"}, {"dnsServers"}),
    #"Extracted Values1" = Table.TransformColumns(#"Expanded dhcpOptions", {"dnsServers", each Text.Combine(List.Transform(_, Text.From), ";"), type text}),
    #"Replaced Errors" = Table.ReplaceErrorValues(#"Extracted Values1", {{"dnsServers", "Azure Provided"}}),
    #"Expanded virtualNetworkPeerings" = Table.ExpandListColumn(#"Replaced Errors", "virtualNetworkPeerings"),
    #"Expanded virtualNetworkPeerings1" = Table.ExpandRecordColumn(#"Expanded virtualNetworkPeerings", "virtualNetworkPeerings", {"id"}, {"id"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded virtualNetworkPeerings1",{{"id", "VNET Peering Id"}})
in
    #"Renamed Columns1"
in
ListUniqueVNETS

// Subnets
let
    Source = #"All Subscriptions",
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "ListSubnets", each ListAllSubnets([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListSubnets"}),
    #"Expanded ListSubnets" = Table.ExpandTableColumn(#"Removed Errors", "ListSubnets", {"name", "id", "location", "name.1", "id.1", "addressPrefix", "id.2", "id.3", "id.4"}, {"name", "id", "location", "name.1", "id.1", "addressPrefix", "id.2", "id.3", "id.4"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded ListSubnets",{{"name", "VNET Name"}, {"id", "VNET Id"}, {"name.1", "Subnet Name"}, {"id.1", "Subnet Id"}, {"id.2", "NSG Id"}, {"id.3", "RouteTable Id"}, {"id.4", "IPConfig Id"}})
in
    #"Renamed Columns1"

// ListAllSubnets
let listallsubnets = (SubscriptionId as text) =>
let
 GetPages = (Path)=>
 let
     Source = Json.Document(Web.Contents(Path)),
     LL= @Source[value],
     result = try @LL & @GetPages(Source[#"nextLink"]) otherwise @LL
 in
 result,
    Fullset = GetPages(GetManagementURL(AzureKind)&"/subscriptions/"&SubscriptionId&"/providers/Microsoft.Network/virtualNetworks?api-version=2018-11-01"),
    #"Converted to Table" = Table.FromList(Fullset, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"name", "id", "location", "properties"}, {"name", "id", "location", "properties"}),
        #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded Column1", "properties", {"subnets"}, {"subnets"}),
        #"Expanded subnets" = Table.ExpandListColumn(#"Expanded properties", "subnets"),
        #"Expanded subnets1" = Table.ExpandRecordColumn(#"Expanded subnets", "subnets", {"name", "id", "properties"}, {"name.1", "id.1", "properties"}),
        #"Expanded properties1" = Table.ExpandRecordColumn(#"Expanded subnets1", "properties", {"addressPrefix", "networkSecurityGroup", "routeTable", "ipConfigurations", "delegations", "serviceEndpoints", "ipConfigurationProfiles", "serviceAssociationLinks"}, { "addressPrefix", "networkSecurityGroup", "routeTable", "ipConfigurations", "delegations", "serviceEndpoints", "ipConfigurationProfiles", "serviceAssociationLinks"}),
        #"Expanded networkSecurityGroup" = Table.ExpandRecordColumn(#"Expanded properties1", "networkSecurityGroup", {"id"}, {"id.2"}),
        #"Expanded routeTable" = Table.ExpandRecordColumn(#"Expanded networkSecurityGroup", "routeTable", {"id"}, {"id.3"}),
        #"Expanded ipConfigurations" = Table.ExpandListColumn(#"Expanded routeTable", "ipConfigurations"),
        #"Expanded ipConfigurations1" = Table.ExpandRecordColumn(#"Expanded ipConfigurations", "ipConfigurations", {"id"}, {"id.4"}),
        #"Expanded delegations" = Table.ExpandListColumn(#"Expanded ipConfigurations1", "delegations"),
        #"Removed Columns2" = Table.RemoveColumns(#"Expanded delegations",{"serviceEndpoints"})
    in
        #"Removed Columns2"
in
    listallsubnets

// Disks
let
    Source = #"All Subscriptions",
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "ListAllDisks", each ListAllDisks([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListAllDisks"}),
    #"Expanded ListAllDisks" = Table.ExpandTableColumn(#"Removed Errors", "ListAllDisks", {"Disk Name", "Resource Id", "location", "managedBy", "Disk Type", "Disk Tier", "osType", "createOption", "Publisher", "id.1.11", "OS Type", "SKU", "id.1.16", "SKU Version", "diskSizeGB", "diskIOPSReadWrite", "diskMBpsReadWrite", "timeCreated", "diskState"}, {"Disk Name", "Resource Id", "location", "managedBy", "Disk Type", "Disk Tier", "osType", "createOption", "Publisher", "id.1.11", "OS Type", "SKU", "id.1.16", "SKU Version", "diskSizeGB", "diskIOPSReadWrite", "diskMBpsReadWrite", "timeCreated", "diskState"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded ListAllDisks",{{"id.1.11", "Disk Source"}})
  
in
    #"Renamed Columns1"

// ListAllDisks
let ListAllDisks = (subscriptionId as text) =>
let
    Source = Json.Document(Web.Contents(GetManagementURL(AzureKind)&"/subscriptions/"&subscriptionId&"/providers/Microsoft.Compute/disks?api-version=2019-03-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"name", "id", "type", "location", "tags", "managedBy", "sku", "properties"}, {"name", "id", "type", "location", "tags", "managedBy", "sku", "properties"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded Column1",{"tags"}),
    #"Expanded sku" = Table.ExpandRecordColumn(#"Removed Columns", "sku", {"name", "tier"}, {"name.1", "tier"}),
    #"Expanded properties" = Table.ExpandRecordColumn(#"Expanded sku", "properties", {"osType", "creationData", "diskSizeGB", "diskIOPSReadWrite", "diskMBpsReadWrite", "timeCreated", "diskState"}, {"osType", "creationData", "diskSizeGB", "diskIOPSReadWrite", "diskMBpsReadWrite", "timeCreated", "diskState"}),
    #"Expanded creationData" = Table.ExpandRecordColumn(#"Expanded properties", "creationData", {"createOption", "imageReference"}, {"createOption", "imageReference"}),
    #"Expanded imageReference" = Table.ExpandRecordColumn(#"Expanded creationData", "imageReference", {"id"}, {"id.1"}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Expanded imageReference", "id.1", Splitter.SplitTextByDelimiter("/", QuoteStyle.Csv), {"id.1.1", "id.1.2", "id.1.3", "id.1.4", "id.1.5", "id.1.6", "id.1.7", "id.1.8", "id.1.9", "id.1.10", "id.1.11", "id.1.12", "id.1.13", "id.1.14", "id.1.15", "id.1.16", "id.1.17"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"id.1.1", type text}, {"id.1.2", type text}, {"id.1.3", type text}, {"id.1.4", type text}, {"id.1.5", type text}, {"id.1.6", type text}, {"id.1.7", type text}, {"id.1.8", type text}, {"id.1.9", type text}, {"id.1.10", type text}, {"id.1.11", type text}, {"id.1.12", type text}, {"id.1.13", type text}, {"id.1.14", type text}, {"id.1.15", type text}, {"id.1.16", type text}, {"id.1.17", type text}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Changed Type",{"id.1.1", "id.1.2", "id.1.3", "id.1.4", "id.1.5", "id.1.6", "id.1.7", "id.1.8", "id.1.10", "id.1.12", "id.1.14"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns1",{{"id.1.17", "SKU Version"}, {"id.1.15", "SKU"}, {"id.1.13", "OS Type"}, {"id.1.9", "Publisher"}, {"name", "Disk Name"}, {"id", "Resource Id"}}),
    #"Removed Columns2" = Table.RemoveColumns(#"Renamed Columns",{"type"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns2",{{"name.1", "Disk Type"}, {"tier", "Disk Tier"}})
in
    #"Renamed Columns1"

in 
    ListAllDisks

// ComputeResourcesUsage
let
    Source = #"All Subscriptions",
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "ListOfResources", each ListResources([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListOfResources"}),
    #"Expanded ListOfResources" = Table.ExpandTableColumn(#"Removed Errors", "ListOfResources", {"location"}, {"location"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded ListOfResources", each [location] <> null and [location] <> ""),
    #"Removed Duplicates" = Table.Distinct(#"Filtered Rows", {"Subscription Name", "location"}),
    #"Filtered Rows2" = Table.SelectRows(#"Removed Duplicates", each [location] <> "global"),
    #"Invoked Custom Function1" = Table.AddColumn(#"Filtered Rows2", "GetComputeUsage", each #"Get compute usage"([subscriptionId], [location])),
    #"Removed Errors1" = Table.RemoveRowsWithErrors(#"Invoked Custom Function1", {"GetComputeUsage"}),
    #"Expanded GetComputeUsage" = Table.ExpandTableColumn(#"Removed Errors1", "GetComputeUsage", {"limit", "currentValue", "value", "localizedValue"}, {"limit", "currentValue", "value", "localizedValue"}),
    #"Filtered Rows1" = Table.SelectRows(#"Expanded GetComputeUsage", each [currentValue] > 0)
in
    #"Filtered Rows1"

// Get compute usage
let getcomputeusage = (subscriptionId as text,location as text) =>
let
    Source = Json.Document(Web.Contents(GetManagementURL(AzureKind)&"/subscriptions/"&subscriptionId&"/providers/Microsoft.Compute/locations/"&location&"/usages?api-version=2018-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Converted to Table", {"Column1"}),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Removed Errors", "Column1", {"limit", "unit", "currentValue", "name"}, {"limit", "unit", "currentValue", "name"}),
    #"Expanded name" = Table.ExpandRecordColumn(#"Expanded Column1", "name", {"value", "localizedValue"}, {"value", "localizedValue"})
in
    #"Expanded name"
in getcomputeusage

// NetworkResourcesUsage
let
    Source = #"All Subscriptions",
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "ListOfResources", each ListResources([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListOfResources"}),
    #"Expanded ListOfResources" = Table.ExpandTableColumn(#"Removed Errors", "ListOfResources", {"location"}, {"location"}),
    #"Removed Duplicates1" = Table.Distinct(#"Expanded ListOfResources", {"location", "subscriptionId"}),
    #"Filtered Rows1" = Table.SelectRows(#"Removed Duplicates1", each ([location] <> "global")),
    #"Filtered Rows" = Table.SelectRows(#"Filtered Rows1", each [location] <> null and [location] <> ""),
    #"Invoked Custom Function1" = Table.AddColumn(#"Filtered Rows", "GetNetworkUsage", each #"Get Network usage"([subscriptionId], [location])),
    #"Removed Errors1" = Table.RemoveRowsWithErrors(#"Invoked Custom Function1", {"GetNetworkUsage"}),
    #"Expanded GetNetworkUsage" = Table.ExpandTableColumn(#"Removed Errors1", "GetNetworkUsage", {"limit", "currentValue", "value", "localizedValue"}, {"limit", "currentValue", "value", "localizedValue"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded GetNetworkUsage",{{"limit", Int64.Type}, {"currentValue", Int64.Type}}),
    #"Filtered Rows2" = Table.SelectRows(#"Changed Type", each [currentValue] > 0)
in
    #"Filtered Rows2"

// Get Network usage
let getnetworkusage = (subscriptionId as text,location as text) =>
let
    Source = Json.Document(Web.Contents(GetManagementURL(AzureKind)&"/subscriptions/"&subscriptionId&"/providers/Microsoft.Network/locations/"&location&"/usages?api-version=2018-11-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Converted to Table", {"Column1"}),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Removed Errors", "Column1", {"limit", "currentValue", "name"}, {"limit", "currentValue", "name"}),
    #"Expanded name" = Table.ExpandRecordColumn(#"Expanded Column1", "name", {"value", "localizedValue"}, {"value", "localizedValue"})
in
    #"Expanded name"
in getnetworkusage

// StorageResourcesUsage
let
   Source = #"All Subscriptions",
    #"Invoked Custom Function" = Table.AddColumn(#"All Subscriptions", "ListOfResources", each ListResources([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListOfResources"}),
    #"Expanded ListOfResources" = Table.ExpandTableColumn(#"Removed Errors", "ListOfResources", {"location"}, {"location"}),
    #"Removed Duplicates" = Table.Distinct(#"Expanded ListOfResources", {"subscriptionId", "location"}),
    #"Filtered Rows1" = Table.SelectRows(#"Removed Duplicates", each ([location] <> "global")),
    #"Filtered Rows" = Table.SelectRows(#"Filtered Rows1", each [location] <> null and [location] <> ""),
    #"Invoked Custom Function1" = Table.AddColumn(#"Filtered Rows", "GetStorageUsage", each #"Get Storage usage"([subscriptionId], [location])),
    #"Removed Errors1" = Table.RemoveRowsWithErrors(#"Invoked Custom Function1", {"GetStorageUsage"}),
    #"Expanded GetStorageUsage" = Table.ExpandTableColumn(#"Removed Errors1", "GetStorageUsage", {"limit", "currentValue", "value", "localizedValue"}, {"limit", "currentValue", "value", "localizedValue"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded GetStorageUsage",{{"limit", Int64.Type}, {"currentValue", Int64.Type}}),
    #"Filtered Rows2" = Table.SelectRows(#"Changed Type", each [currentValue] > 0)
in
    #"Filtered Rows2"

// Get Storage usage
let getstorageusage = (subscriptionId as text,location as text) =>
let
    Source = Json.Document(Web.Contents(GetManagementURL(AzureKind)&"/subscriptions/"&subscriptionId&"/providers/Microsoft.Storage/locations/"&location&"/usages?api-version=2019-04-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Converted to Table", {"Column1"}),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Removed Errors", "Column1", {"limit", "currentValue", "name"}, {"limit", "currentValue", "name"}),
    #"Expanded name" = Table.ExpandRecordColumn(#"Expanded Column1", "name", {"value", "localizedValue"}, {"value", "localizedValue"})
in
    #"Expanded name"
in getstorageusage

// All Tenants
let
    Source = Json.Document(Web.Contents(GetManagementURL(AzureKind)&"/tenants?api-version=2019-11-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "tenantId", "countryCode", "displayName", "domains", "tenantCategory"}, {"id", "tenantId", "countryCode", "displayName", "domains", "tenantCategory"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded Column1",{"domains"})
in
    #"Removed Columns"

// Tenant domains
let
    Source = Json.Document(Web.Contents(GetManagementURL(AzureKind)&"/tenants?api-version=2019-11-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "tenantId", "countryCode", "displayName", "domains", "tenantCategory"}, {"id", "tenantId", "countryCode", "displayName", "domains", "tenantCategory"}),
    #"Expanded domains" = Table.ExpandListColumn(#"Expanded Column1", "domains")
in
    #"Expanded domains"

// TenantManagement
let
    Source = Json.Document(Web.Contents(GetManagementURL(AzureKind)&"/subscriptions?api-version=2020-01-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column2" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "authorizationSource", "managedByTenants", "subscriptionId", "tenantId", "displayName", "state", "subscriptionPolicies"}, {"id", "authorizationSource", "managedByTenants", "subscriptionId", "tenantId", "displayName", "state", "subscriptionPolicies"}),
    #"Expanded subscriptionPolicies" = Table.ExpandRecordColumn(#"Expanded Column2", "subscriptionPolicies", {"locationPlacementId", "quotaId", "spendingLimit"}, {"locationPlacementId", "quotaId", "spendingLimit"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded subscriptionPolicies",{"id"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"displayName", "Subscription Name"}}),
    #"Expanded managedByTenants" = Table.ExpandListColumn(#"Renamed Columns", "managedByTenants"),
    #"Expanded managedByTenants1" = Table.ExpandRecordColumn(#"Expanded managedByTenants", "managedByTenants", {"tenantId"}, {"managedByTenants.tenantId"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Expanded managedByTenants1",{"authorizationSource", "state", "locationPlacementId", "quotaId", "spendingLimit"})
in
    #"Removed Columns1"

// ListVirtualMachinesExtensions
let ListVirtualMachinesExtensions = (vmId as text) =>
let
    Source = Json.Document(Web.Contents(GetManagementURL(AzureKind)& vmId &"/extensions?api-version=2019-07-01")),
    value = Source[value]
   
in
    #"value"
in
    ListVirtualMachines