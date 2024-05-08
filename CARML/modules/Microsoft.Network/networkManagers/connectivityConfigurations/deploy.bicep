@sys.description('Conditional. The name of the parent network manager. Required if the template is used in a standalone deployment.')
param networkManagerName string

@maxLength(64)
@sys.description('Required. The name of the connectivity configuration.')
param name string

@maxLength(500)
@sys.description('Optional. A description of the connectivity configuration.')
param description string = ''

@sys.description('Required. Network Groups for the configuration.')
param appliesToGroups array = []

@allowed([
  'HubAndSpoke'
  'Mesh'
])
@sys.description('Required. Connectivity topology type.')
param connectivityTopology string

@sys.description('Conditional. List of hub items. This will create peerings between the specified hub and the virtual networks in the network group specified. Required if connectivityTopology is of type "HubAndSpoke".')
param hubs array = []

@allowed([
  'True'
  'False'
])
@sys.description('Optional. Flag if need to remove current existing peerings. If set to "True", all peerings on virtual networks in selected network groups will be removed and replaced with the peerings defined by this configuration. Optional when connectivityTopology is of type "HubAndSpoke".')
param deleteExistingPeering string = 'False'

@allowed([
  'True'
  'False'
])
@sys.description('Optional. Flag if global mesh is supported. By default, mesh connectivity is applied to virtual networks within the same region. If set to "True", a global mesh enables connectivity across regions.')
param isGlobal string = 'False'

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
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
}

resource connectivityConfiguration 'Microsoft.Network/networkManagers/connectivityConfigurations@2022-07-01' = {
  name: name
  parent: networkManager
  properties: {
    appliesToGroups: appliesToGroups
    connectivityTopology: connectivityTopology
    deleteExistingPeering: connectivityTopology == 'HubAndSpoke' ? deleteExistingPeering : 'False'
    description: description
    hubs: connectivityTopology == 'HubAndSpoke' ? hubs : []
    isGlobal: isGlobal
  }
}

@sys.description('The name of the deployed connectivity configuration.')
output name string = connectivityConfiguration.name

@sys.description('The resource ID of the deployed connectivity configuration.')
output resourceId string = connectivityConfiguration.id

@sys.description('The resource group the connectivity configuration was deployed into.')
output resourceGroupName string = resourceGroup().name
