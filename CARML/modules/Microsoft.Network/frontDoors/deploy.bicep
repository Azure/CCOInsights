@description('Required. The name of the frontDoor.')
@minLength(1)
@maxLength(64)
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

@description('Optional. Resource tags.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Required. Backend address pool of the frontdoor resource.')
param backendPools array

@description('Optional. Enforce certificate name check of the frontdoor resource.')
param enforceCertificateNameCheck string = 'Disabled'

@description('Optional. Certificate name check time of the frontdoor resource.')
@maxValue(240)
param sendRecvTimeoutSeconds int = 240

@description('Optional. State of the frontdoor resource.')
param enabledState string = 'Enabled'

@description('Optional. Friendly name of the frontdoor resource.')
param friendlyName string = ''

@description('Required. Frontend endpoints of the frontdoor resource.')
param frontendEndpoints array

@description('Required. Heath probe settings of the frontdoor resource.')
param healthProbeSettings array

@description('Required. Load balancing settings of the frontdoor resource.')
param loadBalancingSettings array

@description('Required. Routing rules settings of the frontdoor resource.')
param routingRules array

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticEventHubName string = ''

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'FrontdoorAccessLog'
  'FrontdoorWebApplicationFirewallLog'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param metricsToEnable array = [
  'AllMetrics'
]

var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs'): {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
] : diagnosticsLogsSpecified

var diagnosticsMetrics = [for metric in metricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

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

resource frontDoor 'Microsoft.Network/frontDoors@2020-05-01' = {
  name: name
  location: 'global'
  tags: tags
  properties: {
    backendPools: backendPools
    backendPoolsSettings: {
      enforceCertificateNameCheck: enforceCertificateNameCheck
      sendRecvTimeoutSeconds: sendRecvTimeoutSeconds
    }
    enabledState: enabledState
    friendlyName: friendlyName
    frontendEndpoints: frontendEndpoints
    healthProbeSettings: healthProbeSettings
    loadBalancingSettings: loadBalancingSettings
    routingRules: routingRules
  }
}

resource frontDoor_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${frontDoor.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: frontDoor
}

resource frontDoor_diagnosticSettingName 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: '${frontDoor.name}-diagnosticSettings'
  properties: {
    storageAccountId: empty(diagnosticStorageAccountId) ? null : diagnosticStorageAccountId
    workspaceId: empty(diagnosticWorkspaceId) ? null : diagnosticWorkspaceId
    eventHubAuthorizationRuleId: empty(diagnosticEventHubAuthorizationRuleId) ? null : diagnosticEventHubAuthorizationRuleId
    eventHubName: empty(diagnosticEventHubName) ? null : diagnosticEventHubName
    metrics: empty(diagnosticStorageAccountId) && empty(diagnosticWorkspaceId) && empty(diagnosticEventHubAuthorizationRuleId) && empty(diagnosticEventHubName) ? null : diagnosticsMetrics
    logs: empty(diagnosticStorageAccountId) && empty(diagnosticWorkspaceId) && empty(diagnosticEventHubAuthorizationRuleId) && empty(diagnosticEventHubName) ? null : diagnosticsLogs
  }
  scope: frontDoor
}

module frontDoor_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-AppGateway-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: frontDoor.id
  }
}]

@description('The name of the front door.')
output name string = frontDoor.name

@description('The resource ID of the front door.')
output resourceId string = frontDoor.id

@description('The resource group the front door was deployed into.')
output resourceGroupName string = resourceGroup().name
