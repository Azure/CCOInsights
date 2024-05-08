@description('Conditional. The name of the parent Private DNS zone. Required if the template is used in a standalone deployment.')
param privateDnsZoneName string

@description('Optional. The name of the virtual network link.')
param name string = '${last(split(virtualNetworkResourceId, '/'))}-vnetlink'

@description('Optional. The location of the PrivateDNSZone. Should be global.')
param location string = 'global'

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled?.')
param registrationEnabled bool = false

@description('Required. Link to another virtual network resource ID.')
param virtualNetworkResourceId string

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDnsZoneName
}

resource virtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: name
  parent: privateDnsZone
  location: location
  tags: tags
  properties: {
    registrationEnabled: registrationEnabled
    virtualNetwork: {
      id: virtualNetworkResourceId
    }
  }
}

@description('The name of the deployed virtual network link.')
output name string = virtualNetworkLink.name

@description('The resource ID of the deployed virtual network link.')
output resourceId string = virtualNetworkLink.id

@description('The resource group of the deployed virtual network link.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = virtualNetworkLink.location
