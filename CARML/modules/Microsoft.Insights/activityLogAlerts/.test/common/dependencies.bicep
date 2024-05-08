@description('Required. The name of the Action Group to create.')
param actionGroupName string

@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource actionGroup 'Microsoft.Insights/actionGroups@2022-06-01' = {
  name: actionGroupName
  location: 'global'
  properties: {
    groupShortName: substring(replace(actionGroupName, '-', ''), 0, 11)
    enabled: true
  }
}

@description('The resource ID of the created Action Group.')
output actionGroupResourceId string = actionGroup.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
