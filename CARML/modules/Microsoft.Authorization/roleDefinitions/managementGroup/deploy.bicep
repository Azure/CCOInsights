targetScope = 'managementGroup'

@sys.description('Required. Name of the custom RBAC role to be created.')
param roleName string

@sys.description('Optional. Description of the custom RBAC role to be created.')
param description string = ''

@sys.description('Optional. List of allowed actions.')
param actions array = []

@sys.description('Optional. List of denied actions.')
param notActions array = []

@sys.description('Optional. The group ID of the Management Group where the Role Definition and Target Scope will be applied to. If not provided, will use the current scope for deployment.')
param managementGroupId string = managementGroup().name

@sys.description('Optional. Role definition assignable scopes. If not provided, will use the current scope provided.')
param assignableScopes array = []

@sys.description('Optional. Location deployment metadata.')
param location string = deployment().location

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

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

resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(roleName, managementGroupId)
  properties: {
    roleName: roleName
    description: description
    type: 'customRole'
    permissions: [
      {
        actions: actions
        notActions: notActions
      }
    ]
    assignableScopes: assignableScopes == [] ? array(tenantResourceId('Microsoft.Management/managementGroups', managementGroupId)) : assignableScopes
  }
}

@sys.description('The GUID of the Role Definition.')
output name string = roleDefinition.name

@sys.description('The scope this Role Definition applies to.')
output scope string = managementGroup().id

@sys.description('The resource ID of the Role Definition.')
output resourceId string = roleDefinition.id
