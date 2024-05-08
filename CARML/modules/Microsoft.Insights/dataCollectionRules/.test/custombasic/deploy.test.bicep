targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.insights.dataCollectionRules-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'idcrcusbas'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module resourceGroupResources 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested'
  params: {
    dataCollectionEndpointName: 'dep-<<namePrefix>>-dce-${serviceShort}'
    logAnalyticsWorkspaceName: 'dep-<<namePrefix>>-law-${serviceShort}'
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: '<<namePrefix>>${serviceShort}001'
    dataCollectionEndpointId: resourceGroupResources.outputs.dataCollectionEndpointResourceId
    dataCollectionRuleDescription: 'Collecting custom text logs without ingestion-time transformation.'
    dataFlows: [
      {
        streams: [
          'Custom-CustomTableBasic_CL'
        ]
        destinations: [
          resourceGroupResources.outputs.logAnalyticsWorkspaceName
        ]
        transformKql: 'source'
        outputStream: 'Custom-CustomTableBasic_CL'
      }
    ]
    dataSources: {
      logFiles: [
        {
          name: 'CustomTableBasic_CL'
          samplingFrequencyInSeconds: 10
          streams: [
            'Custom-CustomTableBasic_CL'
          ]
          filePatterns: [
            'C:\\TestLogsBasic\\TestLog*.log'
          ]
          format: 'text'
          settings: {
            text: {
              recordStartTimestampFormat: 'ISO 8601'
            }
          }
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: resourceGroupResources.outputs.logAnalyticsWorkspaceResourceId
          name: resourceGroupResources.outputs.logAnalyticsWorkspaceName
        }
      ]
    }
    streamDeclarations: {
      'Custom-CustomTableBasic_CL': {
        columns: [
          {
            name: 'TimeGenerated'
            type: 'datetime'
          }
          {
            name: 'RawData'
            type: 'string'
          }
        ]
      }
    }
    enableDefaultTelemetry: enableDefaultTelemetry
    kind: 'Windows'
    lock: 'CanNotDelete'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          resourceGroupResources.outputs.managedIdentityPrincipalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    tags: {
      resourceType: 'Data Collection Rules'
      kind: 'Windows'
    }
  }
}
