@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Route Table to create.')
param routeTableName string

@description('Required. The name of the Network Security Group to create.')
param networkSecurityGroupName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
    name: managedIdentityName
    location: location
}

resource routeTable 'Microsoft.Network/routeTables@2022-01-01' = {
    name: routeTableName
    location: location
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
    name: networkSecurityGroupName
    location: location
}

@description('The resource ID of the created Route Table.')
output routeTableResourceId string = routeTable.id

@description('The resource ID of the created Network Security Group.')
output networkSecurityGroupResourceId string = networkSecurityGroup.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
