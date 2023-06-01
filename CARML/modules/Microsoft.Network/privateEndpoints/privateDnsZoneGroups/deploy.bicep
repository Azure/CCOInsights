@description('Conditional. The name of the parent private endpoint. Required if the template is used in a standalone deployment.')
param privateEndpointName string

@description('Required. Array of private DNS zone resource IDs. A DNS zone group can support up to 5 DNS zones.')
@minLength(1)
@maxLength(5)
param privateDNSResourceIds array

@description('Optional. The name of the private DNS zone group.')
param name string = 'default'

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

var privateDnsZoneConfigs = [for privateDNSResourceId in privateDNSResourceIds: {
  name: last(split(privateDNSResourceId, '/'))
  properties: {
    privateDnsZoneId: privateDNSResourceId
  }
}]

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-05-01' existing = {
  name: privateEndpointName
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-05-01' = {
  name: name
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: privateDnsZoneConfigs
  }
}

@description('The name of the private endpoint DNS zone group.')
output name string = privateDnsZoneGroup.name

@description('The resource ID of the private endpoint DNS zone group.')
output resourceId string = privateDnsZoneGroup.id

@description('The resource group the private endpoint DNS zone group was deployed into.')
output resourceGroupName string = resourceGroup().name
