@description('Required. Name of the Firewall Policy.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the Firewall policy resource.')
param tags object = {}

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. Resource ID of the base policy.')
param basePolicyResourceId string = ''

@description('Optional. Enable DNS Proxy on Firewalls attached to the Firewall Policy.')
param enableProxy bool = false

@description('Optional. List of Custom DNS Servers.')
param servers array = []

@description('Optional. A flag to indicate if the insights are enabled on the policy.')
param insightsIsEnabled bool = false

@description('Optional. Default Log Analytics Resource ID for Firewall Policy Insights.')
param defaultWorkspaceId string = ''

@description('Optional. List of workspaces for Firewall Policy Insights.')
param workspaces array = []

@description('Optional. Number of days the insights should be enabled on the policy.')
param retentionDays int = 365

@description('Optional. List of rules for traffic to bypass.')
param bypassTrafficSettings array = []

@description('Optional. List of specific signatures states.')
param signatureOverrides array = []

@description('Optional. The configuring of intrusion detection.')
@allowed([
  'Alert'
  'Deny'
  'Off'
])
param mode string = 'Off'

@description('Optional. Tier of Firewall Policy.')
@allowed([
  'Premium'
  'Standard'
])
param tier string = 'Standard'

@description('Optional. List of private IP addresses/IP address ranges to not be SNAT.')
param privateRanges array = []

@description('Optional. The operation mode for Threat Intel.')
@allowed([
  'Alert'
  'Deny'
  'Off'
])
param threatIntelMode string = 'Off'

@description('Optional. List of FQDNs for the ThreatIntel Allowlist.')
param fqdns array = []

@description('Optional. List of IP addresses for the ThreatIntel Allowlist.')
param ipAddresses array = []

@description('Optional. Secret ID of (base-64 encoded unencrypted PFX) Secret or Certificate object stored in KeyVault.')
#disable-next-line secure-secrets-in-params // Not a secret
param keyVaultSecretId string = ''

@description('Optional. Name of the CA certificate.')
param certificateName string = ''

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Rule collection groups.')
param ruleCollectionGroups array = []

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

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

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2021-08-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    basePolicy: !empty(basePolicyResourceId) ? {
      id: basePolicyResourceId
    } : null
    dnsSettings: enableProxy ? {
      enableProxy: enableProxy
      servers: servers
    } : null
    insights: insightsIsEnabled ? {
      isEnabled: insightsIsEnabled
      logAnalyticsResources: {
        defaultWorkspaceId: {
          id: !empty(defaultWorkspaceId) ? defaultWorkspaceId : null
        }
        workspaces: !empty(workspaces) ? workspaces : null
      }
      retentionDays: retentionDays
    } : null
    intrusionDetection: (mode != 'Off') ? {
      configuration: {
        bypassTrafficSettings: !empty(bypassTrafficSettings) ? bypassTrafficSettings : null
        signatureOverrides: !empty(signatureOverrides) ? signatureOverrides : null
      }
      mode: mode
    } : null
    sku: {
      tier: tier
    }
    snat: !empty(privateRanges) ? {
      privateRanges: privateRanges
    } : null
    threatIntelMode: threatIntelMode
    threatIntelWhitelist: {
      fqdns: fqdns
      ipAddresses: ipAddresses
    }
    transportSecurity: (!empty(keyVaultSecretId) || !empty(certificateName)) ? {
      certificateAuthority: {
        keyVaultSecretId: !empty(keyVaultSecretId) ? keyVaultSecretId : null
        name: !empty(certificateName) ? certificateName : null
      }
    } : null
  }
}

// When a FW policy uses a base policy and have more rule collection groups,
// they need to be deployed sequentially, otherwise the deployment would fail
// because of concurrent access to the base policy.
// The next line forces ARM to deploy them one after the other, so no race concition on the base policy will happen.
@batchSize(1)
module firewallPolicy_ruleCollectionGroups 'ruleCollectionGroups/deploy.bicep' = [for (ruleCollectionGroup, index) in ruleCollectionGroups: {
  name: '${uniqueString(deployment().name, location)}-firewallPolicy_ruleCollectionGroups-${index}'
  params: {
    firewallPolicyName: firewallPolicy.name
    name: ruleCollectionGroup.name
    priority: ruleCollectionGroup.priority
    ruleCollections: ruleCollectionGroup.ruleCollections
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

@description('The name of the deployed firewall policy.')
output name string = firewallPolicy.name

@description('The resource ID of the deployed firewall policy.')
output resourceId string = firewallPolicy.id

@description('The resource group of the deployed firewall policy.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = firewallPolicy.location
