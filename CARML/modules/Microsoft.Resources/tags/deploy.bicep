targetScope = 'subscription'

@description('Optional. Tags for the resource group. If not provided, removes existing tags.')
param tags object = {}

@description('Optional. Instead of overwriting the existing tags, combine them with the new tags.')
param onlyUpdate bool = false

@description('Optional. Name of the Resource Group to assign the tags to. If no Resource Group name is provided, and Subscription ID is provided, the module deploys at subscription level, therefore assigns the provided tags to the subscription.')
param resourceGroupName string = ''

@description('Optional. Subscription ID of the subscription to assign the tags to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided tags to the subscription.')
param subscriptionId string = subscription().id

@sys.description('Optional. Location deployment metadata.')
param location string = deployment().location

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
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

module tags_sub 'subscriptions/deploy.bicep' = if (!empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${deployment().name}-Tags-Sub'
  params: {
    onlyUpdate: onlyUpdate
    tags: tags
    location: location
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module tags_rg 'resourceGroups/deploy.bicep' = if (!empty(resourceGroupName) && !empty(subscriptionId)) {
  name: '${deployment().name}-Tags-RG'
  scope: resourceGroup(resourceGroupName)
  params: {
    onlyUpdate: onlyUpdate
    tags: tags
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

@description('The name of the tags resource.')
output name string = (!empty(resourceGroupName) && !empty(subscriptionId)) ? tags_rg.outputs.name : tags_sub.outputs.name

@description('The applied tags.')
output tags object = (!empty(resourceGroupName) && !empty(subscriptionId)) ? tags_rg.outputs.tags : tags_sub.outputs.tags

@description('The resource ID of the applied tags.')
output resourceId string = (!empty(resourceGroupName) && !empty(subscriptionId)) ? tags_rg.outputs.resourceId : tags_sub.outputs.resourceId
