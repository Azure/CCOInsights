@description('Required. Name of the Azure Bastion resource.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. Shared services Virtual Network resource identifier.')
param vNetId string

@description('Optional. The public ip resource ID to associate to the azureBastionSubnet. If empty, then the public ip that is created as part of this module will be applied to the azureBastionSubnet.')
param azureBastionSubnetPublicIpId string = ''

@description('Optional. Specifies if a public ip should be created by default if one is not provided.')
param isCreateDefaultPublicIP bool = true

@description('Optional. Specifies the properties of the public IP to create and be used by Azure Bastion. If it\'s not provided and publicIPAddressResourceId is empty, a \'-pip\' suffix will be appended to the Bastion\'s name.')
param publicIPAddressObject object = {}

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

@allowed([
  'Basic'
  'Standard'
])
@description('Optional. The SKU of this Bastion Host.')
param skuType string = 'Basic'

@description('Optional. Choose to disable or enable Copy Paste.')
param disableCopyPaste bool = false

@description('Optional. Choose to disable or enable File Copy.')
param enableFileCopy bool = true

@description('Optional. Choose to disable or enable IP Connect.')
param enableIpConnect bool = false

@description('Optional. Choose to disable or enable Shareable Link.')
param enableShareableLink bool = false

@description('Optional. The scale units for the Bastion Host resource.')
param scaleUnits int = 2

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'BastionAuditLogs'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsName string = '${name}-diagnosticSettings'

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

var enableTunneling = skuType == 'Standard' ? true : null

var scaleUnitsVar = skuType == 'Basic' ? 2 : scaleUnits

// ----------------------------------------------------------------------------
// Prep ipConfigurations object AzureBastionSubnet for different uses cases:
// 1. Use existing public ip
// 2. Use new public ip created in this module
// 3. Do not use a public ip if isCreateDefaultPublicIP is false
var subnetVar = {
  subnet: {
    id: '${vNetId}/subnets/AzureBastionSubnet' // The subnet name must be AzureBastionSubnet
  }
}
var existingPip = {
  publicIPAddress: {
    id: azureBastionSubnetPublicIpId
  }
}
var newPip = {
  publicIPAddress: (empty(azureBastionSubnetPublicIpId) && isCreateDefaultPublicIP) ? {
    id: publicIPAddress.outputs.resourceId
  } : null
}

var ipConfigurations = [
  {
    name: 'IpConfAzureBastionSubnet'
    //Use existing public ip, new public ip created in this module, or none if isCreateDefaultPublicIP is false
    properties: union(subnetVar, !empty(azureBastionSubnetPublicIpId) ? existingPip : {}, (isCreateDefaultPublicIP ? newPip : {}))
  }
]

var enableReferencedModulesTelemetry = false

// ----------------------------------------------------------------------------

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

module publicIPAddress '../publicIPAddresses/deploy.bicep' = if (empty(azureBastionSubnetPublicIpId) && isCreateDefaultPublicIP) {
  name: '${uniqueString(deployment().name, location)}-Bastion-PIP'
  params: {
    name: contains(publicIPAddressObject, 'name') ? publicIPAddressObject.name : '${name}-pip'
    diagnosticLogCategoriesToEnable: contains(publicIPAddressObject, 'diagnosticLogCategoriesToEnable') ? publicIPAddressObject.diagnosticLogCategoriesToEnable : [
      'DDoSProtectionNotifications'
      'DDoSMitigationFlowLogs'
      'DDoSMitigationReports'
    ]
    diagnosticMetricsToEnable: contains(publicIPAddressObject, 'diagnosticMetricsToEnable') ? publicIPAddressObject.diagnosticMetricsToEnable : [
      'AllMetrics'
    ]
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticLogsRetentionInDays: diagnosticLogsRetentionInDays
    diagnosticWorkspaceId: diagnosticWorkspaceId
    diagnosticEventHubAuthorizationRuleId: diagnosticEventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticEventHubName
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: location
    lock: lock
    publicIPAddressVersion: contains(publicIPAddressObject, 'publicIPAddressVersion') ? publicIPAddressObject.publicIPAddressVersion : 'IPv4'
    publicIPAllocationMethod: contains(publicIPAddressObject, 'publicIPAllocationMethod') ? publicIPAddressObject.publicIPAllocationMethod : 'Static'
    publicIPPrefixResourceId: contains(publicIPAddressObject, 'publicIPPrefixResourceId') ? publicIPAddressObject.publicIPPrefixResourceId : ''
    roleAssignments: contains(publicIPAddressObject, 'roleAssignments') ? publicIPAddressObject.roleAssignments : []
    skuName: contains(publicIPAddressObject, 'skuName') ? publicIPAddressObject.skuName : 'Standard'
    skuTier: contains(publicIPAddressObject, 'skuTier') ? publicIPAddressObject.skuTier : 'Regional'
    tags: tags
    zones: contains(publicIPAddressObject, 'zones') ? publicIPAddressObject.zones : []
  }
}

var bastionpropertiesVar = skuType == 'Standard' ? {
  scaleUnits: scaleUnitsVar
  ipConfigurations: ipConfigurations
  enableTunneling: enableTunneling
  disableCopyPaste: disableCopyPaste
  enableFileCopy: enableFileCopy
  enableIpConnect: enableIpConnect
  enableShareableLink: enableShareableLink
} : {
  scaleUnits: scaleUnitsVar
  ipConfigurations: ipConfigurations
}

resource azureBastion 'Microsoft.Network/bastionHosts@2022-01-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuType
  }
  properties: bastionpropertiesVar
}

resource azureBastion_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${azureBastion.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: azureBastion
}

resource azureBastion_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: diagnosticSettingsName
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    logs: diagnosticsLogs
  }
  scope: azureBastion
}

module azureBastion_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Bastion-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: azureBastion.id
  }
}]

@description('The resource group the Azure Bastion was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name the Azure Bastion.')
output name string = azureBastion.name

@description('The resource ID the Azure Bastion.')
output resourceId string = azureBastion.id

@description('The location the resource was deployed into.')
output location string = azureBastion.location

@description('The public ipconfiguration object for the AzureBastionSubnet.')
output ipConfAzureBastionSubnet object = azureBastion.properties.ipConfigurations[0]
