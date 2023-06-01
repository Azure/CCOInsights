@description('Required. Name of the Traffic Manager.')
@minLength(1)
param name string

@description('Optional. The status of the Traffic Manager profile.')
@allowed([
  'Enabled'
  'Disabled'
])
param profileStatus string = 'Enabled'

@description('Optional. The traffic routing method of the Traffic Manager profile.')
@allowed([
  'Performance'
  'Priority'
  'Weighted'
  'Geographic'
  'MultiValue'
  'Subnet'
])
param trafficRoutingMethod string = 'Performance'

@description('Required. The relative DNS name provided by this Traffic Manager profile. This value is combined with the DNS domain name used by Azure Traffic Manager to form the fully-qualified domain name (FQDN) of the profile.')
param relativeName string

@description('Optional. The DNS Time-To-Live (TTL), in seconds. This informs the local DNS resolvers and DNS clients how long to cache DNS responses provided by this Traffic Manager profile.')
param ttl int = 60

@description('Optional. The endpoint monitoring settings of the Traffic Manager profile.')
param monitorConfig object = {
  protocol: 'http'
  port: '80'
  path: '/'
}

@description('Optional. The list of endpoints in the Traffic Manager profile.')
param endpoints array = []

@description('Optional. Indicates whether Traffic View is \'Enabled\' or \'Disabled\' for the Traffic Manager profile. Null, indicates \'Disabled\'. Enabling this feature will increase the cost of the Traffic Manage profile.')
@allowed([
  'Disabled'
  'Enabled'
])
param trafficViewEnrollmentStatus string = 'Disabled'

@description('Optional. Maximum number of endpoints to be returned for MultiValue routing type.')
param maxReturn int = 1

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

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'ProbeHealthStatusEvents'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
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

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource trafficManagerProfile 'Microsoft.Network/trafficmanagerprofiles@2018-08-01' = {
  name: name
  tags: tags
  location: 'global'
  properties: {
    profileStatus: profileStatus
    trafficRoutingMethod: trafficRoutingMethod
    dnsConfig: {
      relativeName: relativeName
      ttl: ttl
    }
    monitorConfig: monitorConfig
    endpoints: endpoints
    trafficViewEnrollmentStatus: trafficViewEnrollmentStatus
    maxReturn: maxReturn
  }
}

resource trafficManagerProfile_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${trafficManagerProfile.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: trafficManagerProfile
}

resource trafficManagerProfile_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: diagnosticSettingsName
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: trafficManagerProfile
}

module trafficManagerProfile_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name)}-TrafficManagerProfile-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: trafficManagerProfile.id
  }
}]

@description('The resource ID of the traffic manager.')
output resourceId string = trafficManagerProfile.id

@description('The resource group the traffic manager was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the traffic manager was deployed into.')
output name string = trafficManagerProfile.name
