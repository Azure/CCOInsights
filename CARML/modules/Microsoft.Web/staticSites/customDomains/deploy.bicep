@description('Conditional. The custom domain name. Required if the template is used in a standalone deployment.')
param name string

@description('Conditional. The name of the parent Static Web App. Required if the template is used in a standalone deployment.')
param staticSiteName string

@description('Optional. Validation method for adding a custom domain.')
param validationMethod string = 'cname-delegation'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

resource staticSite 'Microsoft.Web/staticSites@2022-03-01' existing = {
  name: staticSiteName
}

resource customDomain 'Microsoft.Web/staticSites/customDomains@2022-03-01' = {
  name: name
  parent: staticSite
  properties: {
    validationMethod: validationMethod
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

@description('The name of the static site custom domain.')
output name string = customDomain.name

@description('The resource ID of the static site custom domain.')
output resourceId string = customDomain.id

@description('The resource group the static site custom domain was deployed into.')
output resourceGroupName string = resourceGroup().name
