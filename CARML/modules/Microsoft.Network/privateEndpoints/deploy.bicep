@description('Required. Name of the private endpoint resource to create.')
param name string

@description('Required. Resource ID of the subnet where the endpoint needs to be created.')
param subnetResourceId string

@description('Required. Resource ID of the resource that needs to be connected to the network.')
param serviceResourceId string

@description('Optional. Application security groups in which the private endpoint IP configuration is included.')
param applicationSecurityGroups array = []

@description('Optional. The custom name of the network interface attached to the private endpoint.')
param customNetworkInterfaceName string = ''

@description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
param ipConfigurations array = []

@description('Required. Subtype(s) of the connection to be created. The allowed values depend on the type serviceResourceId refers to.')
param groupIds array

@description('Optional. The private DNS zone group configuration used to associate the private endpoint with one or multiple private DNS zones. A DNS zone group can support up to 5 DNS zones.')
param privateDnsZoneGroup object = {}

@description('Optional. Location for all Resources.')
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

@description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
param tags object = {}

@description('Optional. Custom DNS configurations.')
param customDnsConfigs array = []

@description('Optional. Manual PrivateLink Service Connections.')
param manualPrivateLinkServiceConnections array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

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

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    applicationSecurityGroups: applicationSecurityGroups
    customNetworkInterfaceName: customNetworkInterfaceName
    ipConfigurations: ipConfigurations
    privateLinkServiceConnections: [
      {
        name: name
        properties: {
          privateLinkServiceId: serviceResourceId
          groupIds: groupIds
        }
      }
    ]
    manualPrivateLinkServiceConnections: manualPrivateLinkServiceConnections
    subnet: {
      id: subnetResourceId
    }
    customDnsConfigs: customDnsConfigs
  }
}

module privateEndpoint_privateDnsZoneGroup 'privateDnsZoneGroups/deploy.bicep' = if (!empty(privateDnsZoneGroup)) {
  name: '${uniqueString(deployment().name, location)}-PrivateEndpoint-PrivateDnsZoneGroup'
  params: {
    privateDNSResourceIds: privateDnsZoneGroup.privateDNSResourceIds
    privateEndpointName: privateEndpoint.name
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

resource privateEndpoint_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${privateEndpoint.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: privateEndpoint
}

module privateEndpoint_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-PrivateEndpoint-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: privateEndpoint.id
  }
}]

@description('The resource group the private endpoint was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the private endpoint.')
output resourceId string = privateEndpoint.id

@description('The name of the private endpoint.')
output name string = privateEndpoint.name

@description('The location the resource was deployed into.')
output location string = privateEndpoint.location
