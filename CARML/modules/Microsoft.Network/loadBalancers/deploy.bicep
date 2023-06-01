@description('Required. The Proximity Placement Groups Name.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Name of a load balancer SKU.')
@allowed([
  'Basic'
  'Standard'
])
param loadBalancerSku string = 'Standard'

@description('Required. Array of objects containing all frontend IP configurations.')
@minLength(1)
param frontendIPConfigurations array

@description('Optional. Collection of backend address pools used by a load balancer.')
param backendAddressPools array = []

@description('Optional. Array of objects containing all load balancing rules.')
param loadBalancingRules array = []

@description('Optional. Array of objects containing all probes, these are references in the load balancing rules.')
param probes array = []

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Collection of inbound NAT Rules used by a load balancer. Defining inbound NAT rules on your load balancer is mutually exclusive with defining an inbound NAT pool. Inbound NAT pools are referenced from virtual machine scale sets. NICs that are associated with individual virtual machines cannot reference an Inbound NAT pool. They have to reference individual inbound NAT rules.')
param inboundNatRules array = []

@description('Optional. The outbound rules.')
param outboundRules array = []

var frontendIPConfigurationsVar = [for (frontendIPConfiguration, index) in frontendIPConfigurations: {
  name: frontendIPConfiguration.name
  properties: {
    subnet: contains(frontendIPConfiguration, 'subnetId') && !empty(frontendIPConfiguration.subnetId) ? {
      id: frontendIPConfiguration.subnetId
    } : null
    publicIPAddress: contains(frontendIPConfiguration, 'publicIPAddressId') && !empty(frontendIPConfiguration.publicIPAddressId) ? {
      id: frontendIPConfiguration.publicIPAddressId
    } : null
    privateIPAddress: contains(frontendIPConfiguration, 'privateIPAddress') && !empty(frontendIPConfiguration.privateIPAddress) ? frontendIPConfiguration.privateIPAddress : null
    privateIPAddressVersion: contains(frontendIPConfiguration, 'privateIPAddressVersion') ? frontendIPConfiguration.privateIPAddressVersion : 'IPv4'
    privateIPAllocationMethod: contains(frontendIPConfiguration, 'subnetId') && !empty(frontendIPConfiguration.subnetId) ? (contains(frontendIPConfiguration, 'privateIPAddress') ? 'Static' : 'Dynamic') : null
    gatewayLoadBalancer: contains(frontendIPConfiguration, 'gatewayLoadBalancer') && !empty(frontendIPConfiguration.gatewayLoadBalancer) ? {
      id: frontendIPConfiguration.gatewayLoadBalancer
    } : null
    publicIPPrefix: contains(frontendIPConfiguration, 'publicIPPrefix') && !empty(frontendIPConfiguration.publicIPPrefix) ? {
      id: frontendIPConfiguration.publicIPPrefix
    } : null
  }
}]

var loadBalancingRulesVar = [for loadBalancingRule in loadBalancingRules: {
  name: loadBalancingRule.name
  properties: {
    backendAddressPool: {
      id: az.resourceId('Microsoft.Network/loadBalancers/backendAddressPools', name, loadBalancingRule.backendAddressPoolName)
    }
    backendPort: loadBalancingRule.backendPort
    disableOutboundSnat: contains(loadBalancingRule, 'disableOutboundSnat') ? loadBalancingRule.disableOutboundSnat : true
    enableFloatingIP: contains(loadBalancingRule, 'enableFloatingIP') ? loadBalancingRule.enableFloatingIP : false
    enableTcpReset: contains(loadBalancingRule, 'enableTcpReset') ? loadBalancingRule.enableTcpReset : false
    frontendIPConfiguration: {
      id: az.resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', name, loadBalancingRule.frontendIPConfigurationName)
    }
    frontendPort: loadBalancingRule.frontendPort
    idleTimeoutInMinutes: contains(loadBalancingRule, 'idleTimeoutInMinutes') ? loadBalancingRule.idleTimeoutInMinutes : 4
    loadDistribution: contains(loadBalancingRule, 'loadDistribution') ? loadBalancingRule.loadDistribution : 'Default'
    probe: {
      id: '${az.resourceId('Microsoft.Network/loadBalancers', name)}/probes/${loadBalancingRule.probeName}'
    }
    protocol: contains(loadBalancingRule, 'protocol') ? loadBalancingRule.protocol : 'Tcp'
  }
}]

