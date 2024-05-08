targetScope = 'resourceGroup'

@sys.description('Required. Specifies the name of the policy exemption. Maximum length is 64 characters for resource group scope.')
@maxLength(64)
param name string

@sys.description('Optional. The display name of the policy exemption. Maximum length is 128 characters.')
@maxLength(128)
param displayName string = ''

@sys.description('Optional. The description of the policy exemption.')
param description string = ''

@sys.description('Optional. The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs.')
param metadata object = {}

@sys.description('Optional. The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated.')
@allowed([
  'Mitigated'
  'Waiver'
])
param exemptionCategory string = 'Mitigated'

@sys.description('Required. The resource ID of the policy assignment that is being exempted.')
param policyAssignmentId string

@sys.description('Optional. The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition.')
param policyDefinitionReferenceIds array = []

@sys.description('Optional. The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z.')
param expiresOn string = ''

@sys.description('Optional. The option whether validate the exemption is at or under the assignment scope.')
@allowed([
  ''
  'Default'
  'DoNotValidate'
])
param assignmentScopeValidation string = ''

@sys.description('Optional. The resource selector list to filter policies by resource properties.')
param resourceSelectors array = []

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

resource policyExemption 'Microsoft.Authorization/policyExemptions@2022-07-01-preview' = {
  name: name
  properties: {
    displayName: !empty(displayName) ? displayName : null
    description: !empty(description) ? description : null
    metadata: !empty(metadata) ? metadata : null
    exemptionCategory: exemptionCategory
    policyAssignmentId: policyAssignmentId
    policyDefinitionReferenceIds: !empty(policyDefinitionReferenceIds) ? policyDefinitionReferenceIds : []
    expiresOn: !empty(expiresOn) ? expiresOn : null
    assignmentScopeValidation: !empty(assignmentScopeValidation) ? assignmentScopeValidation : null
    resourceSelectors: resourceSelectors
  }
}

@sys.description('Policy Exemption Name.')
output name string = policyExemption.name

@sys.description('Policy Exemption resource ID.')
output resourceId string = policyExemption.id

@sys.description('Policy Exemption Scope.')
output scope string = resourceGroup().id

@sys.description('The name of the resource group the policy exemption was applied at.')
output resourceGroupName string = resourceGroup().name
