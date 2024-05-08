@description('Conditional. The name of the parent load balancer. Required if the template is used in a standalone deployment.')
param loadBalancerName string

@description('Required. The name of the backend address pool.')
param name string

@description('Optional. An array of backend addresses.')
param loadBalancerBackendAddresses array = []

@description('Optional. An array of gateway load balancer tunnel interfaces.')
param tunnelInterfaces array = []

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

resource loadBalancer 'Microsoft.Network/loadBalancers@2021-08-01' existing = {
  name: loadBalancerName
}

resource backendAddressPool 'Microsoft.Network/loadBalancers/backendAddressPools@2021-08-01' = {
  name: name
  properties: {
    loadBalancerBackendAddresses: loadBalancerBackendAddresses
    tunnelInterfaces: tunnelInterfaces
  }
  parent: loadBalancer
}

@description('The name of the backend address pool.')
output name string = backendAddressPool.name

@description('The resource ID of the backend address pool.')
output resourceId string = backendAddressPool.id

@description('The resource group the backend address pool was deployed into.')
output resourceGroupName string = resourceGroup().name
