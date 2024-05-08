@description('Required. The name of the action group.')
param name string

@description('Required. The short name of the action group.')
param groupShortName string

@description('Optional. Indicates whether this action group is enabled. If an action group is not enabled, then none of its receivers will receive communications.')
param enabled bool = true

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. The list of email receivers that are part of this action group.')
param emailReceivers array = []

@description('Optional. The list of SMS receivers that are part of this action group.')
param smsReceivers array = []

@description('Optional. The list of webhook receivers that are part of this action group.')
param webhookReceivers array = []

@description('Optional. The list of ITSM receivers that are part of this action group.')
param itsmReceivers array = []

@description('Optional. The list of AzureAppPush receivers that are part of this action group.')
param azureAppPushReceivers array = []

@description('Optional. The list of AutomationRunbook receivers that are part of this action group.')
param automationRunbookReceivers array = []

@description('Optional. The list of voice receivers that are part of this action group.')
param voiceReceivers array = []

@description('Optional. The list of logic app receivers that are part of this action group.')
param logicAppReceivers array = []

@description('Optional. The list of function receivers that are part of this action group.')
param azureFunctionReceivers array = []

@description('Optional. The list of ARM role receivers that are part of this action group. Roles are Azure RBAC roles and only built-in roles are supported.')
param armRoleReceivers array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Location for all resources.')
param location string = 'global'

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

resource actionGroup 'microsoft.insights/actionGroups@2019-06-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    groupShortName: groupShortName
    enabled: enabled
    emailReceivers: (empty(emailReceivers) ? null : emailReceivers)
    smsReceivers: (empty(smsReceivers) ? null : smsReceivers)
    webhookReceivers: (empty(webhookReceivers) ? null : webhookReceivers)
    itsmReceivers: (empty(itsmReceivers) ? null : itsmReceivers)
    azureAppPushReceivers: (empty(azureAppPushReceivers) ? null : azureAppPushReceivers)
    automationRunbookReceivers: (empty(automationRunbookReceivers) ? null : automationRunbookReceivers)
    voiceReceivers: (empty(voiceReceivers) ? null : voiceReceivers)
    logicAppReceivers: (empty(logicAppReceivers) ? null : logicAppReceivers)
    azureFunctionReceivers: (empty(azureFunctionReceivers) ? null : azureFunctionReceivers)
    armRoleReceivers: (empty(armRoleReceivers) ? null : armRoleReceivers)
  }
}

module actionGroup_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-ActionGroup-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: actionGroup.id
  }
}]

@description('The resource group the action group was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the action group .')
output name string = actionGroup.name

@description('The resource ID of the action group .')
output resourceId string = actionGroup.id

@description('The location the resource was deployed into.')
output location string = actionGroup.location
