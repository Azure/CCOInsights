targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.network.connections-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ncvtv'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

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
    primaryPublicIPName: 'dep-<<namePrefix>>-pip-${serviceShort}-1'
    primaryVirtualNetworkName: 'dep-<<namePrefix>>-vnet-${serviceShort}-1'
    primaryVirtualNetworkGatewayName: 'dep-<<namePrefix>>-vpn-gw-${serviceShort}-1'
    secondaryPublicIPName: 'dep-<<namePrefix>>-pip-${serviceShort}-2'
    secondaryVirtualNetworkName: 'dep-<<namePrefix>>-vnet-${serviceShort}-2'
    secondaryVirtualNetworkGatewayName: 'dep-<<namePrefix>>-vpn-gw-${serviceShort}-2'
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
    virtualNetworkGateway1: {
      id: nestedDependencies.outputs.primaryVNETGatewayResourceID
    }
    enableBgp: false
    lock: 'CanNotDelete'
    virtualNetworkGateway2: {
      id: nestedDependencies.outputs.secondaryVNETGatewayResourceID
    }
    virtualNetworkGatewayConnectionType: 'Vnet2Vnet'
    vpnSharedKey: password
  }
}
