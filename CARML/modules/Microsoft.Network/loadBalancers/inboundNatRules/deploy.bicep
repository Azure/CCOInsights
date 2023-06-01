@description('Conditional. The name of the parent load balancer. Required if the template is used in a standalone deployment.')
param loadBalancerName string

@description('Required. The name of the inbound NAT rule.')
param name string

@description('Required. The port for the external endpoint. Port numbers for each rule must be unique within the Load Balancer.')
@minValue(1)
@maxValue(65534)
param frontendPort int

@description('Optional. The port used for the internal endpoint.')
@minValue(1)
@maxValue(65535)
param backendPort int = frontendPort

@description('Optional. Name of the backend address pool.')
param backendAddressPoolName string = ''

@description('Optional. Configures a virtual machine\'s endpoint for the floating IP capability required to configure a SQL AlwaysOn Availability Group. This setting is required when using the SQL AlwaysOn Availability Groups in SQL server. This setting can\'t be changed after you create the endpoint.')
param enableFloatingIP bool = false

@description('Optional. Receive bidirectional TCP Reset on TCP flow idle timeout or unexpected connection termination. This element is only used when the protocol is set to TCP.')
param enableTcpReset bool = false

@description('Required. The name of the frontend IP address to set for the inbound NAT rule.')
param frontendIPConfigurationName string

@description('Optional. The port range end for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeStart. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool.')
@minValue(-1)
@maxValue(65534)
param frontendPortRangeEnd int = -1

@description('Optional. The port range start for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeEnd. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool.')
@minValue(-1)
@maxValue(65534)
param frontendPortRangeStart int = -1

@description('Optional. The timeout for the TCP idle connection. The value can be set between 4 and 30 minutes. The default value is 4 minutes. This element is only used when the protocol is set to TCP.')
param idleTimeoutInMinutes int = 4

@description('Optional. The transport protocol for the endpoint.')
@allowed([
  'All'
  'Tcp'
  'Udp'
])
param protocol string = 'Tcp'

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

resource inboundNatRule 'Microsoft.Network/loadBalancers/inboundNatRules@2021-08-01' = {
  name: name
  properties: {
    frontendPort: frontendPort
    backendPort: backendPort
    backendAddressPool: !empty(backendAddressPoolName) ? {
      id: '${loadBalancer.id}/backendAddressPools/${backendAddressPoolName}'
    } : null
    enableFloatingIP: enableFloatingIP
    enableTcpReset: enableTcpReset
    frontendIPConfiguration: {
      id: '${loadBalancer.id}/frontendIPConfigurations/${frontendIPConfigurationName}'
    }
    frontendPortRangeStart: frontendPortRangeStart != -1 ? frontendPortRangeStart : null
    frontendPortRangeEnd: frontendPortRangeEnd != -1 ? frontendPortRangeEnd : null
    idleTimeoutInMinutes: idleTimeoutInMinutes
    protocol: protocol
  }
  parent: loadBalancer
}

@description('The name of the inbound NAT rule.')
output name string = inboundNatRule.name

@description('The resource ID of the inbound NAT rule.')
output resourceId string = inboundNatRule.id

@description('The resource group the inbound NAT rule was deployed into.')
output resourceGroupName string = resourceGroup().name
