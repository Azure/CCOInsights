targetScope = 'subscription'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Required. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    managedIdentityName: managedIdentityName
  }
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = nestedDependencies.outputs.managedIdentityPrincipalId
