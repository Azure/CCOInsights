@description('Required. Name of the App Service Environment.')
@minLength(1)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Kind of resource.')
param kind string = 'ASEv3'

@description('Required. ResourceId for the subnet.')
param subnetResourceId string

@description('Optional. Specifies which endpoints to serve internally in the Virtual Network for the App Service Environment. - None, Web, Publishing, Web,Publishing.')
@allowed([
  'None'
  'Web'
  'Publishing'
])
param internalLoadBalancingMode string = 'None'

@description('Optional. Frontend VM size. Cannot be used with \'kind\' `ASEv3`.')
@allowed([
  ''
  'Medium'
  'Large'
  'ExtraLarge'
  'Standard_D2'
  'Standard_D3'
  'Standard_D4'
  'Standard_D1_V2'
  'Standard_D2_V2'
  'Standard_D3_V2'
  'Standard_D4_V2'
])
param multiSize string = ''

@description('Optional. Number of IP SSL addresses reserved for the App Service Environment.')
param ipsslAddressCount int = -1

@description('Optional. DNS suffix of the App Service Environment.')
param dnsSuffix string = ''

@description('Optional. Scale factor for frontends.')
param frontEndScaleFactor int = 15

@description('Optional. User added IP ranges to whitelist on ASE DB. Cannot be used with \'kind\' `ASEv3`.')
param userWhitelistedIpRanges array = []

@description('Optional. Custom settings for changing the behavior of the App Service Environment.')
param clusterSettings array = [
  {
    name: 'DisableTls1.0'
    value: '1'
  }
]

@description('Optional. Switch to make the App Service Environment zone redundant. If enabled, the minimum App Service plan instance count will be three, otherwise 1. If enabled, the `dedicatedHostCount` must be set to `-1`.')
param zoneRedundant bool = false

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

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

@description('Optional. The Dedicated Host Count. Is not supported by ASEv2. If `zoneRedundant` is false, and you want physical hardware isolation enabled, set to 2. Otherwise 0.')
param dedicatedHostCount int = -1

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'AppServiceEnvironmentPlatformLogs'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsName string = '${name}-diagnosticSettings'

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

resource appServiceEnvironment 'Microsoft.Web/hostingEnvironments@2021-03-01' = {
  name: name
  kind: kind
  location: location
  tags: tags
  properties: {
    virtualNetwork: {
      id: subnetResourceId
      subnet: last(split(subnetResourceId, '/'))
    }
    internalLoadBalancingMode: internalLoadBalancingMode
    multiSize: !empty(multiSize) ? any(multiSize) : null
    ipsslAddressCount: ipsslAddressCount != -1 ? ipsslAddressCount : null
    dnsSuffix: dnsSuffix
    frontEndScaleFactor: frontEndScaleFactor
    clusterSettings: clusterSettings
    userWhitelistedIpRanges: !empty(userWhitelistedIpRanges) ? userWhitelistedIpRanges : null
    dedicatedHostCount: dedicatedHostCount != -1 ? dedicatedHostCount : null
    zoneRedundant: zoneRedundant
  }
}

resource appServiceEnvironment_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${appServiceEnvironment.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: appServiceEnvironment
}

resource appServiceEnvironment_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: diagnosticSettingsName
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    logs: diagnosticsLogs
  }
  scope: appServiceEnvironment
}

module appServiceEnvironment_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-AppServiceEnv-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: appServiceEnvironment.id
  }
}]

@description('The resource ID of the app service environment.')
output resourceId string = appServiceEnvironment.id

@description('The resource group the app service environment was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the app service environment.')
output name string = appServiceEnvironment.name

@description('The location the resource was deployed into.')
output location string = appServiceEnvironment.location
