@description('Required. Name of the Azure Bastion resource.')
param name string

@description('Optional. The idle timeout of the nat gateway.')
param idleTimeoutInMinutes int = 5

@description('Optional. Use to have a new Public IP Address created for the NAT Gateway.')
param natGatewayPublicIpAddress bool = false

@description('Optional. Specifies the name of the Public IP used by the NAT Gateway. If it\'s not provided, a \'-pip\' suffix will be appended to the Bastion\'s name.')
param natGatewayPipName string = ''

@description('Optional. Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix.')
param natGatewayPublicIPPrefixId string = ''

@description('Optional. DNS name of the Public IP resource. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com.')
param natGatewayDomainNameLabel string = ''

@description('Optional. Existing Public IP Address resource names to use for the NAT Gateway.')
param publicIpAddresses array = []

@description('Optional. Existing Public IP Prefixes resource names to use for the NAT Gateway.')
param publicIpPrefixes array = []

@description('Optional. A list of availability zones denoting the zone in which Nat Gateway should be deployed.')
param zones array = []

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

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

@description('Optional. Tags for the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'DDoSProtectionNotifications'
  'DDoSMitigationFlowLogs'
  'DDoSMitigationReports'
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

var natGatewayPropertyPublicIPPrefixes = [for publicIpPrefix in publicIpPrefixes: {
  id: az.resourceId('Microsoft.Network/publicIPPrefixes', publicIpPrefix)
}]

var natGatewayPropertyPublicIPAddresses = [for publicIpAddress in publicIpAddresses: {
  id: az.resourceId('Microsoft.Network/publicIPAddresses', publicIpAddress)
}]

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

// PUBLIC IP
// =========
module publicIPAddress '../publicIPAddresses/deploy.bicep' = if (natGatewayPublicIpAddress) {
  name: '${uniqueString(deployment().name, location)}-NatGateway-PIP'
  params: {
    name: !empty(natGatewayPipName) ? natGatewayPipName : '${name}-pip'
    diagnosticLogCategoriesToEnable: diagnosticLogCategoriesToEnable
    diagnosticMetricsToEnable: diagnosticMetricsToEnable
    diagnosticSettingsName: diagnosticSettingsName
    diagnosticLogsRetentionInDays: diagnosticLogsRetentionInDays
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticWorkspaceId: diagnosticWorkspaceId
    diagnosticEventHubAuthorizationRuleId: diagnosticEventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticEventHubName
    domainNameLabel: natGatewayDomainNameLabel
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: location
    lock: lock
    publicIPAllocationMethod: 'Static'
    publicIPPrefixResourceId: natGatewayPublicIPPrefixId
    tags: tags
    skuName: 'Standard'
  }
}

// NAT GATEWAY
// ===========
resource natGateway 'Microsoft.Network/natGateways@2022-07-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    idleTimeoutInMinutes: idleTimeoutInMinutes
    publicIpPrefixes: natGatewayPropertyPublicIPPrefixes
    publicIpAddresses: natGatewayPropertyPublicIPAddresses
  }
  zones: zones
}

resource natGateway_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${natGateway.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: natGateway
}

module natGateway_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-NatGateway-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: natGateway.id
  }
}]

@description('The name of the NAT Gateway.')
output name string = natGateway.name

@description('The resource ID of the NAT Gateway.')
output resourceId string = natGateway.id

@description('The resource group the NAT Gateway was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = natGateway.location
