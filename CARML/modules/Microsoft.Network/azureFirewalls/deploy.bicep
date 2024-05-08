@description('Required. Name of the Azure Firewall.')
param name string

@description('Optional. Tier of an Azure Firewall.')
@allowed([
  'Standard'
  'Premium'
])
param azureSkuTier string = 'Standard'

@description('Conditional. Shared services Virtual Network resource ID. The virtual network ID containing AzureFirewallSubnet. If a public ip is not provided, then the public ip that is created as part of this module will be applied with the subnet provided in this variable. Required if `virtualHubId` is empty.')
param vNetId string = ''

@description('Optional. The public ip resource ID to associate to the AzureFirewallSubnet. If empty, then the public ip that is created as part of this module will be applied to the AzureFirewallSubnet.')
param azureFirewallSubnetPublicIpId string = ''

@description('Optional. This is to add any additional public ip configurations on top of the public ip with subnet ip configuration.')
param additionalPublicIpConfigurations array = []

@description('Optional. Specifies if a public ip should be created by default if one is not provided.')
param isCreateDefaultPublicIP bool = true

@description('Optional. Specifies the properties of the public IP to create and be used by Azure Firewall. If it\'s not provided and publicIPAddressId is empty, a \'-pip\' suffix will be appended to the Firewall\'s name.')
param publicIPAddressObject object = {}

@description('Optional. Collection of application rule collections used by Azure Firewall.')
param applicationRuleCollections array = []

@description('Optional. Collection of network rule collections used by Azure Firewall.')
param networkRuleCollections array = []

@description('Optional. Collection of NAT rule collections used by Azure Firewall.')
param natRuleCollections array = []

@description('Optional. Resource ID of the Firewall Policy that should be attached.')
param firewallPolicyId string = ''

@description('Conditional. IP addresses associated with AzureFirewall. Required if `virtualHubId` is supplied.')
param hubIPAddresses object = {}

@description('Conditional. The virtualHub resource ID to which the firewall belongs. Required if `vNetId` is empty.')
param virtualHubId string = ''

@allowed([
  'Alert'
  'Deny'
  'Off'
])
@description('Optional. The operation mode for Threat Intel.')
param threatIntelMode string = 'Deny'

@description('Optional. Zone numbers e.g. 1,2,3.')
param zones array = [
  '1'
  '2'
  '3'
]

@description('Optional. Diagnostic Storage Account resource identifier.')
param diagnosticStorageAccountId string = ''

@description('Optional. Log Analytics workspace resource identifier.')
param diagnosticWorkspaceId string = ''

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the Azure Firewall resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'AzureFirewallApplicationRule'
  'AzureFirewallNetworkRule'
  'AzureFirewallDnsProxy'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsName string = '${name}-diagnosticSettings'

var additionalPublicIpConfigurationsVar = [for ipConfiguration in additionalPublicIpConfigurations: {
  name: ipConfiguration.name
  properties: {
    publicIPAddress: contains(ipConfiguration, 'publicIPAddressResourceId') ? {
      id: ipConfiguration.publicIPAddressResourceId
    } : null
  }
}]

// ----------------------------------------------------------------------------
// Prep ipConfigurations object AzureFirewallSubnet for different uses cases:
// 1. Use existing public ip
// 2. Use new public ip created in this module
// 3. Do not use a public ip if isCreateDefaultPublicIP is false

var subnetVar = {
  subnet: {
    id: '${vNetId}/subnets/AzureFirewallSubnet' // The subnet name must be AzureFirewallSubnet
  }
}
var existingPip = {
  publicIPAddress: {
    id: azureFirewallSubnetPublicIpId
  }
}
var newPip = {
  publicIPAddress: (empty(azureFirewallSubnetPublicIpId) && isCreateDefaultPublicIP) ? {
    id: publicIPAddress.outputs.resourceId
  } : null
}

var azureSkuName = empty(vNetId) ? 'AZFW_Hub' : 'AZFW_VNet'

var ipConfigurations = concat([
    {
      name: !empty(azureFirewallSubnetPublicIpId) ? last(split(azureFirewallSubnetPublicIpId, '/')) : publicIPAddress.outputs.name
      //Use existing public ip, new public ip created in this module, or none if isCreateDefaultPublicIP is false
      properties: union(subnetVar, !empty(azureFirewallSubnetPublicIpId) ? existingPip : {}, (isCreateDefaultPublicIP ? newPip : {}))
    }
  ], additionalPublicIpConfigurationsVar)

// ----------------------------------------------------------------------------

var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs'): {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
] : diagnosticsLogsSpecified

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

