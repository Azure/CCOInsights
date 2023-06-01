// ============== //
//   Parameters   //
// ============== //

@description('Required. The name of the data collection rule. The name is case insensitive.')
param name string

@description('Optional. The resource ID of the data collection endpoint that this rule can be used with.')
param dataCollectionEndpointId string = ''

@description('Required. The specification of data flows.')
param dataFlows array

@description('Required. Specification of data sources that will be collected.')
param dataSources object

@description('Optional. Description of the data collection rule.')
param dataCollectionRuleDescription string = ''

@description('Required. Specification of destinations that can be used in data flows.')
param destinations object

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The kind of the resource.')
@allowed([
  'Linux'
  'Windows'
])
param kind string = 'Linux'

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Specify the type of lock.')
@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Declaration of custom streams used in this rule.')
param streamDeclarations object = {}

@description('Optional. Resource tags.')
param tags object = {}

// =============== //
//   Deployments   //
// =============== //

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

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2021-09-01-preview' = {
  kind: kind
  location: location
  name: name
  tags: tags
  properties: {
    dataSources: dataSources
    destinations: destinations
    dataFlows: dataFlows
    dataCollectionEndpointId: !empty(dataCollectionEndpointId) ? dataCollectionEndpointId : null
    streamDeclarations: !empty(streamDeclarations) ? streamDeclarations : null
    description: !empty(dataCollectionRuleDescription) ? dataCollectionRuleDescription : null
  }
}

resource dataCollectionRule_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
  name: '${dataCollectionRule.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: dataCollectionRule
}

module dataCollectionRule_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-dataCollectionRule-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: dataCollectionRule.id
  }
}]

// =========== //
//   Outputs   //
// =========== //

@description('The name of the dataCollectionRule.')
output name string = dataCollectionRule.name

@description('The resource ID of the dataCollectionRule.')
output resourceId string = dataCollectionRule.id

@description('The name of the resource group the dataCollectionRule was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = dataCollectionRule.location
