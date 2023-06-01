@description('Conditional. The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment.')
param logAnalyticsWorkspaceName string

@description('Required. Name of the link.')
@allowed([
  'Query'
  'Alerts'
  'CustomLogs'
  'AzureWatson'
])
param name string

@description('Required. The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require read access.')
param resourceId string

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

resource linkedStorageAccount 'Microsoft.OperationalInsights/workspaces/linkedStorageAccounts@2020-08-01' = {
  name: name
  parent: workspace
  properties: {
    storageAccountIds: [
      resourceId
    ]
  }
}

@description('The name of the deployed linked storage account.')
output name string = linkedStorageAccount.name

@description('The resource ID of the deployed linked storage account.')
output resourceId string = linkedStorageAccount.id

@description('The resource group where the linked storage account is deployed.')
output resourceGroupName string = resourceGroup().name
