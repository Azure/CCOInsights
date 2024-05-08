@description('Required. The name of the alert.')
param name string

@description('Optional. Description of the alert.')
param alertDescription string = ''

@description('Optional. Location for all resources.')
param location string = 'global'

@description('Optional. Indicates whether this alert is enabled.')
param enabled bool = true

@description('Optional. The severity of the alert.')
@allowed([
  0
  1
  2
  3
  4
])
param severity int = 3

@description('Optional. how often the metric alert is evaluated represented in ISO 8601 duration format.')
@allowed([
  'PT1M'
  'PT5M'
  'PT15M'
  'PT30M'
  'PT1H'
])
param evaluationFrequency string = 'PT5M'

@description('Optional. the period of time (in ISO 8601 duration format) that is used to monitor alert activity based on the threshold.')
@allowed([
  'PT1M'
  'PT5M'
  'PT15M'
  'PT30M'
  'PT1H'
  'PT6H'
  'PT12H'
  'P1D'
])
param windowSize string = 'PT15M'

@description('Optional. the list of resource IDs that this metric alert is scoped to.')
param scopes array = [
  subscription().id
]

@description('Conditional. The resource type of the target resource(s) on which the alert is created/updated. Required if alertCriteriaType is MultipleResourceMultipleMetricCriteria.')
param targetResourceType string = ''

@description('Conditional. The region of the target resource(s) on which the alert is created/updated. Required if alertCriteriaType is MultipleResourceMultipleMetricCriteria.')
param targetResourceRegion string = ''

@description('Optional. The flag that indicates whether the alert should be auto resolved or not.')
param autoMitigate bool = true

@description('Optional. The list of actions to take when alert triggers.')
param actions array = []

@description('Optional. Maps to the \'odata.type\' field. Specifies the type of the alert criteria.')
@allowed([
  'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
  'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
  'Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria'
])
param alertCriteriaType string = 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'

@description('Required. Criterias to trigger the alert. Array of \'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria\' or \'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria\' objects.')
param criterias array

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var actionGroups = [for action in actions: {
  actionGroupId: contains(action, 'actionGroupId') ? action.actionGroupId : action
  webHookProperties: contains(action, 'webHookProperties') ? action.webHookProperties : null
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

resource metricAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    description: alertDescription
    severity: severity
    enabled: enabled
    scopes: scopes
    evaluationFrequency: evaluationFrequency
    windowSize: windowSize
    targetResourceType: targetResourceType
    targetResourceRegion: targetResourceRegion
    criteria: {
      'odata.type': any(alertCriteriaType)
      allOf: criterias
    }
    autoMitigate: autoMitigate
    actions: actionGroups
  }
}

module metricAlert_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-MetricAlert-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: metricAlert.id
  }
}]

@description('The resource group the metric alert was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the metric alert.')
output name string = metricAlert.name

@description('The resource ID of the metric alert.')
output resourceId string = metricAlert.id

@description('The location the resource was deployed into.')
output location string = metricAlert.location
