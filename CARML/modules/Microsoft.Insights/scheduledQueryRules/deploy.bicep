@description('Required. The name of the Alert.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The description of the scheduled query rule.')
param alertDescription string = ''

@description('Optional. The flag which indicates whether this scheduled query rule is enabled.')
param enabled bool = true

@description('Optional. Indicates the type of scheduled query rule.')
@allowed([
  'LogAlert'
  'LogToMetric'
])
param kind string = 'LogAlert'

@description('Optional. The flag that indicates whether the alert should be automatically resolved or not. Relevant only for rules of the kind LogAlert.')
param autoMitigate bool = true

@description('Optional. If specified (in ISO 8601 duration format) then overrides the query time range. Relevant only for rules of the kind LogAlert.')
param queryTimeRange string = ''

@description('Optional. The flag which indicates whether the provided query should be validated or not. Relevant only for rules of the kind LogAlert.')
param skipQueryValidation bool = false

@description('Optional. List of resource type of the target resource(s) on which the alert is created/updated. For example if the scope is a resource group and targetResourceTypes is Microsoft.Compute/virtualMachines, then a different alert will be fired for each virtual machine in the resource group which meet the alert criteria. Relevant only for rules of the kind LogAlert.')
param targetResourceTypes array = []

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Required. The list of resource IDs that this scheduled query rule is scoped to.')
param scopes array

@description('Optional. Severity of the alert. Should be an integer between [0-4]. Value of 0 is severest. Relevant and required only for rules of the kind LogAlert.')
@allowed([
  0
  1
  2
  3
  4
])
param severity int = 3

@description('Optional. How often the scheduled query rule is evaluated represented in ISO 8601 duration format. Relevant and required only for rules of the kind LogAlert.')
param evaluationFrequency string = ''

@description('Optional. The period of time (in ISO 8601 duration format) on which the Alert query will be executed (bin size). Relevant and required only for rules of the kind LogAlert.')
param windowSize string = ''

@description('Optional. Actions to invoke when the alert fires.')
param actions array = []

@description('Required. The rule criteria that defines the conditions of the scheduled query rule.')
param criterias object

@description('Optional. Mute actions for the chosen period of time (in ISO 8601 duration format) after the alert is fired. If set, autoMitigate must be disabled.Relevant only for rules of the kind LogAlert.')
param suppressForMinutes string = ''

@description('Optional. Tags of the resource.')
param tags object = {}

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

resource queryRule 'Microsoft.Insights/scheduledQueryRules@2021-02-01-preview' = {
  name: name
  location: location
  tags: tags
  kind: kind
  properties: {
    actions: {
      actionGroups: actions
      customProperties: {}
    }
    autoMitigate: (kind == 'LogAlert') ? autoMitigate : null
    criteria: criterias
    description: alertDescription
    displayName: name
    enabled: enabled
    evaluationFrequency: (kind == 'LogAlert' && !empty(evaluationFrequency)) ? evaluationFrequency : null
    muteActionsDuration: (kind == 'LogAlert' && !empty(suppressForMinutes)) ? suppressForMinutes : null
    overrideQueryTimeRange: (kind == 'LogAlert' && !empty(queryTimeRange)) ? queryTimeRange : null
    scopes: scopes
    severity: (kind == 'LogAlert') ? severity : null
    skipQueryValidation: (kind == 'LogAlert') ? skipQueryValidation : null
    targetResourceTypes: (kind == 'LogAlert') ? targetResourceTypes : null
    windowSize: (kind == 'LogAlert' && !empty(windowSize)) ? windowSize : null
  }
}

module queryRule_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-QueryRule-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: queryRule.id
  }
}]

@description('The Name of the created query rule.')
output name string = queryRule.name

@description('The resource ID of the created query rule.')
output resourceId string = queryRule.id

@description('The Resource Group of the created query rule.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = queryRule.location
