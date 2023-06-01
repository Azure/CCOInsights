@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Public IP to create.')
param publicIPName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Deployment Script to create for the Certificate generation.')
param certDeploymentScriptName string

var addressPrefix = '10.0.0.0/16'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
    name: virtualNetworkName
    location: location
    properties: {
        addressSpace: {
            addressPrefixes: [
                addressPrefix
            ]
        }
        subnets: [
            {
                name: 'defaultSubnet'
                properties: {
                    addressPrefix: addressPrefix
                }
            }
        ]
    }
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
    name: publicIPName
    location: location
    sku: {
        name: 'Standard'
        tier: 'Regional'
    }
    properties: {
        publicIPAllocationMethod: 'Static'
    }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
    name: managedIdentityName
    location: location
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
    name: keyVaultName
    location: location
    properties: {
        sku: {
            family: 'A'
            name: 'standard'
        }
        tenantId: tenant().tenantId
        enablePurgeProtection: null
        enabledForTemplateDeployment: true
        enabledForDiskEncryption: true
        enabledForDeployment: true
        enableRbacAuthorization: true
        accessPolicies: []
    }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
    name: guid('msi-${managedIdentity.name}-KeyVault-Admin-RoleAssignment')
    scope: keyVault
    properties: {
        principalId: managedIdentity.properties.principalId
        roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00482a5a-887f-4fb3-b363-3b7fe8e74483') // Key Vault Administrator
        principalType: 'ServicePrincipal'
    }
}

resource certDeploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
    name: certDeploymentScriptName
    location: location
    kind: 'AzurePowerShell'
    identity: {
        type: 'UserAssigned'
        userAssignedIdentities: {
            '${managedIdentity.id}': {}
        }
    }
    properties: {
        azPowerShellVersion: '8.0'
        retentionInterval: 'P1D'
        arguments: '-KeyVaultName "${keyVault.name}" -CertName "applicationGatewaySslCertificate"'
        scriptContent: loadTextContent('../.scripts/New-Certificate.ps1')
    }
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created Public IP.')
output publicIPResourceId string = publicIP.id

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The URL of the created certificate.')
output certificateSecretUrl string = certDeploymentScript.properties.outputs.secretUrl

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
