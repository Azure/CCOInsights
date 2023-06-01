@maxLength(24)
@description('Conditional. The name of the parent Storage Account. Required if the template is used in a standalone deployment.')
param storageAccountName string

@description('Conditional. The name of the parent file service. Required if the template is used in a standalone deployment.')
param fileServicesName string = 'default'

@description('Required. The name of the file share to create.')
param name string

@description('Optional. The maximum size of the share, in gigabytes. Must be greater than 0, and less than or equal to 5120 (5TB). For Large File Shares, the maximum size is 102400 (100TB).')
param shareQuota int = 5120

@allowed([
  'NFS'
  'SMB'
])
@description('Optional. The authentication protocol that is used for the file share. Can only be specified when creating a share.')
param enabledProtocols string = 'SMB'

@allowed([
  'AllSquash'
  'NoRootSquash'
  'RootSquash'
])
@description('Optional. Permissions for NFS file shares are enforced by the client OS rather than the Azure Files service. Toggling the root squash behavior reduces the rights of the root user for NFS shares.')
param rootSquash string = 'NoRootSquash'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

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

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storageAccountName

  resource fileService 'fileServices@2021-09-01' existing = {
    name: fileServicesName
  }
}

resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-09-01' = {
  name: name
  parent: storageAccount::fileService
  properties: {
    shareQuota: shareQuota
    rootSquash: enabledProtocols == 'NFS' ? rootSquash : null
    enabledProtocols: enabledProtocols
  }
}

module fileShare_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: fileShare.id
  }
}]

@description('The name of the deployed file share.')
output name string = fileShare.name

@description('The resource ID of the deployed file share.')
output resourceId string = fileShare.id

@description('The resource group of the deployed file share.')
output resourceGroupName string = resourceGroup().name
