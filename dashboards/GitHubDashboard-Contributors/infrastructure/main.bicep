@description('Base name to be used in all resources')
param name string = 'ccogh'

@description('Name of the storage account')
param staname string = 'jsfccoghcontsta'

@description('Location where resources should be deployed')
param location string = resourceGroup().location

var version = 'CCOInsights GH v0.1'


// App Service Plan (AVM)
module appServicePlan 'br/public:avm/res/web/serverfarm:0.4.1' = {
  name: '${name}-sp'
  params: {
    name: '${name}-sp'
    location: location
    skuName: 'S1'
    skuCapacity: 1
    tags: {
      version: version
    }
  }
}

// Log Analytics Workspace (AVM)
module logAnalytics 'br/public:avm/res/operational-insights/workspace:0.9.1' = {
  name: '${name}-la'
  params: {
    name: '${name}-la'
    location: location
    dataRetention: 120
    tags: {
      version: version
    }
  }
}

// Application Insights (AVM)
module appInsights 'br/public:avm/res/insights/component:0.6.0' = {
  name: '${name}-ai'
  params: {
    name: '${name}-ai'
    location: location
    kind: 'web'
    workspaceResourceId: logAnalytics.outputs.resourceId
    tags: {
      version: version
    }
  }
}

// Storage Account (AVM)
module storage 'br/public:avm/res/storage/storage-account:0.20.0' = {
  name: toLower(staname)
  params: {
    name: toLower(staname)
    location: location
    skuName: 'Standard_LRS'
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    tags: {
      version: version
    }
  }
}

var storageResourceId = resourceId('Microsoft.Storage/storageAccounts', staname)
var storageKey = listKeys(storageResourceId, '2021-08-01').keys[0].value
var storageConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${storage.outputs.name};AccountKey=${storageKey};EndpointSuffix=core.windows.net'

// Function App (AVM)
module appService 'br/public:avm/res/web/site:0.16.0' = {
  name: '${name}-fa'
  params: {
    name: '${name}-fa'
    location: location
    kind: 'functionapp'
    serverFarmResourceId: appServicePlan.outputs.resourceId

    managedIdentities: {
      systemAssigned: true
    }
    siteConfig: {
      alwaysOn: true
      minimumElasticInstanceCount: 1
      functionAppScaleLimit: 200
      netFrameworkVersion: 'v4.0'
      phpVersion: '5.6'
      powerShellVersion: '~7'
    }
    configs: [
      {
        name: 'appsettings'
        properties: {
          APPINSIGHTS_INSTRUMENTATIONKEY: appInsights.outputs.instrumentationKey
          WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: storageConnectionString
          FUNCTIONS_EXTENSION_VERSION: '~3'
          FUNCTIONS_WORKER_RUNTIME: 'powershell'
          WEBSITE_CONTENTSHARE: '${name}-fa'
          AzureWebJobsStorage: 'DefaultEndpointsProtocol=https;AccountName=${storage.outputs.name};EndpointSuffix=core.windows.net'
        }
        applicationInsightResourceId: appInsights.outputs.resourceId
        storageAccountResourceId: storage.outputs.resourceId
      }
    ]
    httpsOnly: true
    tags: {
      version: version
    }
  }
}

// Role Assignment (AVM - resource scope)
module roleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: '${name}-storage-ra'
  params: {
    name: guid(name, 'roleassignment')
    principalId: appService.outputs.systemAssignedMIPrincipalId
    roleName: 'Contributor'
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635' // Contributor role
    principalType: 'ServicePrincipal'
    resourceId: storage.outputs.resourceId
  }
}
