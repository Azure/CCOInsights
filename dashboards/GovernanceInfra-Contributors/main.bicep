@description('Base name to be used in all resources')
param name string = ''

@description('Name of the datalake account')
param dlsname string = ''

@description('Location where resources should be deployed')
param location string = resourceGroup().location

var version = 'CCOInsights v0.1'

// App Service Plan
module appServicePlan 'br/public:avm/res/web/serverfarm:0.4.1' = {
  name: '${name}-cco-sp'
  params: {
    name: '${name}-cco-sp'
    location: location
    skuCapacity: 1
    skuName: 'B1'
    tags: {
      version: version
    }
  }
}

// Storage Account
module storage 'br/public:avm/res/storage/storage-account:0.20.0' = {
  name: '${name}ccost'
  params: {
    name: toLower('${name}ccost')
    location: location
    skuName: 'Standard_LRS'
    tags: {
      version: version
    }
  }
}

// Function App
module appService 'br/public:avm/res/web/site:0.16.0' = {
  name: '${name}-cco-fa'
  params: {
    name: '${name}-cco-fa'
    location: location
    kind: 'functionapp'
    serverFarmResourceId: appServicePlan.outputs.resourceId

    managedIdentities: {
      systemAssigned: true
    }
    siteConfig: {
      alwaysOn: true
      use32BitWorkerProcess: false
      minimumElasticInstanceCount: 1
      functionAppScaleLimit: 200
      netFrameworkVersion: 'v8.0'
      cors: {
        allowedOrigins: [
          'https://portal.azure.com'
        ]
        supportCredentials: false
      }
    }
    configs: [
      {
        name: 'appsettings'
        properties: {
          FUNCTIONS_EXTENSION_VERSION: '~4'
          FUNCTIONS_WORKER_RUNTIME: 'dotnet-isolated'
          WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED: '1'
          AzureWebJobsStorage__accountName: storage.outputs.name
        }
        storageAccountResourceId: storage.outputs.resourceId
        applicationInsightResourceId: appInsights.outputs.resourceId
      }
    ]
    httpsOnly: true
    tags: {
      version: version
    }
  }
}


// Log Analytics Workspace
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.9.1' = {
  name: '${name}-cco-la'
  params: {
    name: '${name}-cco-la'
    location: location
    tags: {
      version: version
    }
  }
}


// Application Insights
module appInsights 'br/public:avm/res/insights/component:0.6.0' = {
  name: '${name}-cco-ai'
  params: {
    name: '${name}-cco-ai'
    location: location
    workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    kind: 'web'
    tags: {
      version: version
    }
  }
}

// Data Lake Storage Account
module dataLakeStorage 'br/public:avm/res/storage/storage-account:0.20.0' = {
  name: !empty(dlsname) ? toLower(dlsname) : toLower('${name}ccodls')
  params: {
    name: !empty(dlsname) ? toLower(dlsname) : toLower('${name}ccodls')
    location: location
    enableHierarchicalNamespace: true
    skuName: 'Standard_LRS'
    allowBlobPublicAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    tags: {
      version: version
    }
  }
}

// ######################



// Blob Containers (native Bicep as AVM module not available)
resource sa 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: dataLakeStorage.name
}

resource blobContainers 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = [for containerName in [
  'advisorrecommendations'
  'advisorscores'
  'appserviceplans'
  'blueprints'
  'blueprintartifacts'
  'blueprintassignments'
  'blueprintpublisheds'
  'computeusages'
  'defenderalerts'
  'defenderassessments'
  'defenderassessmentsmetadatas'
  'defendersecurescorecontrols'
  'defendersecurescorecontroldefinitions'
  'disks'
  'entities'
  'genericresources'
  'groups'
  'keyvaults'
  'locations'
  'networksecuritygroups'
  'networkusages'
  'nics'
  'policydefinitions'
  'policysetdefinitions'
  'policystates'
  'pricings'
  'publicips'
  'resourcegroups'
  'resources'
  'roleassignments'
  'roledefinitions'
  'securitytasks'
  'serviceprincipals'
  'sites'
  'storageusages'
  'subassessments'
  'subscriptions'
  'users'
  'virtualmachines'
  'virtualmachineextensions'
  'virtualmachinepatchs'
  'virtualnetworks'
]: {
  name: '${sa.name}/default/${containerName}'
  properties: {
    publicAccess: 'Container'
  }
}]

// Role Definitions (existing resources)
resource contributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
}

resource storageBlobDataContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
}

// Role Assignments
resource roleAssignment1 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(name, 'roleassignment')
  scope: sa
  properties: {
    principalId: appService.outputs.?systemAssignedMIPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: contributorRoleDefinition.id
  }
}

resource roleAssignment2 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(resourceGroup().id, 'StorageBlobDataContributor')
  scope: sa
  properties: {
    principalId: appService.outputs.?systemAssignedMIPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: storageBlobDataContributorRoleDefinition.id
  }
}

output dataLakeStorageName string = dataLakeStorage.name
