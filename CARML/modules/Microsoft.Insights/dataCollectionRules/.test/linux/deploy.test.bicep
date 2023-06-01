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
param serviceShort string = 'idcrlin'

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
    dataCollectionRuleDescription: 'Collecting Linux-specific performance counters and Linux Syslog'
    dataSources: {
      performanceCounters: [
        {
          name: 'perfCounterDataSource10'
          samplingFrequencyInSeconds: 10
          streams: [
            'Microsoft-InsightsMetrics'
          ]
          counterSpecifiers: [
            'Processor(*)\\% Processor Time'
            'Processor(*)\\% Idle Time'
            'Processor(*)\\% User Time'
            'Processor(*)\\% Nice Time'
            'Processor(*)\\% Privileged Time'
            'Processor(*)\\% IO Wait Time'
            'Processor(*)\\% Interrupt Time'
            'Processor(*)\\% DPC Time'
            'Memory(*)\\Available MBytes Memory'
            'Memory(*)\\% Available Memory'
            'Memory(*)\\Used Memory MBytes'
            'Memory(*)\\% Used Memory'
            'Memory(*)\\Pages/sec'
            'Memory(*)\\Page Reads/sec'
            'Memory(*)\\Page Writes/sec'
            'Memory(*)\\Available MBytes Swap'
            'Memory(*)\\% Available Swap Space'
            'Memory(*)\\Used MBytes Swap Space'
            'Memory(*)\\% Used Swap Space'
          ]
        }
        {
          name: 'perfCounterDataSource15'
          samplingFrequencyInSeconds: 15
          streams: [
            'Microsoft-InsightsMetrics'
          ]
          counterSpecifiers: [
            'Logical Disk(*)\\% Free Inodes'
            'Logical Disk(*)\\% Used Inodes'
            'Logical Disk(*)\\Free Megabytes'
            'Logical Disk(*)\\% Free Space'
            'Logical Disk(*)\\% Used Space'
            'Logical Disk(*)\\Logical Disk Bytes/sec'
            'Logical Disk(*)\\Disk Read Bytes/sec'
            'Logical Disk(*)\\Disk Write Bytes/sec'
            'Logical Disk(*)\\Disk Transfers/sec'
            'Logical Disk(*)\\Disk Reads/sec'
            'Logical Disk(*)\\Disk Writes/sec'
            'Network(*)\\Total Bytes Transmitted'
            'Network(*)\\Total Bytes Received'
            'Network(*)\\Total Bytes'
            'Network(*)\\Total Packets Transmitted'
            'Network(*)\\Total Packets Received'
            'Network(*)\\Total Rx Errors'
            'Network(*)\\Total Tx Errors'
            'Network(*)\\Total Collisions'
          ]
        }
      ]
      syslog: [
        {
          name: 'sysLogsDataSource-debugLevel'
          streams: [
            'Microsoft-Syslog'
          ]
          facilityNames: [
            'auth'
            'authpriv'
          ]
          logLevels: [
            'Debug'
            'Info'
            'Notice'
            'Warning'
            'Error'
            'Critical'
            'Alert'
            'Emergency'
          ]
        }
        {
          name: 'sysLogsDataSource-warningLevel'
          streams: [
            'Microsoft-Syslog'
          ]
          facilityNames: [
            'cron'
            'daemon'
            'mark'
            'kern'
            'local0'
          ]
          logLevels: [
            'Warning'
            'Error'
            'Critical'
            'Alert'
            'Emergency'
          ]
        }
        {
          name: 'sysLogsDataSource-errLevel'
          streams: [
            'Microsoft-Syslog'
          ]
          facilityNames: [
            'local1'
            'local2'
            'local3'
            'local4'
            'local5'
            'local6'
            'local7'
            'lpr'
            'mail'
            'news'
            'syslog'
          ]
          logLevels: [
            'Error'
            'Critical'
            'Alert'
            'Emergency'
          ]
        }
      ]
    }
    destinations: {
      azureMonitorMetrics: {
        name: 'azureMonitorMetrics-default'
      }
      logAnalytics: [
        {
          workspaceResourceId: resourceGroupResources.outputs.logAnalyticsWorkspaceResourceId
          name: resourceGroupResources.outputs.logAnalyticsWorkspaceName
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-InsightsMetrics'
        ]
        destinations: [
          'azureMonitorMetrics-default'
        ]
      }
      {
        streams: [
          'Microsoft-Syslog'
        ]
        destinations: [
          resourceGroupResources.outputs.logAnalyticsWorkspaceName
        ]
      }

    ]
    enableDefaultTelemetry: enableDefaultTelemetry
    kind: 'Linux'
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
      kind: 'Linux'
    }
  }
}
