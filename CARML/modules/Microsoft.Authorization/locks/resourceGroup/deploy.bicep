targetScope = 'resourceGroup'

@description('Optional. The name of the lock.')
param name string = '${level}-lock'

@allowed([
  'CanNotDelete'
  'ReadOnly'
])
@description('Required. Set lock level.')
param level string

@description('Optional. The decription attached to the lock.')
param notes string = level == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'

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

resource lock 'Microsoft.Authorization/locks@2020-05-01' = {
  name: name
  properties: {
    level: level
    notes: notes
    // owners: owners // Not intended to be applied by users (ref https://github.com/Azure/azure-cli/issues/22528)
  }
}

@description('The name of the lock.')
output name string = lock.name

@description('The resource ID of the lock.')
output resourceId string = lock.id

@description('The name of the resource group name the lock was applied to.')
output resourceGroupName string = resourceGroup().name

@sys.description('The scope this lock applies to.')
output scope string = resourceGroup().id
