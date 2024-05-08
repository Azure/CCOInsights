@description('Optional. Name of the Network Watcher resource (hidden).')
@minLength(1)
param name string = 'NetworkWatcher_${location}'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array that contains the Connection Monitors.')
param connectionMonitors array = []

@description('Optional. Array that contains the Flow Logs.')
param flowLogs array = []

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

resource networkWatcher 'Microsoft.Network/networkWatchers@2021-08-01' = {
  name: name
  location: location
  tags: tags
  properties: {}
}

resource networkWatcher_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${networkWatcher.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: networkWatcher
}

module networkWatcher_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-NW-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: networkWatcher.id
  }
}]

module networkWatcher_connectionMonitors 'connectionMonitors/deploy.bicep' = [for (connectionMonitor, index) in connectionMonitors: {
  name: '${uniqueString(deployment().name, location)}-NW-ConnectionMonitor-${index}'
  params: {
    endpoints: contains(connectionMonitor, 'endpoints') ? connectionMonitor.endpoints : []
    name: connectionMonitor.name
    networkWatcherName: networkWatcher.name
    testConfigurations: contains(connectionMonitor, 'testConfigurations') ? connectionMonitor.testConfigurations : []
    testGroups: contains(connectionMonitor, 'testGroups') ? connectionMonitor.testGroups : []
    workspaceResourceId: contains(connectionMonitor, 'workspaceResourceId') ? connectionMonitor.workspaceResourceId : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module networkWatcher_flowLogs 'flowLogs/deploy.bicep' = [for (flowLog, index) in flowLogs: {
  name: '${uniqueString(deployment().name, location)}-NW-FlowLog-${index}'
  params: {
    enabled: contains(flowLog, 'enabled') ? flowLog.enabled : true
    formatVersion: contains(flowLog, 'formatVersion') ? flowLog.formatVersion : 2
    location: contains(flowLog, 'location') ? flowLog.location : location
    name: contains(flowLog, 'name') ? flowLog.name : '${last(split(flowLog.targetResourceId, '/'))}-${split(flowLog.targetResourceId, '/')[4]}-flowlog'
    networkWatcherName: networkWatcher.name
    retentionInDays: contains(flowLog, 'retentionInDays') ? flowLog.retentionInDays : 365
    storageId: flowLog.storageId
    targetResourceId: flowLog.targetResourceId
    trafficAnalyticsInterval: contains(flowLog, 'trafficAnalyticsInterval') ? flowLog.trafficAnalyticsInterval : 60
    workspaceResourceId: contains(flowLog, 'workspaceResourceId') ? flowLog.workspaceResourceId : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

@description('The name of the deployed network watcher.')
output name string = networkWatcher.name

@description('The resource ID of the deployed network watcher.')
output resourceId string = networkWatcher.id

@description('The resource group the network watcher was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = networkWatcher.location
