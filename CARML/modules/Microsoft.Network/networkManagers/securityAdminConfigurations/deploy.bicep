@sys.description('Conditional. The name of the parent network manager. Required if the template is used in a standalone deployment.')
param networkManagerName string

@maxLength(64)
@sys.description('Required. The name of the security admin configuration.')
param name string

@maxLength(500)
@sys.description('Optional. A description of the security admin configuration.')
param description string = ''

@allowed([
  'None'
  'All'
  'AllowRulesOnly'
])
@sys.description('Required. Enum list of network intent policy based services.')
param applyOnNetworkIntentPolicyBasedServices array = [ 'None' ]

@sys.description('Optional. A security admin configuration contains a set of rule collections that are applied to network groups. Each rule collection contains one or more security admin rules.')
param ruleCollections array = []

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

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

resource securityAdminConfigurations 'Microsoft.Network/networkManagers/securityAdminConfigurations@2022-07-01' = {
  name: name
  parent: networkManager
  properties: {
    description: description
    applyOnNetworkIntentPolicyBasedServices: applyOnNetworkIntentPolicyBasedServices
  }
}

module securityAdminConfigurations_ruleCollections 'ruleCollections/deploy.bicep' = [for (ruleCollection, index) in ruleCollections: {
  name: '${uniqueString(deployment().name)}-SecurityAdminConfigurations-RuleCollections-${index}'
  params: {
    networkManagerName: networkManager.name
    securityAdminConfigurationName: securityAdminConfigurations.name
    name: ruleCollection.name
    appliesToGroups: ruleCollection.appliesToGroups
    rules: contains(ruleCollection, 'rules') ? ruleCollection.rules : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

@sys.description('The name of the deployed security admin configuration.')
output name string = securityAdminConfigurations.name

@sys.description('The resource ID of the deployed security admin configuration.')
output resourceId string = securityAdminConfigurations.id

@sys.description('The resource group the security admin configuration was deployed into.')
output resourceGroupName string = resourceGroup().name
