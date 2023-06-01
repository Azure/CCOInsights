targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apsdsubcom'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../subscription/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '<<namePrefix>>${serviceShort}001'
    policyDefinitions: [
      {
        groupNames: [
          'ARM'
        ]
        parameters: {
          listOfAllowedLocations: {
            value: [
              'australiaeast'
            ]
          }
        }
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
        policyDefinitionReferenceId: 'Allowed locations_1'
      }
      {
        groupNames: [
          'ARM'
        ]
        parameters: {
          listOfAllowedLocations: {
            value: [
              'australiaeast'
            ]
          }
        }
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988'
        policyDefinitionReferenceId: 'Allowed locations for resource groups_1'
      }
    ]
    // Non-required parameters
    description: '[Description] This policy set definition is deployed at subscription scope'
    displayName: '[DisplayName] This policy set definition is deployed at subscription scope'
    metadata: {
      category: 'Security'
      version: '1'
    }
    policyDefinitionGroups: [
      {
        name: 'Network'
      }
      {
        name: 'ARM'
      }
    ]
  }
}
