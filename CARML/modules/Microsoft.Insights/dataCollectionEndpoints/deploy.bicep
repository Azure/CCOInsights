// ============== //
//   Parameters   //
// ============== //

@description('Required. The name of the data collection endpoint. The name is case insensitive.')
param name string

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The kind of the resource.')
@allowed([
  'Linux'
  'Windows'
])
param kind string = 'Linux'

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Specify the type of lock.')
@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. The configuration to set whether network access from public internet to the endpoints are allowed.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

@description('Optional. Resource tags.')
param tags object = {}

// =============== //
//   Deployments   //
// =============== //

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource dataCollectionEndpoint 'Microsoft.Insights/dataCollectionEndpoints@2021-04-01' = {
  kind: kind
  location: location
  name: name
  tags: tags
  properties: {
    networkAcls: {
      publicNetworkAccess: publicNetworkAccess
    }
  }
}

resource dataCollectionEndpoint_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
  name: '${dataCollectionEndpoint.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: dataCollectionEndpoint
}

module dataCollectionEndpoint_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-dataCollectionEndpoint-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: dataCollectionEndpoint.id
  }
}]

// =========== //
//   Outputs   //
// =========== //

@description('The name of the dataCollectionEndpoint.')
output name string = dataCollectionEndpoint.name

@description('The resource ID of the dataCollectionEndpoint.')
output resourceId string = dataCollectionEndpoint.id

@description('The name of the resource group the dataCollectionEndpoint was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = dataCollectionEndpoint.location
