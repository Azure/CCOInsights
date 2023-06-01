@maxLength(24)
@description('Conditional. The name of the parent Storage Account. Required if the template is used in a standalone deployment.')
param storageAccountName string

@description('Optional. The name of the storage container to deploy.')
param name string = 'default'

@description('Required. The Storage Account ManagementPolicies Rules.')
param rules array

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

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storageAccountName
}

// lifecycle policy
resource managementPolicy 'Microsoft.Storage/storageAccounts/managementPolicies@2021-09-01' = if (!empty(rules)) {
  name: name
  parent: storageAccount
  properties: {
    policy: {
      rules: rules
    }
  }
}

@description('The resource ID of the deployed management policy.')
output resourceId string = managementPolicy.name

@description('The name of the deployed management policy.')
output name string = managementPolicy.name

@description('The resource group of the deployed management policy.')
output resourceGroupName string = resourceGroup().name