var outboundRulesVar = [for outboundRule in outboundRules: {
  name: outboundRule.name
  properties: {
    frontendIPConfigurations: [
      {
        id: az.resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', name, outboundRule.frontendIPConfigurationName)
      }
    ]
    backendAddressPool: {
      id: az.resourceId('Microsoft.Network/loadBalancers/backendAddressPools', name, outboundRule.backendAddressPoolName)
    }
    protocol: contains(outboundRule, 'protocol') ? outboundRule.protocol : 'All'
    allocatedOutboundPorts: contains(outboundRule, 'allocatedOutboundPorts') ? outboundRule.allocatedOutboundPorts : 63984
    enableTcpReset: contains(outboundRule, 'enableTcpReset') ? outboundRule.enableTcpReset : true
    idleTimeoutInMinutes: contains(outboundRule, 'idleTimeoutInMinutes') ? outboundRule.idleTimeoutInMinutes : 4
  }
}]

var probesVar = [for probe in probes: {
  name: probe.name
  properties: {
    protocol: contains(probe, 'protocol') ? probe.protocol : 'Tcp'
    requestPath: toLower(probe.protocol) != 'tcp' ? probe.requestPath : null
    port: contains(probe, 'port') ? probe.port : 80
    intervalInSeconds: contains(probe, 'intervalInSeconds') ? probe.intervalInSeconds : 5
    numberOfProbes: contains(probe, 'numberOfProbes') ? probe.numberOfProbes : 2
  }
}]

var backendAddressPoolNames = [for backendAddressPool in backendAddressPools: {
  name: backendAddressPool.name
}]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsName string = '${name}-diagnosticSettings'

var enableReferencedModulesTelemetry = false

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

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

resource loadBalancer 'Microsoft.Network/loadBalancers@2021-08-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: loadBalancerSku
  }
  properties: {
    frontendIPConfigurations: frontendIPConfigurationsVar
    loadBalancingRules: loadBalancingRulesVar
    backendAddressPools: backendAddressPoolNames
    outboundRules: outboundRulesVar
    probes: probesVar
  }
}

module loadBalancer_backendAddressPools 'backendAddressPools/deploy.bicep' = [for (backendAddressPool, index) in backendAddressPools: {
  name: '${uniqueString(deployment().name, location)}-loadBalancer-backendAddressPools-${index}'
  params: {
    loadBalancerName: loadBalancer.name
    name: backendAddressPool.name
    tunnelInterfaces: contains(backendAddressPool, 'tunnelInterfaces') && !empty(backendAddressPool.tunnelInterfaces) ? backendAddressPool.tunnelInterfaces : []
    loadBalancerBackendAddresses: contains(backendAddressPool, 'loadBalancerBackendAddresses') && !empty(backendAddressPool.loadBalancerBackendAddresses) ? backendAddressPool.loadBalancerBackendAddresses : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module loadBalancer_inboundNATRules 'inboundNatRules/deploy.bicep' = [for (inboundNATRule, index) in inboundNatRules: {
  name: '${uniqueString(deployment().name, location)}-LoadBalancer-inboundNatRules-${index}'
  params: {
    loadBalancerName: loadBalancer.name
    name: inboundNATRule.name
    frontendIPConfigurationName: inboundNATRule.frontendIPConfigurationName
    frontendPort: inboundNATRule.frontendPort
    backendPort: contains(inboundNATRule, 'backendPort') ? inboundNATRule.backendPort : inboundNATRule.frontendPort
    backendAddressPoolName: contains(inboundNATRule, 'backendAddressPoolName') ? inboundNATRule.backendAddressPoolName : ''
    enableFloatingIP: contains(inboundNATRule, 'enableFloatingIP') ? inboundNATRule.enableFloatingIP : false
    enableTcpReset: contains(inboundNATRule, 'enableTcpReset') ? inboundNATRule.enableTcpReset : false
    frontendPortRangeEnd: contains(inboundNATRule, 'frontendPortRangeEnd') ? inboundNATRule.frontendPortRangeEnd : -1
    frontendPortRangeStart: contains(inboundNATRule, 'frontendPortRangeStart') ? inboundNATRule.frontendPortRangeStart : -1
    idleTimeoutInMinutes: contains(inboundNATRule, 'idleTimeoutInMinutes') ? inboundNATRule.idleTimeoutInMinutes : 4
    protocol: contains(inboundNATRule, 'protocol') ? inboundNATRule.protocol : 'Tcp'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    loadBalancer_backendAddressPools
  ]
}]

resource loadBalancer_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${loadBalancer.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: loadBalancer
}

resource loadBalancer_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: diagnosticSettingsName
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
  }
  scope: loadBalancer
}

module loadBalancer_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-LoadBalancer-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: loadBalancer.id
  }
}]

@description('The name of the load balancer.')
output name string = loadBalancer.name

@description('The resource ID of the load balancer.')
output resourceId string = loadBalancer.id

@description('The resource group the load balancer was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The backend address pools available in the load balancer.')
output backendpools array = loadBalancer.properties.backendAddressPools

@description('The location the resource was deployed into.')
output location string = loadBalancer.location
