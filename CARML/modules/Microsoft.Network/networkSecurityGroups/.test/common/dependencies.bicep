@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Application Security Group to create.')
param applicationSecurityGroupName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
    name: managedIdentityName
    location: location
}

resource applicationSecurityGroup 'Microsoft.Network/applicationSecurityGroups@2022-01-01' = {
    name: applicationSecurityGroupName
    location: location
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Application Security Group.')
output applicationSecurityGroupResourceId string = applicationSecurityGroup.id
