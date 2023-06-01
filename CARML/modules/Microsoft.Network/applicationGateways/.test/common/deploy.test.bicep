targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.network.applicationgateways-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nagcom'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-<<namePrefix>>-vnet-${serviceShort}'
    publicIPName: 'dep-<<namePrefix>>-pip-${serviceShort}'
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    certDeploymentScriptName: 'dep-<<namePrefix>>-ds-${serviceShort}'
    keyVaultName: 'dep-<<namePrefix>>-kv-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../.shared/dependencyConstructs/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep<<namePrefix>>diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-<<namePrefix>>-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-<<namePrefix>>-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-<<namePrefix>>-evhns-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

var appGWName = '<<namePrefix>>${serviceShort}001'
var appGWExpectedResourceID = '${resourceGroup.id}/providers/Microsoft.Network/applicationGateways/${appGWName}'
module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: appGWName
    backendAddressPools: [
      {
        name: 'appServiceBackendPool'
        properties: {
          backendAddresses: [
            {
              fqdn: 'aghapp.azurewebsites.net'
            }
          ]
        }
      }
      {
        name: 'privateVmBackendPool'
        properties: {
          backendAddresses: [
            {
              ipAddress: '10.0.0.4'
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'appServiceBackendHttpsSetting'
        properties: {
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          port: 443
          protocol: 'Https'
          requestTimeout: 30
        }
      }
      {
        name: 'privateVmHttpSetting'
        properties: {
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          port: 80
          probe: {
            id: '${appGWExpectedResourceID}/probes/privateVmHttpSettingProbe'
          }
          protocol: 'Http'
          requestTimeout: 30
        }
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    enableHttp2: true
    frontendIPConfigurations: [
      {
        name: 'private'
        properties: {
          privateIPAddress: '10.0.0.20'
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: nestedDependencies.outputs.subnetResourceId
          }
        }
      }
      {
        name: 'public'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: nestedDependencies.outputs.publicIPResourceId
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port443'
        properties: {
          port: 443
        }
      }
      {
        name: 'port4433'
        properties: {
          port: 4433
        }
      }
      {
        name: 'port80'
        properties: {
          port: 80
        }
      }
      {
        name: 'port8080'
        properties: {
          port: 8080
        }
      }
    ]
    gatewayIPConfigurations: [
      {
        name: 'apw-ip-configuration'
        properties: {
          subnet: {
            id: nestedDependencies.outputs.subnetResourceId
          }
        }
      }
    ]
    httpListeners: [
      {
        name: 'public443'
        properties: {
          frontendIPConfiguration: {
            id: '${appGWExpectedResourceID}/frontendIPConfigurations/public'
          }
          frontendPort: {
            id: '${appGWExpectedResourceID}/frontendPorts/port443'
          }
          hostNames: []
          protocol: 'https'
          requireServerNameIndication: false
          sslCertificate: {
            id: '${appGWExpectedResourceID}/sslCertificates/<<namePrefix>>-az-apgw-x-001-ssl-certificate'
          }
        }
      }
      {
        name: 'private4433'
        properties: {
          frontendIPConfiguration: {
            id: '${appGWExpectedResourceID}/frontendIPConfigurations/private'
          }
          frontendPort: {
            id: '${appGWExpectedResourceID}/frontendPorts/port4433'
          }
          hostNames: []
          protocol: 'https'
          requireServerNameIndication: false
          sslCertificate: {
            id: '${appGWExpectedResourceID}/sslCertificates/<<namePrefix>>-az-apgw-x-001-ssl-certificate'
          }
        }
      }
      {
        name: 'httpRedirect80'
        properties: {
          frontendIPConfiguration: {
            id: '${appGWExpectedResourceID}/frontendIPConfigurations/public'
          }
          frontendPort: {
            id: '${appGWExpectedResourceID}/frontendPorts/port80'
          }
          hostNames: []
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
      {
        name: 'httpRedirect8080'
        properties: {
          frontendIPConfiguration: {
            id: '${appGWExpectedResourceID}/frontendIPConfigurations/private'
          }
          frontendPort: {
            id: '${appGWExpectedResourceID}/frontendPorts/port8080'
          }
          hostNames: []
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
    ]
    lock: 'CanNotDelete'
    probes: [
      {
        name: 'privateVmHttpSettingProbe'
        properties: {
          host: '10.0.0.4'
          interval: 60
          match: {
            statusCodes: [
              '200'
              '401'
            ]
          }
          minServers: 3
          path: '/'
          pickHostNameFromBackendHttpSettings: false
          protocol: 'Http'
          timeout: 15
          unhealthyThreshold: 5
        }
      }
    ]
    redirectConfigurations: [
      {
        name: 'httpRedirect80'
        properties: {
          includePath: true
          includeQueryString: true
          redirectType: 'Permanent'
          requestRoutingRules: [
            {
              id: '${appGWExpectedResourceID}/requestRoutingRules/httpRedirect80-public443'
            }
          ]
          targetListener: {
            id: '${appGWExpectedResourceID}/httpListeners/public443'
          }
        }
      }
      {
        name: 'httpRedirect8080'
        properties: {
          includePath: true
          includeQueryString: true
          redirectType: 'Permanent'
          requestRoutingRules: [
            {
              id: '${appGWExpectedResourceID}/requestRoutingRules/httpRedirect8080-private4433'
            }
          ]
          targetListener: {
            id: '${appGWExpectedResourceID}/httpListeners/private4433'
          }
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'public443-appServiceBackendHttpsSetting-appServiceBackendHttpsSetting'
        properties: {
          backendAddressPool: {
            id: '${appGWExpectedResourceID}/backendAddressPools/appServiceBackendPool'
          }
          backendHttpSettings: {
            id: '${appGWExpectedResourceID}/backendHttpSettingsCollection/appServiceBackendHttpsSetting'
          }
          httpListener: {
            id: '${appGWExpectedResourceID}/httpListeners/public443'
          }
          priority: 200
          ruleType: 'Basic'
        }
      }
      {
        name: 'private4433-privateVmHttpSetting-privateVmHttpSetting'
        properties: {
          backendAddressPool: {
            id: '${appGWExpectedResourceID}/backendAddressPools/privateVmBackendPool'
          }
          backendHttpSettings: {
            id: '${appGWExpectedResourceID}/backendHttpSettingsCollection/privateVmHttpSetting'
          }
          httpListener: {
            id: '${appGWExpectedResourceID}/httpListeners/private4433'
          }
          priority: 250
          ruleType: 'Basic'
        }
      }
      {
        name: 'httpRedirect80-public443'
        properties: {
          httpListener: {
            id: '${appGWExpectedResourceID}/httpListeners/httpRedirect80'
          }
          priority: 300
          redirectConfiguration: {
            id: '${appGWExpectedResourceID}/redirectConfigurations/httpRedirect80'
          }
          ruleType: 'Basic'
        }
      }
      {
        name: 'httpRedirect8080-private4433'
        properties: {
          httpListener: {
            id: '${appGWExpectedResourceID}/httpListeners/httpRedirect8080'
          }
          priority: 350
          redirectConfiguration: {
            id: '${appGWExpectedResourceID}/redirectConfigurations/httpRedirect8080'
          }
          ruleType: 'Basic'
        }
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          nestedDependencies.outputs.managedIdentityPrincipalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    sku: 'WAF_v2'
    sslCertificates: [
      {
        name: '<<namePrefix>>-az-apgw-x-001-ssl-certificate'
        properties: {
          keyVaultSecretId: nestedDependencies.outputs.certificateSecretUrl
        }
      }
    ]
    userAssignedIdentities: {
      '${nestedDependencies.outputs.managedIdentityResourceId}': {}
    }
    webApplicationFirewallConfiguration: {
      disabledRuleGroups: []
      enabled: true
      fileUploadLimitInMb: 100
      firewallMode: 'Detection'
      maxRequestBodySizeInKb: 128
      requestBodyCheck: true
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.0'
    }
  }
}
