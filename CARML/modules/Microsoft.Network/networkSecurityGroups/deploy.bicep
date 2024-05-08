@description('Required. Name of the Network Security Group.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array of Security Rules to deploy to the Network Security Group. When not provided, an NSG including only the built-in roles will be deployed.')
param securityRules array = []

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

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

@description('Optional. Tags of the NSG resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'NetworkSecurityGroupEvent'
  'NetworkSecurityGroupRuleCounter'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsName string = '${name}-diagnosticSettings'

var enableReferencedModulesTelemetry = false

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

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    securityRules: [for securityRule in securityRules: {
      name: securityRule.name
      properties: {
        protocol: securityRule.properties.protocol
        access: securityRule.properties.access
        priority: securityRule.properties.priority
        direction: securityRule.properties.direction
        description: contains(securityRule.properties, 'description') ? securityRule.properties.description : ''
        sourcePortRange: contains(securityRule.properties, 'sourcePortRange') ? securityRule.properties.sourcePortRange : ''
        sourcePortRanges: contains(securityRule.properties, 'sourcePortRanges') ? securityRule.properties.sourcePortRanges : []
        destinationPortRange: contains(securityRule.properties, 'destinationPortRange') ? securityRule.properties.destinationPortRange : ''
        destinationPortRanges: contains(securityRule.properties, 'destinationPortRanges') ? securityRule.properties.destinationPortRanges : []
        sourceAddressPrefix: contains(securityRule.properties, 'sourceAddressPrefix') ? securityRule.properties.sourceAddressPrefix : ''
        destinationAddressPrefix: contains(securityRule.properties, 'destinationAddressPrefix') ? securityRule.properties.destinationAddressPrefix : ''
        sourceAddressPrefixes: contains(securityRule.properties, 'sourceAddressPrefixes') ? securityRule.properties.sourceAddressPrefixes : []
        destinationAddressPrefixes: contains(securityRule.properties, 'destinationAddressPrefixes') ? securityRule.properties.destinationAddressPrefixes : []
        sourceApplicationSecurityGroups: contains(securityRule.properties, 'sourceApplicationSecurityGroups') ? securityRule.properties.sourceApplicationSecurityGroups : []
        destinationApplicationSecurityGroups: contains(securityRule.properties, 'destinationApplicationSecurityGroups') ? securityRule.properties.destinationApplicationSecurityGroups : []
      }
    }]
  }
}

module networkSecurityGroup_securityRules 'securityRules/deploy.bicep' = [for (securityRule, index) in securityRules: {
  name: '${uniqueString(deployment().name, location)}-securityRule-${index}'
  params: {
    name: securityRule.name
    networkSecurityGroupName: networkSecurityGroup.name
    protocol: securityRule.properties.protocol
    access: securityRule.properties.access
    priority: securityRule.properties.priority
    direction: securityRule.properties.direction
    description: contains(securityRule.properties, 'description') ? securityRule.properties.description : ''
    sourcePortRange: contains(securityRule.properties, 'sourcePortRange') ? securityRule.properties.sourcePortRange : ''
    sourcePortRanges: contains(securityRule.properties, 'sourcePortRanges') ? securityRule.properties.sourcePortRanges : []
    destinationPortRange: contains(securityRule.properties, 'destinationPortRange') ? securityRule.properties.destinationPortRange : ''
    destinationPortRanges: contains(securityRule.properties, 'destinationPortRanges') ? securityRule.properties.destinationPortRanges : []
    sourceAddressPrefix: contains(securityRule.properties, 'sourceAddressPrefix') ? securityRule.properties.sourceAddressPrefix : ''
    destinationAddressPrefix: contains(securityRule.properties, 'destinationAddressPrefix') ? securityRule.properties.destinationAddressPrefix : ''
    sourceAddressPrefixes: contains(securityRule.properties, 'sourceAddressPrefixes') ? securityRule.properties.sourceAddressPrefixes : []
    destinationAddressPrefixes: contains(securityRule.properties, 'destinationAddressPrefixes') ? securityRule.properties.destinationAddressPrefixes : []
    sourceApplicationSecurityGroups: contains(securityRule.properties, 'sourceApplicationSecurityGroups') ? securityRule.properties.sourceApplicationSecurityGroups : []
    destinationApplicationSecurityGroups: contains(securityRule.properties, 'destinationApplicationSecurityGroups') ? securityRule.properties.destinationApplicationSecurityGroups : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

resource networkSecurityGroup_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${networkSecurityGroup.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: networkSecurityGroup
}

resource networkSecurityGroup_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: diagnosticSettingsName
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    logs: diagnosticsLogs
  }
  scope: networkSecurityGroup
}

module networkSecurityGroup_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-NSG-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: networkSecurityGroup.id
  }
}]

@description('The resource group the network security group was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the network security group.')
output resourceId string = networkSecurityGroup.id

@description('The name of the network security group.')
output name string = networkSecurityGroup.name

@description('The location the resource was deployed into.')
output location string = networkSecurityGroup.location
