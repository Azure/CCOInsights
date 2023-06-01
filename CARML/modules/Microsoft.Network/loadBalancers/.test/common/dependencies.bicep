@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Public IP to create.')
param publicIPName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

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
    zones: [
        '1'
        '2'
        '3'
    ]
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
    name: managedIdentityName
    location: location
}

@description('The resource ID of the created Public IP.')
output publicIPResourceId string = publicIP.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
