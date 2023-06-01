@allowed([
  'appsettings'
  'functionappsettings'
])
@description('Required. Type of settings to apply.')
param kind string

@description('Required. App settings.')
param properties object

@description('Conditional. The name of the parent Static Web App. Required if the template is used in a standalone deployment.')
param staticSiteName string

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

resource staticSite 'Microsoft.Web/staticSites@2022-03-01' existing = {
  name: staticSiteName
}

resource config 'Microsoft.Web/staticSites/config@2022-03-01' = {
  #disable-next-line BCP225 // Disables incorrect error that `name` cannot be determined at compile time.
  name: kind
  parent: staticSite
  properties: properties
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

@description('The name of the config.')
output name string = config.name

@description('The resource ID of the config.')
output resourceId string = config.id

@description('The name of the resource group the config was created in.')
output resourceGroupName string = resourceGroup().name
