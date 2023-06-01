@description('Required. The virtual hub name.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Required. Address-prefix for this VirtualHub.')
param addressPrefix string

@description('Optional. Flag to control transit for VirtualRouter hub.')
param allowBranchToBranchTraffic bool = true

@description('Optional. Resource ID of the Express Route Gateway to link to.')
param expressRouteGatewayId string = ''

@description('Optional. Resource ID of the Point-to-Site VPN Gateway to link to.')
param p2SVpnGatewayId string = ''

@description('Optional. The preferred routing gateway types.')
@allowed([
  'ExpressRoute'
  'None'
  'VpnGateway'
  ''
])
param preferredRoutingGateway string = ''

@description('Optional. VirtualHub route tables.')
param routeTableRoutes array = []

@description('Optional. ID of the Security Partner Provider to link to.')
param securityPartnerProviderId string = ''

@description('Optional. The Security Provider name.')
param securityProviderName string = ''

@allowed([
  'Basic'
  'Standard'
])
@description('Optional. The sku of this VirtualHub.')
param sku string = 'Standard'

@description('Optional. List of all virtual hub route table v2s associated with this VirtualHub.')
param virtualHubRouteTableV2s array = []

@description('Optional. VirtualRouter ASN.')
param virtualRouterAsn int = -1

@description('Optional. VirtualRouter IPs.')
param virtualRouterIps array = []

@description('Required. Resource ID of the virtual WAN to link to.')
param virtualWanId string

@description('Optional. Resource ID of the VPN Gateway to link to.')
param vpnGatewayId string = ''

@description('Optional. Route tables to create for the virtual hub.')
param hubRouteTables array = []

@description('Optional. Virtual network connections to create for the virtual hub.')
param hubVirtualNetworkConnections array = []

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

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

resource virtualHub 'Microsoft.Network/virtualHubs@2022-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressPrefix: addressPrefix
    allowBranchToBranchTraffic: allowBranchToBranchTraffic
    expressRouteGateway: !empty(expressRouteGatewayId) ? {
      id: expressRouteGatewayId
    } : null
    p2SVpnGateway: !empty(p2SVpnGatewayId) ? {
      id: p2SVpnGatewayId
    } : null
    preferredRoutingGateway: !empty(preferredRoutingGateway) ? any(preferredRoutingGateway) : null
    routeTable: !empty(routeTableRoutes) ? {
      routes: routeTableRoutes
    } : null
    securityPartnerProvider: !empty(securityPartnerProviderId) ? {
      id: securityPartnerProviderId
    } : null
    securityProviderName: securityProviderName
    sku: sku
    virtualHubRouteTableV2s: virtualHubRouteTableV2s
    virtualRouterAsn: virtualRouterAsn != -1 ? virtualRouterAsn : null
    virtualRouterIps: !empty(virtualRouterIps) ? virtualRouterIps : null
    virtualWan: {
      id: virtualWanId
    }
    vpnGateway: !empty(vpnGatewayId) ? {
      id: vpnGatewayId
    } : null
  }
}

resource virtualHub_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${virtualHub.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: virtualHub
}

module virtualHub_routeTables 'hubRouteTables/deploy.bicep' = [for (routeTable, index) in hubRouteTables: {
  name: '${uniqueString(deployment().name, location)}-routeTable-${index}'
  params: {
    virtualHubName: virtualHub.name
    name: routeTable.name
    labels: contains(routeTable, 'labels') ? routeTable.labels : []
    routes: contains(routeTable, 'routes') ? routeTable.routes : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module virtualHub_hubVirtualNetworkConnections 'hubVirtualNetworkConnections/deploy.bicep' = [for (virtualNetworkConnection, index) in hubVirtualNetworkConnections: {
  name: '${uniqueString(deployment().name, location)}-connection-${index}'
  params: {
    virtualHubName: virtualHub.name
    name: virtualNetworkConnection.name
    enableInternetSecurity: contains(virtualNetworkConnection, 'enableInternetSecurity') ? virtualNetworkConnection.enableInternetSecurity : true
    remoteVirtualNetworkId: virtualNetworkConnection.remoteVirtualNetworkId
    routingConfiguration: contains(virtualNetworkConnection, 'routingConfiguration') ? virtualNetworkConnection.routingConfiguration : {}
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    virtualHub_routeTables
  ]
}]

@description('The resource group the virtual hub was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the virtual hub.')
output resourceId string = virtualHub.id

@description('The name of the virtual hub.')
output name string = virtualHub.name

@description('The location the resource was deployed into.')
output location string = virtualHub.location
