@description('Required. Name of the Application Gateway.')
@maxLength(24)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. Authentication certificates of the application gateway resource.')
param authenticationCertificates array = []

@description('Optional. Upper bound on number of Application Gateway capacity.')
param autoscaleMaxCapacity int = -1

@description('Optional. Lower bound on number of Application Gateway capacity.')
param autoscaleMinCapacity int = -1

@description('Optional. Backend address pool of the application gateway resource.')
param backendAddressPools array = []

@description('Optional. Backend http settings of the application gateway resource.')
param backendHttpSettingsCollection array = []

@description('Optional. Custom error configurations of the application gateway resource.')
param customErrorConfigurations array = []

@description('Optional. Whether FIPS is enabled on the application gateway resource.')
param enableFips bool = false

@description('Optional. Whether HTTP2 is enabled on the application gateway resource.')
param enableHttp2 bool = false

@description('Optional. The resource ID of an associated firewall policy. Should be configured for security reasons.')
param firewallPolicyId string = ''

@description('Optional. Frontend IP addresses of the application gateway resource.')
param frontendIPConfigurations array = []

@description('Optional. Frontend ports of the application gateway resource.')
param frontendPorts array = []

@description('Optional. Subnets of the application gateway resource.')
param gatewayIPConfigurations array = []

@description('Optional. Enable request buffering.')
param enableRequestBuffering bool = false

@description('Optional. Enable response buffering.')
param enableResponseBuffering bool = false

@description('Optional. Http listeners of the application gateway resource.')
param httpListeners array = []

@description('Optional. Load distribution policies of the application gateway resource.')
param loadDistributionPolicies array = []

@description('Optional. PrivateLink configurations on application gateway.')
param privateLinkConfigurations array = []

@description('Optional. Probes of the application gateway resource.')
param probes array = []

@description('Optional. Redirect configurations of the application gateway resource.')
param redirectConfigurations array = []

@description('Optional. Request routing rules of the application gateway resource.')
param requestRoutingRules array = []

@description('Optional. Rewrite rules for the application gateway resource.')
param rewriteRuleSets array = []

@description('Optional. The name of the SKU for the Application Gateway.')
@allowed([
  'Standard_Small'
  'Standard_Medium'
  'Standard_Large'
  'WAF_Medium'
  'WAF_Large'
  'Standard_v2'
  'WAF_v2'
])
param sku string = 'WAF_Medium'

@description('Optional. The number of Application instances to be configured.')
@minValue(1)
@maxValue(10)
param capacity int = 2

@description('Optional. SSL certificates of the application gateway resource.')
param sslCertificates array = []

@description('Optional. Ssl cipher suites to be enabled in the specified order to application gateway.')
@allowed([
  'TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA'
  'TLS_DHE_DSS_WITH_AES_128_CBC_SHA'
  'TLS_DHE_DSS_WITH_AES_128_CBC_SHA256'
  'TLS_DHE_DSS_WITH_AES_256_CBC_SHA'
  'TLS_DHE_DSS_WITH_AES_256_CBC_SHA256'
  'TLS_DHE_RSA_WITH_AES_128_CBC_SHA'
  'TLS_DHE_RSA_WITH_AES_128_GCM_SHA256'
  'TLS_DHE_RSA_WITH_AES_256_CBC_SHA'
  'TLS_DHE_RSA_WITH_AES_256_GCM_SHA384'
  'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA'
  'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256'
  'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256'
  'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA'
  'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384'
  'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384'
  'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA'
  'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256'
  'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256'
  'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA'
  'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384'
  'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384'
  'TLS_RSA_WITH_3DES_EDE_CBC_SHA'
  'TLS_RSA_WITH_AES_128_CBC_SHA'
  'TLS_RSA_WITH_AES_128_CBC_SHA256'
  'TLS_RSA_WITH_AES_128_GCM_SHA256'
  'TLS_RSA_WITH_AES_256_CBC_SHA'
  'TLS_RSA_WITH_AES_256_CBC_SHA256'
  'TLS_RSA_WITH_AES_256_GCM_SHA384'
])
param sslPolicyCipherSuites array = [
  'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384'
  'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256'
]

@description('Optional. Ssl protocol enums.')
@allowed([
  'TLSv1_0'
  'TLSv1_1'
  'TLSv1_2'
])
param sslPolicyMinProtocolVersion string = 'TLSv1_2'

@description('Optional. Ssl predefined policy name enums.')
@allowed([
  'AppGwSslPolicy20150501'
  'AppGwSslPolicy20170401'
  'AppGwSslPolicy20170401S'
  ''
])
param sslPolicyName string = ''

@description('Optional. Type of Ssl Policy.')
@allowed([
  'Custom'
  'Predefined'
])
param sslPolicyType string = 'Custom'

