Login-AzureRmAccount
Get-AzureRmSubscription | Out-GridView -PassThru

#Resource Types
$ref = @('^recommendations$', '^tasks$', '^alerts$','^managedClusters$','^virtualMachines$','^virtualNetworks$','^networkInterfaces$','^networkInterfaces$','^resourceGroups$','^subscriptions$','^resources$','^roleAssignments$','^roleDefinitions$','^networkSecurityGroups$')    
$refRegex = [string]::Join('|', $ref) 
#Resource Providers
$ref2 = @('Microsoft.Resources','Microsoft.Network','Microsoft.Advisor','Microsoft.Compute','Microsoft.ContainerService','Microsoft.Security','Microsoft.Authorization')
$ref2Regex = [string]::Join('|', $ref2)

#Resource Types (location only for resources)
$ref3 = @('^resourceGroups$','^subscriptions$','^locations$')    
$ref3Regex = [string]::Join('|', $ref3) 

$providers = Get-AzureRmResourceProvider 
$providers | %{
    if ($_.ProviderNamespace -match $ref2Regex){
        "******************************************************************"
        "### Provider:          "+$_.ProviderNamespace
        $resourcetypes = (Get-AzureRmResourceProvider -ProviderNamespace $_.ProviderNamespace).ResourceTypes
        #"### Resource Types:    " + ((Get-AzureRmResourceProvider -ProviderNamespace $_.ProviderNamespace).ResourceTypes).count
        ""
        #We only want to show location resource API version if the provider is Microsoft.Resources
        if ($_.ProviderNamespace -eq 'Microsoft.Resources'){ 
                $resourcetypes | %{
                    If ($_.ResourceTypeName -match $ref3Regex){
                        "- Resource Type Name:  " + $_.ResourceTypeName 
                        "- API last version:    " + ($_.ApiVersions | Select-Object -First 1)
                        ""
                    }
                }
        }
        else{
            $resourcetypes | %{
                    If ($_.ResourceTypeName -match $refRegex){
                        "- Resource Type Name:  " + $_.ResourceTypeName 
                        "- API last version:    " + ($_.ApiVersions | Select-Object -First 1)
                        ""
                    }
            }
        }
    }
}