// create a public ip address if one is not provided and the flag is true
module publicIPAddress '../../Microsoft.Network/publicIPAddresses/deploy.bicep' = if (empty(azureFirewallSubnetPublicIpId) && isCreateDefaultPublicIP && azureSkuName == 'AZFW_VNet') {
  name: '${uniqueString(deployment().name, location)}-Firewall-PIP'
  params: {
    name: contains(publicIPAddressObject, 'name') ? (!(empty(publicIPAddressObject.name)) ? publicIPAddressObject.name : '${name}-pip') : '${name}-pip'
    publicIPPrefixResourceId: contains(publicIPAddressObject, 'publicIPPrefixResourceId') ? (!(empty(publicIPAddressObject.publicIPPrefixResourceId)) ? publicIPAddressObject.publicIPPrefixResourceId : '') : ''
    publicIPAllocationMethod: contains(publicIPAddressObject, 'publicIPAllocationMethod') ? (!(empty(publicIPAddressObject.publicIPAllocationMethod)) ? publicIPAddressObject.publicIPAllocationMethod : 'Static') : 'Static'
    skuName: contains(publicIPAddressObject, 'skuName') ? (!(empty(publicIPAddressObject.skuName)) ? publicIPAddressObject.skuName : 'Standard') : 'Standard'
    skuTier: contains(publicIPAddressObject, 'skuTier') ? (!(empty(publicIPAddressObject.skuTier)) ? publicIPAddressObject.skuTier : 'Regional') : 'Regional'
    roleAssignments: contains(publicIPAddressObject, 'roleAssignments') ? (!empty(publicIPAddressObject.roleAssignments) ? publicIPAddressObject.roleAssignments : []) : []
    diagnosticMetricsToEnable: contains(publicIPAddressObject, 'diagnosticMetricsToEnable') ? (!(empty(publicIPAddressObject.diagnosticMetricsToEnable)) ? publicIPAddressObject.diagnosticMetricsToEnable : [
      'AllMetrics'
    ]) : [
      'AllMetrics'
    ]
    diagnosticLogCategoriesToEnable: contains(publicIPAddressObject, 'diagnosticLogCategoriesToEnable') ? (!(empty(publicIPAddressObject.diagnosticLogCategoriesToEnable)) ? publicIPAddressObject.diagnosticLogCategoriesToEnable : [
      'DDoSProtectionNotifications'
      'DDoSMitigationFlowLogs'
      'DDoSMitigationReports'
    ]) : [
      'DDoSProtectionNotifications'
      'DDoSMitigationFlowLogs'
      'DDoSMitigationReports'
    ]
    location: location
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticLogsRetentionInDays: diagnosticLogsRetentionInDays
    diagnosticWorkspaceId: diagnosticWorkspaceId
    diagnosticEventHubAuthorizationRuleId: diagnosticEventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticEventHubName
    lock: lock
    tags: tags
    zones: zones
  }
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2021-08-01' = {
  name: name
  location: location
  zones: length(zones) == 0 ? null : zones
  tags: tags
  properties: azureSkuName == 'AZFW_VNet' ? {
    threatIntelMode: threatIntelMode
    firewallPolicy: !empty(firewallPolicyId) ? {
      id: firewallPolicyId
    } : null
    ipConfigurations: ipConfigurations
    sku: {
      name: azureSkuName
      tier: azureSkuTier
    }
    applicationRuleCollections: applicationRuleCollections
    natRuleCollections: natRuleCollections
    networkRuleCollections: networkRuleCollections
  } : {
    firewallPolicy: !empty(firewallPolicyId) ? {
      id: firewallPolicyId
    } : null
    sku: {
      name: azureSkuName
      tier: azureSkuTier
    }
    hubIPAddresses: !empty(hubIPAddresses) ? hubIPAddresses : null
    virtualHub: !empty(virtualHubId) ? {
      id: virtualHubId
    } : null
  }
  dependsOn: [
    publicIPAddress
  ]
}

resource azureFirewall_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${azureFirewall.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: azureFirewall
}

resource azureFirewall_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: diagnosticSettingsName
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: azureFirewall
}

module azureFirewall_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-AzFW-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: azureFirewall.id
  }
}]

@description('The resource ID of the Azure Firewall.')
output resourceId string = azureFirewall.id

@description('The name of the Azure Firewall.')
output name string = azureFirewall.name

@description('The resource group the Azure firewall was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The private IP of the Azure firewall.')
output privateIp string = contains(azureFirewall.properties, 'ipConfigurations') ? azureFirewall.properties.ipConfigurations[0].properties.privateIPAddress : ''

@description('The public IP configuration object for the Azure Firewall Subnet.')
output ipConfAzureFirewallSubnet object = contains(azureFirewall.properties, 'ipConfigurations') ? azureFirewall.properties.ipConfigurations[0] : {}

@description('List of Application Rule Collections.')
output applicationRuleCollections array = applicationRuleCollections

@description('List of Network Rule Collections.')
output networkRuleCollections array = networkRuleCollections

@description('Collection of NAT rule collections used by Azure Firewall.')
output natRuleCollections array = natRuleCollections

@description('The location the resource was deployed into.')
output location string = azureFirewall.location
