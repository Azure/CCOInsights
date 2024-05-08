@maxLength(24)
@description('Conditional. The name of the parent Storage Account. Required if the template is used in a standalone deployment.')
param storageAccountName string

@description('Conditional. The name of the parent blob service. Required if the template is used in a standalone deployment.')
param blobServicesName string = 'default'

@description('Conditional. The name of the parent container to apply the policy to. Required if the template is used in a standalone deployment.')
param containerName string

@description('Optional. Name of the immutable policy.')
param name string = 'default'

@description('Optional. The immutability period for the blobs in the container since the policy creation, in days.')
param immutabilityPeriodSinceCreationInDays int = 365

@description('Optional. This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API.')
param allowProtectedAppendWrites bool = true

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

  resource blobServices 'blobServices@2021-09-01' existing = {
    name: blobServicesName

    resource container 'containers@2021-09-01' existing = {
      name: containerName
    }
  }
}

resource immutabilityPolicy 'Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies@2021-09-01' = {
  name: name
  parent: storageAccount::blobServices::container
  properties: {
    immutabilityPeriodSinceCreationInDays: immutabilityPeriodSinceCreationInDays
    allowProtectedAppendWrites: allowProtectedAppendWrites
  }
}

@description('The name of the deployed immutability policy.')
output name string = immutabilityPolicy.name

@description('The resource ID of the deployed immutability policy.')
output resourceId string = immutabilityPolicy.id

@description('The resource group of the deployed immutability policy.')
output resourceGroupName string = resourceGroup().name
