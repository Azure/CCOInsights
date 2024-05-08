targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.authorization.roledefinitions-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ardrgcom'

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

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../resourceGroup/deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    roleName: '<<namePrefix>>-testRole-${serviceShort}'
    actions: [
      'Microsoft.Compute/galleries/*'
      'Microsoft.Network/virtualNetworks/read'
    ]
    assignableScopes: [
      resourceGroup.id
    ]
    dataActions: [
      'Microsoft.Storage/storageAccounts/blobServices/*/read'
    ]
    description: 'Test Custom Role Definition Standard (resource group scope)'
    notActions: [
      'Microsoft.Compute/images/delete'
      'Microsoft.Compute/images/write'
      'Microsoft.Network/virtualNetworks/subnets/join/action'
    ]
    notDataActions: [
      'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'
    ]
  }
}
