// ========== //
// Parameters //
// ========== //

@description('Required. The name of the storage account to create.')
@maxLength(24)
param storageAccountName string

@description('Required. The name of the log analytics workspace to create.')
param logAnalyticsWorkspaceName string

@description('Required. The name of the event hub namespace to create.')
param eventHubNamespaceName string

@description('Required. The name of the event hub to create inside the event hub namespace.')
param eventHubNamespaceEventHubName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

// ============ //
// Dependencies //
// ============ //

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    allowBlobPublicAccess: false
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: logAnalyticsWorkspaceName
  location: location
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' = {
  name: eventHubNamespaceName
  location: location

  resource eventHub 'eventhubs@2021-11-01' = {
    name: eventHubNamespaceEventHubName
  }

  resource authorizationRule 'authorizationRules@2021-06-01-preview' = {
    name: 'RootManageSharedAccessKey'
    properties: {
      rights: [
        'Listen'
        'Manage'
        'Send'
      ]
    }
  }
}

// ======= //
// Outputs //
// ======= //

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The resource ID of the created Log Analytics Workspace.')
output logAnalyticsWorkspaceResourceId string = logAnalyticsWorkspace.id

@description('The resource ID of the created Event Hub Namespace.')
output eventHubNamespaceResourceId string = eventHubNamespace.id

@description('The resource ID of the created Event Hub Namespace Authorization Rule.')
output eventHubAuthorizationRuleId string = eventHubNamespace::authorizationRule.id

@description('The name of the created Event Hub Namespace Event Hub.')
output eventHubNamespaceEventHubName string = eventHubNamespace::eventHub.name
