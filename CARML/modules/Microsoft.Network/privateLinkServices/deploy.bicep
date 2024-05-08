@description('Required. Name of the private link service to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
param tags object = {}

@description('Optional. The extended location of the load balancer.')
param extendedLocation object = {}

@description('Optional. The auto-approval list of the private link service.')
param autoApproval object = {}

@description('Optional. Whether the private link service is enabled for proxy protocol or not.')
param enableProxyProtocol bool = false

@description('Optional. The list of Fqdn.')
param fqdns array = []

@description('Optional. An array of private link service IP configurations.')
param ipConfigurations array = []

@description('Optional. An array of references to the load balancer IP configurations.')
param loadBalancerFrontendIpConfigurations array = []

@description('Optional. The visibility list of the private link service.')
param visibility object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

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

resource privateLinkService 'Microsoft.Network/privateLinkServices@2022-01-01' = {
  name: name
  location: location
  tags: tags
  extendedLocation: !empty(extendedLocation) ? extendedLocation : null
  properties: {
    autoApproval: autoApproval
    enableProxyProtocol: enableProxyProtocol
    fqdns: fqdns
    ipConfigurations: ipConfigurations
    loadBalancerFrontendIpConfigurations: loadBalancerFrontendIpConfigurations
    visibility: visibility
  }
}

resource privateLinkService_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${privateLinkService.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: privateLinkService
}

module privateLinkService_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-PrivateLinkService-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: privateLinkService.id
  }
}]

@description('The resource group the private link service was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the private link service.')
output resourceId string = privateLinkService.id

@description('The name of the private link service.')
output name string = privateLinkService.name

@description('The location the resource was deployed into.')
output location string = privateLinkService.location
