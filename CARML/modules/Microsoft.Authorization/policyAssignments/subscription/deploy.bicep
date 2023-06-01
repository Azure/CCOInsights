targetScope = 'subscription'

@sys.description('Required. Specifies the name of the policy assignment. Maximum length is 64 characters for subscription scope.')
@maxLength(64)
param name string

@sys.description('Optional. This message will be part of response in case of policy violation.')
param description string = ''

@sys.description('Optional. The display name of the policy assignment. Maximum length is 128 characters.')
@maxLength(128)
param displayName string = ''

@sys.description('Required. Specifies the ID of the policy definition or policy set definition being assigned.')
param policyDefinitionId string

@sys.description('Optional. Parameters for the policy assignment if needed.')
param parameters object = {}

@sys.description('Optional. The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning \'Modify\' policy definitions.')
@allowed([
  'SystemAssigned'
  'UserAssigned'
  'None'
])
param identity string = 'SystemAssigned'

@sys.description('Optional. The Resource ID for the user assigned identity to assign to the policy assignment.')
param userAssignedIdentityId string = ''

@sys.description('Optional. The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.. See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition.')
param roleDefinitionIds array = []

@sys.description('Optional. The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs.')
param metadata object = {}

@sys.description('Optional. The messages that describe why a resource is non-compliant with the policy.')
param nonComplianceMessages array = []

@sys.description('Optional. The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce.')
@allowed([
  'Default'
  'DoNotEnforce'
])
param enforcementMode string = 'Default'

@sys.description('Optional. The policy excluded scopes.')
param notScopes array = []

@sys.description('Optional. Location for all resources.')
param location string = deployment().location

@sys.description('Optional. The policy property value override. Allows changing the effect of a policy definition without modifying the underlying policy definition or using a parameterized effect in the policy definition.')
param overrides array = []

@sys.description('Optional. The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out policy assignments based on factors like resource location, resource type, or whether a resource has a location.')
param resourceSelectors array = []

@sys.description('Optional. The Target Scope for the Policy. The subscription ID of the subscription for the policy assignment. If not provided, will use the current scope for deployment.')
param subscriptionId string = subscription().subscriptionId

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var identityVar = identity == 'SystemAssigned' ? {
  type: identity
} : identity == 'UserAssigned' ? {
  type: identity
  userAssignedIdentities: {
    '${userAssignedIdentityId}': {}
  }
} : null

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

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: name
  location: location
  properties: {
    displayName: !empty(displayName) ? displayName : null
    metadata: !empty(metadata) ? metadata : null
    description: !empty(description) ? description : null
    policyDefinitionId: policyDefinitionId
    parameters: parameters
    nonComplianceMessages: !empty(nonComplianceMessages) ? nonComplianceMessages : []
    enforcementMode: enforcementMode
    notScopes: !empty(notScopes) ? notScopes : []
    overrides: !empty(overrides) ? overrides : []
    resourceSelectors: !empty(resourceSelectors) ? resourceSelectors : []
  }
  identity: identityVar
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for roleDefinitionId in roleDefinitionIds: if (!empty(roleDefinitionIds) && identity == 'SystemAssigned') {
  name: guid(subscriptionId, roleDefinitionId, location, name)
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: policyAssignment.identity.principalId
    principalType: 'ServicePrincipal'
  }
}]

@sys.description('Policy Assignment Name.')
output name string = policyAssignment.name

@sys.description('Policy Assignment principal ID.')
output principalId string = identity == 'SystemAssigned' ? policyAssignment.identity.principalId : ''

@sys.description('Policy Assignment resource ID.')
output resourceId string = policyAssignment.id

@sys.description('The location the resource was deployed into.')
output location string = policyAssignment.location
