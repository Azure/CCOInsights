targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.insights.scheduledqueryrules-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'isqrcom'

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
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    logAnalyticsWorkspaceName: 'dep-<<namePrefix>>-law-${serviceShort}'
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
    alertDescription: 'My sample Alert'
    autoMitigate: false
    criterias: {
      allOf: [
        {
          dimensions: [
            {
              name: 'Computer'
              operator: 'Include'
              values: [
                '*'
              ]
            }
            {
              name: 'InstanceName'
              operator: 'Include'
              values: [
                '*'
              ]
            }
          ]
          metricMeasureColumn: 'AggregatedValue'
          operator: 'GreaterThan'
          query: 'Perf | where ObjectName == "LogicalDisk" | where CounterName == "% Free Space" | where InstanceName <> "HarddiskVolume1" and InstanceName <> "_Total" | summarize AggregatedValue = min(CounterValue) by Computer, InstanceName, bin(TimeGenerated,5m)'
          threshold: 0
          timeAggregation: 'Average'
        }
      ]
    }
    evaluationFrequency: 'PT5M'
    queryTimeRange: 'PT5M'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          nestedDependencies.outputs.managedIdentityPrincipalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    scopes: [
      nestedDependencies.outputs.logAnalyticsWorkspaceResourceId
    ]
    suppressForMinutes: 'PT5M'
    windowSize: 'PT5M'
  }
}
