targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.network.vpngateways-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvgcom'

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
    virtualHubName: 'dep-<<namePrefix>>-vh-${serviceShort}'
    virtualWANName: 'dep-<<namePrefix>>-vw-${serviceShort}'
    vpnSiteName: 'dep-<<namePrefix>>-vs-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //
module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '<<namePrefix>>${serviceShort}001'
    virtualHubResourceId: nestedDependencies.outputs.virtualHubResourceId
    bgpSettings: {
      asn: 65515
      peerWeight: 0
    }
    connections: [
      {
        connectionBandwidth: 100
        enableBgp: false
        name: 'Connection-${last(split(nestedDependencies.outputs.vpnSiteResourceId, '/'))}'
        remoteVpnSiteResourceId: nestedDependencies.outputs.vpnSiteResourceId
        enableInternetSecurity: true
        vpnConnectionProtocolType: 'IKEv2'
        enableRateLimiting: false
        useLocalAzureIpAddress: false
        usePolicyBasedTrafficSelectors: false
        routingWeight: 0
      }
    ]
    lock: 'CanNotDelete'
    natRules: [
      {
        externalMappings: [
          {
            addressSpace: '192.168.21.0/24'
          }
        ]
        internalMappings: [
          {
            addressSpace: '10.4.0.0/24'
          }
        ]
        mode: 'EgressSnat'
        name: 'natRule1'
        type: 'Static'
      }
    ]
  }
}
