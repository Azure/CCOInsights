@description('Base name to be used in all resources')
param name string = ''

@description('Name of the datalake account')
param dlsname string = ''

@description('Location where resources should be deployed')
param location string = resourceGroup().location

@description('Unique string to ensure resource uniqueness')
param uniqueString string = 'u731'

//scope tests
// @description('Location where resources should be deployed')
// param targetScope string = 'resourceGroup'

// app service plan (done)
module appServicePlan '../../CARML/modules/Microsoft.Web/serverfarms/deploy.bicep' = {
  name: toLower(substring('${name}-cco-sp-${uniqueString}', 1, 24))
  params: {
    name: toLower(substring('${name}-cco-sp-${uniqueString}', 1, 24))
    location: location
    sku: {
      name: 's1'
      capacity: 1
    }
  }
}

module storage '../../CARML/modules/Microsoft.Storage/storageAccounts/deploy.bicep' = {
  name: toLower(substring('${name}ccost${uniqueString}', 1, 24))
  params: {
    name: toLower(substring('${name}ccost${uniqueString}', 1, 24))
    location: location
    storageAccountSku: 'Standard_LRS'
  }
}

module appService '../../CARML/modules/Microsoft.Web/sites/deploy.bicep' = {
  name: toLower(substring('${name}-cco-fa-${uniqueString}', 1, 24))
  params: {
    location: location
    kind: 'functionapp'
    name: toLower(substring('${name}-cco-fa-${uniqueString}', 1, 24))
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
  name: toLower(substring('${name}-cco-la-${uniqueString}', 1, 24))
  params: {
    location: location
    name: toLower(substring('${name}-cco-la-${uniqueString}', 1, 24))
    dataRetention: 120
    useResourcePermissions: true
  }
}

//app insights(done)
module appInsights '../../CARML/modules/Microsoft.Insights/components/deploy.bicep' = {
  name: toLower(substring('${name}-cco-ai-${uniqueString}', 1, 24))
  params: {
    location: location
    name: toLower(substring('${name}-cco-ai-${uniqueString}', 1, 24))
    kind: 'web'
    workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
  }
}

//storage account (done)
// services ???
module dataLakeStorage '../../CARML/modules/Microsoft.Storage/storageAccounts/deploy.bicep' = {
  name: !empty(dlsname) ? toLower(dlsname) : toLower(substring('${name}ccodls${uniqueString}', 1, 24))
  params: {
    location: location
    name: !empty(dlsname) ? toLower(dlsname) : toLower(substring('${name}ccodls${uniqueString}', 1, 24))
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
  name: toLower(substring('${dataLakeStorage.name}-cco-containers-${uniqueString}', 1, 24))
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

output dataLakeStorageName string = dataLakeStorage.name
