targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.storage.storageaccounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssacom'

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
    virtualNetworkName: 'dep-<<namePrefix>>-vnet-${serviceShort}'
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../.shared/dependencyConstructs/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep<<namePrefix>>diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-<<namePrefix>>-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-<<namePrefix>>-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-<<namePrefix>>-evhns-${serviceShort}'
    location: location
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
    storageAccountSku: 'Standard_LRS'
    allowBlobPublicAccess: false
    requireInfrastructureEncryption: true
    largeFileSharesState: 'Enabled'
    lock: 'CanNotDelete'
    enableHierarchicalNamespace: true
    enableSftp: true
    enableNfsV3: true
    privateEndpoints: [
      {
        service: 'blob'
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            nestedDependencies.outputs.privateDNSZoneResourceId
          ]
        }
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          action: 'Allow'
          id: nestedDependencies.outputs.subnetResourceId
        }
      ]
      ipRules: [
        {
          action: 'Allow'
          value: '1.1.1.1'
        }
      ]
    }
    localUsers: [
      {
        storageAccountName: '<<namePrefix>>${serviceShort}001'
        name: 'testuser'
        hasSharedKey: false
        hasSshKey: true
        hasSshPassword: false
        homeDirectory: 'avdscripts'
        permissionScopes: [
          {
            permissions: 'r'
            service: 'blob'
            resourceName: 'avdscripts'
          }
        ]
      }
    ]
    blobServices: {
      diagnosticLogsRetentionInDays: 7
      diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
      diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
      diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
      containers: [
        {
          name: 'avdscripts'
          publicAccess: 'None'
          roleAssignments: [
            {
              roleDefinitionIdOrName: 'Reader'
              principalIds: [
                nestedDependencies.outputs.managedIdentityPrincipalId
              ]
              principalType: 'ServicePrincipal'
            }
          ]
        }
        {
          name: 'archivecontainer'
          publicAccess: 'None'
          enableWORM: true
          WORMRetention: 666
          allowProtectedAppendWrites: false
        }
      ]
    }
    fileServices: {
      diagnosticLogsRetentionInDays: 7
      diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
      diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
      diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
      shares: [
        {
          name: 'avdprofiles'
          shareQuota: 5120
          roleAssignments: [
            {
              roleDefinitionIdOrName: 'Reader'
              principalIds: [
                nestedDependencies.outputs.managedIdentityPrincipalId
              ]
              principalType: 'ServicePrincipal'
            }
          ]
        }
        {
          name: 'avdprofiles2'
          shareQuota: 102400
        }
      ]
    }
    tableServices: {
      diagnosticLogsRetentionInDays: 7
      diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
      diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
      diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
      tables: [
        'table1'
        'table2'
      ]
    }
    queueServices: {
      diagnosticLogsRetentionInDays: 7
      diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
      diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
      diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
      queues: [
        {
          name: 'queue1'
          metadata: {
            key1: 'value1'
            key2: 'value2'
          }
          roleAssignments: [
            {
              roleDefinitionIdOrName: 'Reader'
              principalIds: [
                nestedDependencies.outputs.managedIdentityPrincipalId
              ]
              principalType: 'ServicePrincipal'
            }
          ]
        }
        {
          name: 'queue2'
          metadata: {
          }
        }
      ]
    }
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '${nestedDependencies.outputs.managedIdentityResourceId}': {}
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          nestedDependencies.outputs.managedIdentityPrincipalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
  }
}
