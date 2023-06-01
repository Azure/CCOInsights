@description('Required. The resource ID of the backend linked to the static site.')
param backendResourceId string

@description('Optional. The region of the backend linked to the static site.')
param region string = resourceGroup().location

@description('Conditional. The name of the parent Static Web App. Required if the template is used in a standalone deployment.')
param staticSiteName string

@description('Optional. Name of the backend to link to the static site.')
param name string = uniqueString(backendResourceId)

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

resource staticSite 'Microsoft.Web/staticSites@2022-03-01' existing = {
  name: staticSiteName
}

resource linkedBackend 'Microsoft.Web/staticSites/linkedBackends@2022-03-01' = {
  name: name
  parent: staticSite
  properties: {
    backendResourceId: backendResourceId
    region: region
  }
}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

@description('The name of the static site linked backend.')
output name string = linkedBackend.name

@description('The resource ID of the static site linked backend.')
output resourceId string = linkedBackend.id

@description('The resource group the static site linked backend was deployed into.')
output resourceGroupName string = resourceGroup().name
