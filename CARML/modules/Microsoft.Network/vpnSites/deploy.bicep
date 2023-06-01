@description('Required. Name of the VPN Site.')
param name string

@description('Required. Resource ID of the virtual WAN to link to.')
param virtualWanId string

@description('Optional. Location where all resources will be created.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Conditional. An array of IP address ranges that can be used by subnets of the virtual network. Required if no bgpProperties or VPNSiteLinks are configured.')
param addressPrefixes array = []

@description('Conditional. BGP settings details. Note: This is a deprecated property, please use the corresponding VpnSiteLinks property instead. Required if no addressPrefixes or VPNSiteLinks are configured.')
param bgpProperties object = {}

@description('Optional. List of properties of the device.')
param deviceProperties object = {}

@description('Optional. The IP-address for the VPN-site. Note: This is a deprecated property, please use the corresponding VpnSiteLinks property instead.')
param ipAddress string = ''

@description('Optional. IsSecuritySite flag.')
param isSecuritySite bool = false

@description('Optional. The Office365 breakout policy.')
param o365Policy object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. List of all VPN site links.')
param vpnSiteLinks array = []

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

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

resource vpnSite 'Microsoft.Network/vpnSites@2021-08-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressSpace: !empty(addressPrefixes) ? {
      addressPrefixes: addressPrefixes
    } : null
    bgpProperties: !empty(bgpProperties) ? bgpProperties : null
    deviceProperties: !empty(deviceProperties) ? deviceProperties : null
    ipAddress: !empty(ipAddress) ? ipAddress : null
    isSecuritySite: isSecuritySite
    o365Policy: !empty(o365Policy) ? o365Policy : null
    virtualWan: {
      id: virtualWanId
    }
    vpnSiteLinks: !empty(vpnSiteLinks) ? vpnSiteLinks : null
  }
}

resource vpnSite_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${vpnSite.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: vpnSite
}

module vpnSite_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-VWan-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: vpnSite.id
  }
}]

@description('The name of the VPN site.')
output name string = vpnSite.name

@description('The resource ID of the VPN site.')
output resourceId string = vpnSite.id

@description('The resource group the VPN site was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = vpnSite.location
