targetScope = 'managementGroup'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.authorization.roleassignments-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'aramgcom'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
module nestedDependencies 'interim.dependencies.bicep' = {
  scope: subscription('<<subscriptionId>>')
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    resourceGroupName: resourceGroupName
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../managementGroup/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    principalId: nestedDependencies.outputs.managedIdentityPrincipalId
    roleDefinitionIdOrName: 'Backup Reader'
    description: 'Role Assignment (management group scope)'
    managementGroupId: last(split(managementGroup().id, '/'))
    principalType: 'ServicePrincipal'
  }
}
