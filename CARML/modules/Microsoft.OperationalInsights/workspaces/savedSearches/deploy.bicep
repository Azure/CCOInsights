@description('Conditional. The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment.')
param logAnalyticsWorkspaceName string

@description('Required. Name of the saved search.')
param name string

@description('Required. Display name for the search.')
param displayName string

@description('Required. Query category.')
param category string

@description('Required. Kusto Query to be stored.')
param query string

@description('Optional. Tags to configure in the resource.')
param tags array = []

@description('Optional. The function alias if query serves as a function.')
param functionAlias string = ''

@description('Optional. The optional function parameters if query serves as a function. Value should be in the following format: "param-name1:type1 = default_value1, param-name2:type2 = default_value2". For more examples and proper syntax please refer to /azure/kusto/query/functions/user-defined-functions.')
param functionParameters string = ''

@description('Optional. The version number of the query language.')
param version int = 2

// @description('Optional. The ETag of the saved search. To override an existing saved search, use "*" or specify the current Etag.')
// param etag string = '*'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource savedSearch 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
  name: name
  parent: workspace
  //etag: etag // According to API, the variable should be here, but it doesn't work here.
  properties: {
    //etag: etag
    tags: tags
    displayName: displayName
    category: category
    query: query
    functionAlias: functionAlias
    functionParameters: functionParameters
    version: version
  }
}

@description('The resource ID of the deployed saved search.')
output resourceId string = savedSearch.id

@description('The resource group where the saved search is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The name of the deployed saved search.')
output name string = savedSearch.name
