@description('Required. The connection name.')
param name string

@description('Conditional. The name of the parent virtual hub. Required if the template is used in a standalone deployment.')
param virtualHubName string

@description('Optional. Enable internet security.')
param enableInternetSecurity bool = true

@description('Required. Resource ID of the virtual network to link to.')
param remoteVirtualNetworkId string

@description('Optional. Routing Configuration indicating the associated and propagated route tables for this connection.')
param routingConfiguration object = {}

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

resource virtualHub 'Microsoft.Network/virtualHubs@2022-05-01' existing = {
  name: virtualHubName
}

resource hubVirtualNetworkConnection 'Microsoft.Network/virtualHubs/hubVirtualNetworkConnections@2022-05-01' = {
  name: name
  parent: virtualHub
  properties: {
    enableInternetSecurity: enableInternetSecurity
    remoteVirtualNetwork: {
      id: remoteVirtualNetworkId
    }
    routingConfiguration: !empty(routingConfiguration) ? routingConfiguration : null
  }
}

@description('The resource group the virtual hub connection was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the virtual hub connection.')
output resourceId string = hubVirtualNetworkConnection.id

@description('The name of the virtual hub connection.')
output name string = hubVirtualNetworkConnection.name
