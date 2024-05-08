@description('Required. Name of the Private DNS Resolver.')
@minLength(1)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Required. ResourceId of the virtual network to attach the Private DNS Resolver to.')
param virtualNetworkId string

@description('Optional. Outbound Endpoints for Private DNS Resolver.')
param outboundEndpoints array = []

@description('Optional. Inbound Endpoints for Private DNS Resolver.')
param inboundEndpoints array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

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

resource dnsResolver 'Microsoft.Network/dnsResolvers@2022-07-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    virtualNetwork: {
      id: virtualNetworkId
    }
  }
}

resource dnsResolver_inboundEndpoint 'Microsoft.Network/dnsResolvers/inboundEndpoints@2022-07-01' = [for inboundEndpoint in inboundEndpoints: {
  name: inboundEndpoint.name
  parent: dnsResolver
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        subnet: {
          id: inboundEndpoint.subnetId
        }
      }
    ]
  }
}]

resource dnsResolver_outboundEndpoint 'Microsoft.Network/dnsResolvers/outboundEndpoints@2022-07-01' = [for outboundEndpoint in outboundEndpoints: {
  name: outboundEndpoint.name
  parent: dnsResolver
  location: location
  tags: tags
  properties: {
    subnet: {
      id: outboundEndpoint.subnetId
    }
  }
}]

resource dnsResolver_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${dnsResolver.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: dnsResolver
}

module dnsResolver_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-dnsResolver-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: dnsResolver.id
  }
}]

@description('The resource group the Private DNS Resolver was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the Private DNS Resolver.')
output resourceId string = dnsResolver.id

@description('The name of the Private DNS Resolver.')
output name string = dnsResolver.name

@description('The location the resource was deployed into.')
output location string = dnsResolver.location
