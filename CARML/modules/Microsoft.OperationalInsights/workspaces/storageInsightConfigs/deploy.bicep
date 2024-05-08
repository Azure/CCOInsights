@description('Conditional. The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment.')
param logAnalyticsWorkspaceName string

@description('Optional. The name of the storage insights config.')
param name string = '${last(split(storageAccountId, '/'))}-stinsconfig'

@description('Required. The Azure Resource Manager ID of the storage account resource.')
param storageAccountId string

@description('Optional. The names of the blob containers that the workspace should read.')
param containers array = []

@description('Optional. The names of the Azure tables that the workspace should read.')
param tables array = []

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

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: last(split(storageAccountId, '/'))
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource storageinsightconfig 'Microsoft.OperationalInsights/workspaces/storageInsightConfigs@2020-08-01' = {
  name: name
  parent: workspace
  tags: tags
  properties: {
    containers: containers
    tables: tables
    storageAccount: {
      id: storageAccountId
      key: storageAccount.listKeys().keys[0].value
    }
  }
}

@description('The resource ID of the deployed storage insights configuration.')
output resourceId string = storageinsightconfig.id

@description('The resource group where the storage insight configuration is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The name of the storage insights configuration.')
output name string = storageinsightconfig.name
