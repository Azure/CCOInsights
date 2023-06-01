@description('Conditional. The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment.')
param logAnalyticsWorkspaceName string

@description('Required. Name of the link.')
param name string

@description('Required. The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require read access.')
param resourceId string = ''

@description('Optional. The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require write access.')
param writeAccessResourceId string = ''

@description('Optional. Tags to configure in the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

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

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource linkedService 'Microsoft.OperationalInsights/workspaces/linkedServices@2020-08-01' = {
  name: name
  parent: workspace
  tags: tags
  properties: {
    resourceId: resourceId
    writeAccessResourceId: empty(writeAccessResourceId) ? null : writeAccessResourceId
  }
}

@description('The name of the deployed linked service.')
output name string = linkedService.name

@description('The resource ID of the deployed linked service.')
output resourceId string = linkedService.id

@description('The resource group where the linked service is deployed.')
output resourceGroupName string = resourceGroup().name
