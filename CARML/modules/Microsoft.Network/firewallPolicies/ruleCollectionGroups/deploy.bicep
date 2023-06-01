@description('Conditional. The name of the parent Firewall Policy. Required if the template is used in a standalone deployment.')
param firewallPolicyName string

@description('Required. The name of the rule collection group to deploy.')
param name string

@description('Required. Priority of the Firewall Policy Rule Collection Group resource.')
param priority int

@description('Optional. Group of Firewall Policy rule collections.')
param ruleCollections array = []

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

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2021-08-01' existing = {
  name: firewallPolicyName
}

resource ruleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2021-08-01' = {
  name: name
  parent: firewallPolicy
  properties: {
    priority: priority
    ruleCollections: ruleCollections
  }
}

@description('The name of the deployed rule collection group.')
output name string = ruleCollectionGroup.name

@description('The resource ID of the deployed rule collection group.')
output resourceId string = ruleCollectionGroup.id

@description('The resource group of the deployed rule collection group.')
output resourceGroupName string = resourceGroup().name