@description('Optional. SSL profiles of the application gateway resource.')
param sslProfiles array = []

@description('Optional. Trusted client certificates of the application gateway resource.')
param trustedClientCertificates array = []

@description('Optional. Trusted Root certificates of the application gateway resource.')
param trustedRootCertificates array = []

@description('Optional. URL path map of the application gateway resource.')
param urlPathMaps array = []

@description('Optional. Application gateway web application firewall configuration. Should be configured for security reasons.')
param webApplicationFirewallConfiguration object = {}

@description('Optional. A list of availability zones denoting where the resource needs to come from.')
param zones array = []

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticEventHubName string = ''

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'ApplicationGatewayAccessLog'
  'ApplicationGatewayPerformanceLog'
  'ApplicationGatewayFirewallLog'
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

var identityType = !empty(userAssignedIdentities) ? 'UserAssigned' : 'None'

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

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

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Resource tags.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

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

resource applicationGateway 'Microsoft.Network/applicationGateways@2021-08-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: union({
      authenticationCertificates: authenticationCertificates
      autoscaleConfiguration: autoscaleMaxCapacity > 0 && autoscaleMinCapacity >= 0 ? {
        maxCapacity: autoscaleMaxCapacity
        minCapacity: autoscaleMinCapacity
      } : null
      backendAddressPools: backendAddressPools
      backendHttpSettingsCollection: backendHttpSettingsCollection
      customErrorConfigurations: customErrorConfigurations
      enableHttp2: enableHttp2
      firewallPolicy: !empty(firewallPolicyId) ? {
        id: firewallPolicyId
      } : null
      forceFirewallPolicyAssociation: !empty(firewallPolicyId)
      frontendIPConfigurations: frontendIPConfigurations
      frontendPorts: frontendPorts
      gatewayIPConfigurations: gatewayIPConfigurations
      globalConfiguration: {
        enableRequestBuffering: enableRequestBuffering
        enableResponseBuffering: enableResponseBuffering
      }
      httpListeners: httpListeners
      loadDistributionPolicies: loadDistributionPolicies
      privateLinkConfigurations: privateLinkConfigurations
      probes: probes
      redirectConfigurations: redirectConfigurations
      requestRoutingRules: requestRoutingRules
      rewriteRuleSets: rewriteRuleSets
      sku: {
        name: sku
        tier: endsWith(sku, 'v2') ? sku : substring(sku, 0, indexOf(sku, '_'))
        capacity: autoscaleMaxCapacity > 0 && autoscaleMinCapacity >= 0 ? null : capacity
      }
      sslCertificates: sslCertificates
      sslPolicy: {
        cipherSuites: sslPolicyCipherSuites
        minProtocolVersion: sslPolicyMinProtocolVersion
        policyName: empty(sslPolicyName) ? null : sslPolicyName
        policyType: sslPolicyType
      }
      sslProfiles: sslProfiles
      trustedClientCertificates: trustedClientCertificates
      trustedRootCertificates: trustedRootCertificates
      urlPathMaps: urlPathMaps
    }, (enableFips ? {
      enableFips: enableFips
    } : {}),
    (!empty(webApplicationFirewallConfiguration) ? { webApplicationFirewallConfiguration: webApplicationFirewallConfiguration }: {})
  )
  zones: zones
}

resource applicationGateway_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${applicationGateway.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: applicationGateway
}

resource applicationGateway_diagnosticSettingName 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: diagnosticSettingsName
  properties: {
    storageAccountId: empty(diagnosticStorageAccountId) ? null : diagnosticStorageAccountId
    workspaceId: empty(diagnosticWorkspaceId) ? null : diagnosticWorkspaceId
    eventHubAuthorizationRuleId: empty(diagnosticEventHubAuthorizationRuleId) ? null : diagnosticEventHubAuthorizationRuleId
    eventHubName: empty(diagnosticEventHubName) ? null : diagnosticEventHubName
    metrics: empty(diagnosticStorageAccountId) && empty(diagnosticWorkspaceId) && empty(diagnosticEventHubAuthorizationRuleId) && empty(diagnosticEventHubName) ? null : diagnosticsMetrics
    logs: empty(diagnosticStorageAccountId) && empty(diagnosticWorkspaceId) && empty(diagnosticEventHubAuthorizationRuleId) && empty(diagnosticEventHubName) ? null : diagnosticsLogs
  }
  scope: applicationGateway
}

module applicationGateway_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-AppGateway-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: applicationGateway.id
  }
}]

@description('The name of the application gateway.')
output name string = applicationGateway.name

@description('The resource ID of the application gateway.')
output resourceId string = applicationGateway.id

@description('The resource group the application gateway was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = applicationGateway.location
