targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.network.frontdoors-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nfdmin'

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
var resourceName = '<<namePrefix>>${serviceShort}001'
module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: resourceName
    frontendEndpoints: [
      {
        name: 'frontEnd'
        properties: {
          hostName: '${resourceName}.${environment().suffixes.azureFrontDoorEndpointSuffix}'
          sessionAffinityEnabledState: 'Disabled'
          sessionAffinityTtlSeconds: 60
        }
      }
    ]
    healthProbeSettings: [
      {
        name: 'heathProbe'
        properties: {
          intervalInSeconds: 60
          path: '/'
          protocol: 'Https'
        }
      }
    ]
    loadBalancingSettings: [
      {
        name: 'loadBalancer'
        properties: {
          additionalLatencyMilliseconds: 0
          sampleSize: 50
          successfulSamplesRequired: 1
        }
      }
    ]
    routingRules: [
      {
        name: 'routingRule'
        properties: {
          acceptedProtocols: [
            'Https'
          ]
          enabledState: 'Enabled'
          frontendEndpoints: [
            {
              id: '${resourceGroup.id}/providers/Microsoft.Network/frontDoors/${resourceName}/FrontendEndpoints/frontEnd'
            }
          ]
          patternsToMatch: [
            '/*'
          ]
          routeConfiguration: {
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
            backendPool: {
              id: '${resourceGroup.id}/providers/Microsoft.Network/frontDoors/${resourceName}/BackendPools/backendPool'
            }
          }
        }
      }
    ]
    backendPools: [
      {
        name: 'backendPool'
        properties: {
          backends: [
            {
              address: 'biceptest.local'
              backendHostHeader: 'backendAddress'
              enabledState: 'Enabled'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 50
            }
          ]
          HealthProbeSettings: {
            id: '${resourceGroup.id}/providers/Microsoft.Network/frontDoors/${resourceName}/HealthProbeSettings/heathProbe'
          }
          LoadBalancingSettings: {
            id: '${resourceGroup.id}/providers/Microsoft.Network/frontDoors/${resourceName}/LoadBalancingSettings/loadBalancer'
          }
        }
      }
    ]
  }
}
