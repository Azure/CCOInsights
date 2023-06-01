targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apesubmin'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource policyAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'dep-<<namePrefix>>-${serviceShort}-rgloc'
  location: location
  properties: {
    displayName: '[Depedency] Audit resource location matches resource group location (management group scope)'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/0a914e76-4921-4c19-b460-a2d36003525a'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../subscription/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '<<namePrefix>>${serviceShort}001'
    policyAssignmentId: policyAssignment.id
  }
}
