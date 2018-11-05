// Virtual Machines
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId", "displayName"}, {"subscriptionId", "displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"displayName", "Subscription Name"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns", "ListVirtualMachines", each ListVirtualMachines([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListVirtualMachines"}),
    #"Expanded ListVirtualMachines" = Table.ExpandTableColumn(#"Removed Errors", "ListVirtualMachines", {"Availability Set Id", "vmSize", "publisher", "offer", "sku", "version", "osType", "name", "createOption", "vhd uri", "caching", "diskSizeGB", "storageAccountType", "Managed Disk Id", "lun", "name.1", "createOption.1", "Data vhd uri", "caching.1", "diskSizeGB.1", "computerName", "adminUsername", "provisionVMAgent", "enableAutomaticUpdates", "Network Inteface Id", "provisioningState", "enabled", "storageUri", "Extensions Resource Id", "type", "location", "creationSource", "orchestrator", "poolName", "resourceNameSuffix", "VM Resource Id", "VM Name"}, {"Availability Set Id", "vmSize", "publisher", "offer", "sku", "version", "osType", "name", "createOption", "vhd uri", "caching", "diskSizeGB", "storageAccountType", "Managed Disk Id", "lun", "name.1", "createOption.1", "Data vhd uri", "caching.1", "diskSizeGB.1", "computerName", "adminUsername", "provisionVMAgent", "enableAutomaticUpdates", "Network Inteface Id", "provisioningState", "enabled", "storageUri", "Extensions Resource Id", "type", "location", "creationSource", "orchestrator", "poolName", "resourceNameSuffix", "VM Resource Id", "VM Name"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded ListVirtualMachines",{"subscriptionId", "Subscription Name"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Columns", {"VM Resource Id"}),
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
    #"Added Conditional Column1" = Table.AddColumn(#"Renamed Columns2", "IsRunningContainers", each if [orchestrator] = null then "VM without Containers" else "VM with Containers"),
    #"Replaced Value" = Table.ReplaceValue(#"Added Conditional Column1",null,"Custom",Replacer.ReplaceValue,{"offer"}),
    #"Added Conditional Column2" = Table.AddColumn(#"Replaced Value", "OS Type", each if [osType] = "Windows" then "https://raw.githubusercontent.com/JSFCES/DashboardImages/master/WindowsLogo.svg?sanitize=true" else if [osType] = "Linux" then "https://raw.githubusercontent.com/JSFCES/DashboardImages/dbf1dcabfb992474849157c48596a5f05c9512b1/LinuxLogo.svg?sanitize=true" else null),
    #"Changed Type1" = Table.TransformColumnTypes(#"Added Conditional Column2",{{"OS Type", type text}})
in
    #"Changed Type1"

// ListVirtualMachines
let ListVirtualMachines = (subscriptionId as text) =>
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions/"&subscriptionId&"/providers/Microsoft.Compute/virtualMachines?api-version=2017-12-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
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

// Containers VMs
let
    Source = Json.Document(Web.Contents("https://management.azure.com/subscriptions?api-version=2016-06-01")),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"subscriptionId", "displayName"}, {"subscriptionId", "displayName"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Column1",{{"displayName", "Subscription Name"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns", "ListVirtualMachines", each ListVirtualMachines([subscriptionId])),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Invoked Custom Function", {"ListVirtualMachines"}),
    #"Expanded ListVirtualMachines" = Table.ExpandTableColumn(#"Removed Errors", "ListVirtualMachines", {"Availability Set Id", "vmSize", "publisher", "offer", "sku", "version", "osType", "name", "createOption", "vhd uri", "caching", "diskSizeGB", "storageAccountType", "Managed Disk Id", "lun", "name.1", "createOption.1", "Data vhd uri", "caching.1", "diskSizeGB.1", "computerName", "adminUsername", "provisionVMAgent", "enableAutomaticUpdates", "Network Inteface Id", "provisioningState", "enabled", "storageUri", "Extensions Resource Id", "type", "location", "creationSource", "orchestrator", "poolName", "resourceNameSuffix", "VM Resource Id", "VM Name"}, {"Availability Set Id", "vmSize", "publisher", "offer", "sku", "version", "osType", "name", "createOption", "vhd uri", "caching", "diskSizeGB", "storageAccountType", "Managed Disk Id", "lun", "name.1", "createOption.1", "Data vhd uri", "caching.1", "diskSizeGB.1", "computerName", "adminUsername", "provisionVMAgent", "enableAutomaticUpdates", "Network Inteface Id", "provisioningState", "enabled", "storageUri", "Extensions Resource Id", "type", "location", "creationSource", "orchestrator", "poolName", "resourceNameSuffix", "VM Resource Id", "VM Name"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded ListVirtualMachines",{"subscriptionId", "Subscription Name"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Columns", {"VM Resource Id"}),
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
    #"Added Conditional Column1" = Table.AddColumn(#"Renamed Columns2", "IsRunningContainers", each if [orchestrator] = null then "VM without Containers" else "VM with Containers"),
    #"Replaced Value" = Table.ReplaceValue(#"Added Conditional Column1",null,"Custom",Replacer.ReplaceValue,{"offer"}),
    #"Added Conditional Column2" = Table.AddColumn(#"Replaced Value", "OS Type", each if [osType] = "Windows" then "https://raw.githubusercontent.com/JSFCES/DashboardImages/master/WindowsLogo.svg?sanitize=true" else if [osType] = "Linux" then "https://raw.githubusercontent.com/JSFCES/DashboardImages/dbf1dcabfb992474849157c48596a5f05c9512b1/LinuxLogo.svg?sanitize=true" else null),
    #"Changed Type1" = Table.TransformColumnTypes(#"Added Conditional Column2",{{"OS Type", type text}}),
    #"Filtered Rows" = Table.SelectRows(#"Changed Type1", each ([IsRunningContainers] = "VM with Containers"))
in
    #"Filtered Rows"