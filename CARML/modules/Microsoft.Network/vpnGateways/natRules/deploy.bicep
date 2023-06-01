@description('Required. The name of the NAT rule.')
param name string

@description('Conditional. The name of the parent VPN gateway this NAT rule is associated with. Required if the template is used in a standalone deployment.')
param vpnGatewayName string

@description('Optional. An address prefix range of destination IPs on the outside network that source IPs will be mapped to. In other words, your post-NAT address prefix range.')
param externalMappings array = []

@description('Optional. An address prefix range of source IPs on the inside network that will be mapped to a set of external IPs. In other words, your pre-NAT address prefix range.')
param internalMappings array = []

@description('Optional. A NAT rule must be configured to a specific VPN Gateway instance. This is applicable to Dynamic NAT only. Static NAT rules are automatically applied to both VPN Gateway instances.')
param ipConfigurationId string = ''

@description('Optional. The type of NAT rule for VPN NAT. IngressSnat mode (also known as Ingress Source NAT) is applicable to traffic entering the Azure hub\'s site-to-site VPN gateway. EgressSnat mode (also known as Egress Source NAT) is applicable to traffic leaving the Azure hub\'s Site-to-site VPN gateway.')
@allowed([
  ''
  'EgressSnat'
  'IngressSnat'
])
param mode string = ''

@description('Optional. The type of NAT rule for VPN NAT. Static one-to-one NAT establishes a one-to-one relationship between an internal address and an external address while Dynamic NAT assigns an IP and port based on availability.')
@allowed([
  ''
  'Dynamic'
  'Static'
])
param type string = ''

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

resource vpnGateway 'Microsoft.Network/vpnGateways@2021-08-01' existing = {
  name: vpnGatewayName
}

resource natRule 'Microsoft.Network/vpnGateways/natRules@2021-08-01' = {
  name: name
  parent: vpnGateway
  properties: {
    externalMappings: externalMappings
    internalMappings: internalMappings
    ipConfigurationId: !empty(ipConfigurationId) ? ipConfigurationId : null
    mode: !empty(mode) ? any(mode) : null
    type: !empty(type) ? any(type) : null
  }
}

@description('The name of the NAT rule.')
output name string = natRule.name

@description('The resource ID of the NAT rule.')
output resourceId string = natRule.id

@description('The name of the resource group the NAT rule was deployed into.')
output resourceGroupName string = resourceGroup().name
