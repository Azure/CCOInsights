targetScope = 'managementGroup'

@sys.description('Required. Name of the custom RBAC role to be created.')
param roleName string

@sys.description('Optional. Description of the custom RBAC role to be created.')
param description string = ''

@sys.description('Optional. List of allowed actions.')
param actions array = []

@sys.description('Optional. List of denied actions.')
param notActions array = []

@sys.description('Optional. List of allowed data actions. This is not supported if the assignableScopes contains Management Group Scopes.')
param dataActions array = []

@sys.description('Optional. List of denied data actions. This is not supported if the assignableScopes contains Management Group Scopes.')
param notDataActions array = []

@sys.description('Optional. The group ID of the Management Group where the Role Definition and Target Scope will be applied to. If not provided, will use the current scope for deployment.')
param managementGroupId string = managementGroup().name

@sys.description('Optional. The subscription ID where the Role Definition and Target Scope will be applied to. Use for both Subscription level and Resource Group Level.')
param subscriptionId string = ''

@sys.description('Optional. The name of the Resource Group where the Role Definition and Target Scope will be applied to.')
param resourceGroupName string = ''

@sys.description('Optional. Location deployment metadata.')
param location string = deployment().location

@sys.description('Optional. Role definition assignable scopes. If not provided, will use the current scope provided.')
param assignableScopes array = []

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

module roleDefinition_mg 'managementGroup/deploy.bicep' = if (empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${uniqueString(deployment().name, location)}-RoleDefinition-MG-Module'
  scope: managementGroup(managementGroupId)
  params: {
    roleName: roleName
    description: !empty(description) ? description : ''
    actions: !empty(actions) ? actions : []
    notActions: !empty(notActions) ? notActions : []
    assignableScopes: !empty(assignableScopes) ? assignableScopes : []
    managementGroupId: managementGroupId
    location: location
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module roleDefinition_sub 'subscription/deploy.bicep' = if (!empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${uniqueString(deployment().name, location)}-RoleDefinition-Sub-Module'
  scope: subscription(subscriptionId)
  params: {
    roleName: roleName
    description: !empty(description) ? description : ''
    actions: !empty(actions) ? actions : []
    notActions: !empty(notActions) ? notActions : []
    dataActions: !empty(dataActions) ? dataActions : []
    notDataActions: !empty(notDataActions) ? notDataActions : []
    assignableScopes: !empty(assignableScopes) ? assignableScopes : []
    subscriptionId: subscriptionId
    location: location
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module roleDefinition_rg 'resourceGroup/deploy.bicep' = if (!empty(resourceGroupName) && !empty(subscriptionId)) {
  name: '${uniqueString(deployment().name, location)}-RoleDefinition-RG-Module'
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    roleName: roleName
    description: !empty(description) ? description : ''
    actions: !empty(actions) ? actions : []
    notActions: !empty(notActions) ? notActions : []
    dataActions: !empty(dataActions) ? dataActions : []
    notDataActions: !empty(notDataActions) ? notDataActions : []
    assignableScopes: !empty(assignableScopes) ? assignableScopes : []
    subscriptionId: subscriptionId
    resourceGroupName: resourceGroupName
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

@sys.description('The GUID of the Role Definition.')
output name string = empty(subscriptionId) && empty(resourceGroupName) ? roleDefinition_mg.outputs.name : (!empty(subscriptionId) && empty(resourceGroupName) ? roleDefinition_sub.outputs.name : roleDefinition_rg.outputs.name)

@sys.description('The resource ID of the Role Definition.')
output resourceId string = empty(subscriptionId) && empty(resourceGroupName) ? roleDefinition_mg.outputs.resourceId : (!empty(subscriptionId) && empty(resourceGroupName) ? roleDefinition_sub.outputs.resourceId : roleDefinition_rg.outputs.resourceId)

@sys.description('The scope this Role Definition applies to.')
output scope string = empty(subscriptionId) && empty(resourceGroupName) ? roleDefinition_mg.outputs.scope : (!empty(subscriptionId) && empty(resourceGroupName) ? roleDefinition_sub.outputs.scope : roleDefinition_rg.outputs.scope)
