@sys.description('Required. Name of the Network Manager.')
@minLength(1)
@maxLength(64)
param name string

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@sys.description('Optional. Specify the type of lock.')
param lock string = ''

@sys.description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@sys.description('Optional. Tags of the resource.')
param tags object = {}

@maxLength(500)
@sys.description('Optional. A description of the network manager.')
param description string = ''

@sys.description('Required. Scope Access. String array containing any of "Connectivity", "SecurityAdmin". The connectivity feature allows you to create network topologies at scale. The security admin feature lets you create high-priority security rules, which take precedence over NSGs.')
param networkManagerScopeAccesses array

@sys.description('Required. Scope of Network Manager. Contains a list of management groups or a list of subscriptions. This defines the boundary of network resources that this Network Manager instance can manage. If using Management Groups, ensure that the "Microsoft.Network" resource provider is registered for those Management Groups prior to deployment.')
param networkManagerScopes object

@sys.description('Conditional. Network Groups and static members to create for the network manager. Required if using "connectivityConfigurations" or "securityAdminConfigurations" parameters.')
param networkGroups array = []

@sys.description('Optional. Connectivity Configurations to create for the network manager. Network manager must contain at least one network group in order to define connectivity configurations.')
param connectivityConfigurations array = []

@sys.description('Optional. Scope Connections to create for the network manager. Allows network manager to manage resources from another tenant.')
param scopeConnections array = []

@sys.description('Optional. Security Admin Configurations, Rule Collections and Rules to create for the network manager.')
param securityAdminConfigurations array = []

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
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

resource networkManager 'Microsoft.Network/networkManagers@2022-07-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    description: description
    networkManagerScopeAccesses: networkManagerScopeAccesses
    networkManagerScopes: networkManagerScopes
  }
}

module networkManager_networkGroups 'networkGroups/deploy.bicep' = [for (networkGroup, index) in networkGroups: {
  name: '${uniqueString(deployment().name, location)}-NetworkManager-NetworkGroups-${index}'
  params: {
    name: networkGroup.name
    networkManagerName: networkManager.name
    description: contains(networkGroup, 'description') ? networkGroup.description : ''
    staticMembers: contains(networkGroup, 'staticMembers') ? networkGroup.staticMembers : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module networkManager_connectivityConfigurations 'connectivityConfigurations/deploy.bicep' = [for (connectivityConfiguration, index) in connectivityConfigurations: {
  name: '${uniqueString(deployment().name, location)}-NetworkManager-ConnectivityConfigurations-${index}'
  params: {
    name: connectivityConfiguration.name
    networkManagerName: networkManager.name
    description: contains(connectivityConfiguration, 'description') ? connectivityConfiguration.description : ''
    appliesToGroups: connectivityConfiguration.appliesToGroups
    connectivityTopology: connectivityConfiguration.connectivityTopology
    hubs: contains(connectivityConfiguration, 'hubs') ? connectivityConfiguration.hubs : []
    deleteExistingPeering: contains(connectivityConfiguration, 'hubs') && (connectivityConfiguration.connectivityTopology == 'HubAndSpoke') ? connectivityConfiguration.deleteExistingPeering : 'False'
    isGlobal: contains(connectivityConfiguration, 'isGlobal') ? connectivityConfiguration.isGlobal : 'False'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: networkManager_networkGroups
}]

module networkManager_scopeConnections 'scopeConnections/deploy.bicep' = [for (scopeConnection, index) in scopeConnections: {
  name: '${uniqueString(deployment().name, location)}-NetworkManager-ScopeConnections-${index}'
  params: {
    name: scopeConnection.name
    networkManagerName: networkManager.name
    description: contains(scopeConnection, 'description') ? scopeConnection.description : ''
    resourceId: scopeConnection.resourceId
    tenantId: scopeConnection.tenantId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module networkManager_securityAdminConfigurations 'securityAdminConfigurations/deploy.bicep' = [for (securityAdminConfiguration, index) in securityAdminConfigurations: {
  name: '${uniqueString(deployment().name, location)}-NetworkManager-SecurityAdminConfigurations-${index}'
  params: {
    name: securityAdminConfiguration.name
    networkManagerName: networkManager.name
    description: contains(securityAdminConfiguration, 'description') ? securityAdminConfiguration.description : ''
    applyOnNetworkIntentPolicyBasedServices: securityAdminConfiguration.applyOnNetworkIntentPolicyBasedServices
    ruleCollections: contains(securityAdminConfiguration, 'ruleCollections') ? securityAdminConfiguration.ruleCollections : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: networkGroups
}]

resource networkManager_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${networkManager.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: networkManager
}

module networkManager_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-NetworkManager-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: networkManager.id
  }
}]

@sys.description('The resource group the network manager was deployed into.')
output resourceGroupName string = resourceGroup().name

@sys.description('The resource ID of the network manager.')
output resourceId string = networkManager.id

@sys.description('The name of the network manager.')
output name string = networkManager.name

@sys.description('The location the resource was deployed into.')
output location string = networkManager.location
