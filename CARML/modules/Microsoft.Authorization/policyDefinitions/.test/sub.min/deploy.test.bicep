targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apdsubmin'

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
    policyRule: {
      if: {
        allOf: [
          {
            equals: 'Microsoft.KeyVault/vaults'
            field: 'type'
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
    parameters: {
      effect: {
        allowedValues: [
          'Audit'
        ]
        defaultValue: 'Audit'
        type: 'String'
      }
    }
  }
}
