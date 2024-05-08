@description('Optional. Location where all resources will be created.')
param location string = resourceGroup().location

@description('Required. Name of the Virtual WAN.')
param name string

@description('Optional. The type of the Virtual WAN.')
@allowed([
  'Standard'
  'Basic'
])
param type string = 'Standard'

@description('Optional. True if branch to branch traffic is allowed.')
param allowBranchToBranchTraffic bool = false

@description('Optional. True if VNET to VNET traffic is allowed.')
param allowVnetToVnetTraffic bool = false

@description('Optional. VPN encryption to be disabled or not.')
param disableVpnEncryption bool = false

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

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

resource virtualWan 'Microsoft.Network/virtualWans@2021-08-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    allowBranchToBranchTraffic: allowBranchToBranchTraffic
    allowVnetToVnetTraffic: allowVnetToVnetTraffic ? allowVnetToVnetTraffic : null
    disableVpnEncryption: disableVpnEncryption
    type: type
  }
}

resource virtualWan_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${virtualWan.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: virtualWan
}

module virtualWan_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-VWan-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: virtualWan.id
  }
}]

@description('The name of the virtual WAN.')
output name string = virtualWan.name

@description('The resource ID of the virtual WAN.')
output resourceId string = virtualWan.id

@description('The resource group the virtual WAN was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = virtualWan.location
