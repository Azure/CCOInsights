targetScope = 'managementGroup'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apamgcom'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '<<namePrefix>>${serviceShort}001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611'
    description: '[Description] Policy Assignment at the management group scope'
    displayName: '[Display Name] Policy Assignment at the management group scope'
    enforcementMode: 'DoNotEnforce'
    identity: 'SystemAssigned'
    location: location
    managementGroupId: last(split(managementGroup().id, '/'))
    metadata: {
      category: 'Security'
      version: '1.0'
    }
    nonComplianceMessages: [
      {
        message: 'Violated Policy Assignment - This is a Non Compliance Message'
      }
    ]
    notScopes: [
      '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg'
    ]
    parameters: {
      enableCollectionOfSqlQueriesForSecurityResearch: {
        value: false
      }
      effect: {
        value: 'Disabled'
      }
    }
    roleDefinitionIds: [
      '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
    ]
    overrides: [
      {
        kind: 'policyEffect'
        value: 'Disabled'
        selectors: [
          {
            kind: 'policyDefinitionReferenceId'
            in: [
              'ASC_DeployAzureDefenderForSqlAdvancedThreatProtectionWindowsAgent'
              'ASC_DeployAzureDefenderForSqlVulnerabilityAssessmentWindowsAgent'
            ]
          }
        ]
      }
    ]
    resourceSelectors: [
      {
        name: 'resourceSelector-test'
        selectors: [
          {
            kind: 'resourceType'
            in: [
              'Microsoft.Compute/virtualMachines'
            ]
          }
          {
            kind: 'resourceLocation'
            in: [
              'westeurope'
            ]
          }
        ]
      }
    ]
  }
}
