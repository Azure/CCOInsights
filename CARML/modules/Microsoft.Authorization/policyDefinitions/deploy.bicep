targetScope = 'managementGroup'

@sys.description('Required. Specifies the name of the policy definition. Maximum length is 64 characters for management group scope and subscription scope.')
@maxLength(64)
param name string

@sys.description('Optional. The display name of the policy definition. Maximum length is 128 characters.')
@maxLength(128)
param displayName string = ''

@sys.description('Optional. The policy definition description.')
param description string = ''

@sys.description('Optional. The policy definition mode. Default is All, Some examples are All, Indexed, Microsoft.KeyVault.Data.')
@allowed([
  'All'
  'Indexed'
  'Microsoft.KeyVault.Data'
  'Microsoft.ContainerService.Data'
  'Microsoft.Kubernetes.Data'
  'Microsoft.Network.Data'
])
param mode string = 'All'

@sys.description('Optional. The policy Definition metadata. Metadata is an open ended object and is typically a collection of key-value pairs.')
param metadata object = {}

@sys.description('Optional. The policy definition parameters that can be used in policy definition references.')
param parameters object = {}

@sys.description('Required. The Policy Rule details for the Policy Definition.')
param policyRule object

@sys.description('Optional. The group ID of the Management Group (Scope). If not provided, will use the current scope for deployment.')
param managementGroupId string = managementGroup().name

@sys.description('Optional. The subscription ID of the subscription (Scope). Cannot be used with managementGroupId.')
param subscriptionId string = ''

@sys.description('Optional. Location deployment metadata.')
param location string = deployment().location

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

module policyDefinition_mg 'managementGroup/deploy.bicep' = if (empty(subscriptionId)) {
  name: '${uniqueString(deployment().name, location)}-PolicyDefinition-MG-Module'
  scope: managementGroup(managementGroupId)
  params: {
    name: name
    mode: mode
    displayName: !empty(displayName) ? displayName : ''
    description: !empty(description) ? description : ''
    metadata: !empty(metadata) ? metadata : {}
    parameters: !empty(parameters) ? parameters : {}
    policyRule: policyRule
    location: location
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module policyDefinition_sub 'subscription/deploy.bicep' = if (!empty(subscriptionId)) {
  name: '${uniqueString(deployment().name, location)}-PolicyDefinition-Sub-Module'
  scope: subscription(subscriptionId)
  params: {
    name: name
    mode: mode
    displayName: !empty(displayName) ? displayName : ''
    description: !empty(description) ? description : ''
    metadata: !empty(metadata) ? metadata : {}
    parameters: !empty(parameters) ? parameters : {}
    policyRule: policyRule
    location: location
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

@sys.description('Policy Definition Name.')
output name string = empty(subscriptionId) ? policyDefinition_mg.outputs.name : policyDefinition_sub.outputs.name

@sys.description('Policy Definition resource ID.')
output resourceId string = empty(subscriptionId) ? policyDefinition_mg.outputs.resourceId : policyDefinition_sub.outputs.resourceId

@sys.description('Policy Definition Role Definition IDs.')
output roleDefinitionIds array = empty(subscriptionId) ? policyDefinition_mg.outputs.roleDefinitionIds : policyDefinition_sub.outputs.roleDefinitionIds
