targetScope = 'managementGroup'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apdmgcom'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../managementGroup/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '<<namePrefix>>${serviceShort}001'
    policyRule: {
      if: {
        allOf: [
          {
            equals: 'Microsoft.Resources/subscriptions'
            field: 'type'
          }
          {
            exists: 'false'
            field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
          }
        ]
      }
      then: {
        details: {
          operations: [
            {
              field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
              operation: 'add'
              value: '[parameters(\'tagValue\')]'
            }
          ]
          roleDefinitionIds: [
            '/providers/microsoft.authorization/roleDefinitions/4a9ae827-6dc8-4573-8ac7-8239d42aa03f'
          ]
        }
        effect: 'modify'
      }
    }
    description: '[Description] This policy definition is deployed at the management group scope'
    displayName: '[DisplayName] This policy definition is deployed at the management group scope'
    metadata: {
      category: 'Security'
    }
    parameters: {
      tagName: {
        metadata: {
          description: 'Name of the tag such as \'environment\''
          displayName: 'Tag Name'
        }
        type: 'String'
      }
      tagValue: {
        metadata: {
          description: 'Value of the tag such as \'environment\''
          displayName: 'Tag Value'
        }
        type: 'String'
      }
    }
  }
}
