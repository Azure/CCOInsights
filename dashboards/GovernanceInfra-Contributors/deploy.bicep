@description('Base name to be used in all resources')
param name string = ''

@description('Name of the datalake account')
param dlsname string = ''

@description('Location where resources should be deployed')
param location string = resourceGroup().location

//scope tests
// @description('Location where resources should be deployed')
// param targetScope string = 'resourceGroup'

// app service plan (done)
module appServicePlan '../../CARML/modules/Microsoft.Web/serverfarms/deploy.bicep' = {
  name: '${name}-cco-sp'
  params: {
    name: '${name}-cco-sp'
    location: location
    sku: {
      name: 'P0v3'
      capacity: 1
    }
  }
}

module storage '../../CARML/modules/Microsoft.Storage/storageAccounts/deploy.bicep' = {
  name: toLower('${name}ccost')
  params: {
    name: toLower('${name}ccost')
    location: location
    storageAccountSku: 'Standard_LRS'
  }
}

module appService '../../CARML/modules/Microsoft.Web/sites/deploy.bicep' = {
  name: '${name}-cco-fa'
  params: {
    location: location
    kind: 'functionapp'
    name: '${name}-cco-fa'
    serverFarmResourceId: appServicePlan.outputs.resourceId
    systemAssignedIdentity: true
    clientAffinityEnabled: false //default vault is true
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: true
      http20Enabled: false
      functionAppScaleLimit: 200
      minimumElasticInstanceCount: 1
      netFrameworkVersion: 'v4.0'
      cors: {
        allowedOrigins: [
          'https://portal.azure.com'
        ]
        supportCredentials: false // Set to true if you want to support user credentials in CORS requests
      }
    }
    httpsOnly: true //by default
    storageAccountRequired: false //default value is false (not required)
  }
}
//keyvault reference identity 

module appServiceSettings '../../CARML/modules/Microsoft.Web/sites/config-appsettings/deploy.bicep' = {
  name: 'appsettings'
  params: {
    appName: appService.name
    kind: 'functionapp'
    storageAccountId: storage.outputs.resourceId
    appInsightId: appInsights.outputs.resourceId
    appSettingsKeyValuePairs: {
      FUNCTIONS_EXTENSION_VERSION: '~4'
      FUNCTIONS_WORKER_RUNTIME: 'dotnet'
    }
  }
}
//log analytics workspace (done)
module logAnalyticsWorkspace '../../CARML/modules/Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  name: '${name}-cco-la'
  params: {
    location: location
    name: '${name}-cco-la'
    dataRetention: 120
    useResourcePermissions: true
  }
}

//app insights(done)
module appInsights '../../CARML/modules/Microsoft.Insights/components/deploy.bicep' = {
  name: '${name}-cco-ai'
  params: {
    location: location
    name: '${name}-cco-ai'
    kind: 'web'
    workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
  }
}

//storage account (done)
// services ???
module dataLakeStorage '../../CARML/modules/Microsoft.Storage/storageAccounts/deploy.bicep' = {
  name: !empty(dlsname) ? toLower(dlsname) : toLower('${name}ccodls')
  params: {
    location: location
    name: !empty(dlsname) ? toLower(dlsname) : toLower('${name}ccodls')
    enableHierarchicalNamespace: true
    storageAccountSku: 'Standard_LRS' //default is GRS check
    allowBlobPublicAccess: true // recommended to be false, false is the deafulat, check this with Jordi
    networkAcls: { // networkacls, default action is set to allow, should we make it deny
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
  }
}

module storageAccountContainers '../../CARML/modules/Microsoft.Storage/storageAccounts/blobServices/deploy.bicep' = {
  name: '${dataLakeStorage.name}-cco-containers'
  params: {
    storageAccountName: dataLakeStorage.name

    containers: [
      { name: 'advisorrecommendations', publicAccess: 'Container' }
      { name: 'advisorscores', publicAccess: 'Container' }
      { name: 'appserviceplanss', publicAccess: 'Container' }
      { name: 'blueprints', publicAccess: 'Container' }
      { name: 'blueprintartifactss', publicAccess: 'Container' }
      { name: 'blueprintassignmentss', publicAccess: 'Container' }
      { name: 'blueprintpublisheds', publicAccess: 'Container' }
      { name: 'computeusages', publicAccess: 'Container' }
      { name: 'defenderalerts', publicAccess: 'Container' }
      { name: 'defenderassessments', publicAccess: 'Container' }
      { name: 'defenderassessmentsmetadatas', publicAccess: 'Container' }
      { name: 'defendersecurescorecontrols', publicAccess: 'Container' }
      { name: 'defendersecurescorecontroldefinitions', publicAccess: 'Container' }
      { name: 'diskss', publicAccess: 'Container' }
      { name: 'entitys', publicAccess: 'Container' }
      { name: 'genericresources', publicAccess: 'Container' }
      { name: 'groupss', publicAccess: 'Container' }
      { name: 'keyvaults', publicAccess: 'Container' }
      { name: 'locations', publicAccess: 'Container' }
      { name: 'networksecuritygroupss', publicAccess: 'Container' }
      { name: 'networkusagess', publicAccess: 'Container' }
      { name: 'nics', publicAccess: 'Container' }
      { name: 'policydefinitionss', publicAccess: 'Container' }
      { name: 'policysetdefinitionss', publicAccess: 'Container' }
      { name: 'policystates', publicAccess: 'Container' }
      { name: 'pricings', publicAccess: 'Container' }
      { name: 'publicipss', publicAccess: 'Container' }
      { name: 'resourcegroups', publicAccess: 'Container' }
      { name: 'resources', publicAccess: 'Container' }
      { name: 'roleassignments', publicAccess: 'Container' }
      { name: 'roledefinitionss', publicAccess: 'Container' }
      { name: 'securitytasks', publicAccess: 'Container' }
      { name: 'serviceprincipals', publicAccess: 'Container' }
      { name: 'sites', publicAccess: 'Container' }
      { name: 'storageusages', publicAccess: 'Container' }
      { name: 'subassessments', publicAccess: 'Container' }
      { name: 'subscriptionss', publicAccess: 'Container' }
      { name: 'userss', publicAccess: 'Container' }
      { name: 'virtualmachines', publicAccess: 'Container' }
      { name: 'virtualmachineextensionss', publicAccess: 'Container' }
      { name: 'virtualmachinepatchs', publicAccess: 'Container' }
      { name: 'virtualnetworkss', publicAccess: 'Container' }
    ]
  }
}

resource contributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
}

resource storageBlobDataContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
}

resource sa 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: dataLakeStorage.name
}

resource roleAssignment1 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(name, 'roleassignment')
  scope: sa
  properties: {
    principalId: appService.outputs.systemAssignedPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: contributorRoleDefinition.id
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(resourceGroup().id, 'StorageBlobDataContributor')
  scope: sa
  properties: {
    principalId: appService.outputs.systemAssignedPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: storageBlobDataContributorRoleDefinition.id
  }
}

output dataLakeStorageName string = dataLakeStorage.name
