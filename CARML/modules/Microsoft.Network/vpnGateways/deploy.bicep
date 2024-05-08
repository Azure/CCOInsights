@description('Required. Name of the VPN gateway.')
param name string

@description('Optional. Location where all resources will be created.')
param location string = resourceGroup().location

@description('Optional. The connections to create in the VPN gateway.')
param connections array = []

@description('Optional. List of all the NAT Rules to associate with the gateway.')
param natRules array = []

@description('Required. The resource ID of a virtual Hub to connect to. Note: The virtual Hub and Gateway must be deployed into the same location.')
param virtualHubResourceId string

@description('Optional. BGP settings details.')
param bgpSettings object = {}

@description('Optional. Enable BGP routes translation for NAT on this VPN gateway.')
param enableBgpRouteTranslationForNat bool = false

@description('Optional. Enable routing preference property for the public IP interface of the VPN gateway.')
param isRoutingPreferenceInternet bool = false

@description('Optional. The scale unit for this VPN gateway.')
param vpnGatewayScaleUnit int = 2

@description('Optional. Tags of the resource.')
param tags object = {}

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

resource vpnGateway 'Microsoft.Network/vpnGateways@2021-08-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    bgpSettings: bgpSettings
    enableBgpRouteTranslationForNat: enableBgpRouteTranslationForNat
    isRoutingPreferenceInternet: isRoutingPreferenceInternet
    vpnGatewayScaleUnit: vpnGatewayScaleUnit
    virtualHub: {
      id: virtualHubResourceId
    }
  }
}

resource vpnGateway_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${vpnGateway.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: vpnGateway
}

module vpnGateway_natRules 'natRules/deploy.bicep' = [for (natRule, index) in natRules: {
  name: '${deployment().name}-NATRule-${index}'
  params: {
    name: natRule.name
    vpnGatewayName: vpnGateway.name
    externalMappings: contains(natRule, 'externalMappings') ? natRule.externalMappings : []
    internalMappings: contains(natRule, 'internalMappings') ? natRule.internalMappings : []
    ipConfigurationId: contains(natRule, 'ipConfigurationId') ? natRule.ipConfigurationId : ''
    mode: contains(natRule, 'mode') ? natRule.mode : ''
    type: contains(natRule, 'type') ? natRule.type : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module vpnGateway_connections 'connections/deploy.bicep' = [for (connection, index) in connections: {
  name: '${deployment().name}-Connection-${index}'
  params: {
    name: connection.name
    vpnGatewayName: vpnGateway.name
    connectionBandwidth: contains(connection, 'connectionBandwidth') ? connection.connectionBandwidth : 10
    enableBgp: contains(connection, 'enableBgp') ? connection.enableBgp : false
    enableInternetSecurity: contains(connection, 'enableInternetSecurity') ? connection.enableInternetSecurity : false
    remoteVpnSiteResourceId: contains(connection, 'remoteVpnSiteResourceId') ? connection.remoteVpnSiteResourceId : ''
    enableRateLimiting: contains(connection, 'enableRateLimiting') ? connection.enableRateLimiting : false
    routingConfiguration: contains(connection, 'routingConfiguration') ? connection.routingConfiguration : {}
    routingWeight: contains(connection, 'routingWeight') ? connection.routingWeight : 0
    sharedKey: contains(connection, 'sharedKey') ? connection.sharedKey : ''
    useLocalAzureIpAddress: contains(connection, 'useLocalAzureIpAddress') ? connection.useLocalAzureIpAddress : false
    usePolicyBasedTrafficSelectors: contains(connection, 'usePolicyBasedTrafficSelectors') ? connection.usePolicyBasedTrafficSelectors : false
    vpnConnectionProtocolType: contains(connection, 'vpnConnectionProtocolType') ? connection.vpnConnectionProtocolType : 'IKEv2'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

@description('The name of the VPN gateway.')
output name string = vpnGateway.name

@description('The resource ID of the VPN gateway.')
output resourceId string = vpnGateway.id

@description('The name of the resource group the VPN gateway was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = vpnGateway.location
