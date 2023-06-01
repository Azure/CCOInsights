@description('Conditional. The name of the parent network manager. Required if the template is used in a standalone deployment.')
param networkManagerName string

@description('Conditional. The name of the parent network group. Required if the template is used in a standalone deployment.')
param networkGroupName string

@description('Required. The name of the static member.')
param name string

@description('Required. Resource ID of the virtual network.')
param resourceId string

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

resource networkManager 'Microsoft.Network/networkManagers@2022-07-01' existing = {
  name: networkManagerName

  resource networkGroup 'networkGroups@2022-07-01' existing = {
    name: networkGroupName
  }
}

resource staticMember 'Microsoft.Network/networkManagers/networkGroups/staticMembers@2022-07-01' = {
  name: name
  parent: networkManager::networkGroup
  properties: {
    resourceId: resourceId
  }
}

@description('The name of the deployed static member.')
output name string = staticMember.name

@description('The resource ID of the deployed static member.')
output resourceId string = staticMember.id

@description('The resource group the static member was deployed into.')
output resourceGroupName string = resourceGroup().name
