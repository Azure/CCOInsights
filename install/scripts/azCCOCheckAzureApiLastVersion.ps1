az login
az account show  | Out-GridView -PassThru

#Resource Types
$ref = @('^recommendations$', '^tasks$', '^alerts$', '^managedClusters$', '^virtualMachines$', '^virtualNetworks$', '^networkInterfaces$', '^networkInterfaces$', '^resourceGroups$', '^subscriptions$', '^roleAssignments$', '^roleDefinitions$', '^networkSecurityGroups$')    
$refRegex = [string]::Join('|', $ref) 
#Resource Providers
$ref2 = @('Microsoft.Resources', 'Microsoft.Network', 'Microsoft.Advisor', 'Microsoft.Compute', 'Microsoft.ContainerService', 'Microsoft.Security', 'Microsoft.Authorization')

#Resource Types (location only for resources)
$ref3 = @('^resourceGroups$', '^subscriptions$', '^locations$')    
$ref3Regex = [string]::Join('|', $ref3) 

$providers = (az provider list | ConvertFrom-Json)
$providers | % {
    if ($ref2 -contains $_.namespace) {
        "******************************************************************"
        "### Provider:          " + $_.namespace
        $resourcetypes = (az provider show --namespace $_.namespace | ConvertFrom-Json).ResourceTypes
        #"### Resource Types:    " + ((Get-AzureRmResourceProvider -ProviderNamespace $_.namespace).ResourceTypes).count
        ""
        #We only want to show location resource API version if the provider is Microsoft.Resources
        if ($_.namespace -eq 'Microsoft.Resources') { 
            $resourcetypes | % {
                If ($_.resourceType -match $ref3Regex) {
                    "- Resource Type Name:  " + $_.resourceType 
                    "- API last version:    " + ($_.apiVersions | Select-Object -First 1)
                    ""
                }
            }
        }
        else {
            $resourcetypes | % {
                If ($_.resourceType -match $refRegex) {
                    "- Resource Type Name:  " + $_.resourceType 
                    "- API last version:    " + ($_.apiVersions | Select-Object -First 1)
                    ""
                }
            }
        }
    }
}
