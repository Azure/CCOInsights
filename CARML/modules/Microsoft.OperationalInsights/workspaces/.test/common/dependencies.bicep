@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Required. The name of the Automation Account to create.')
param automationAccountName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
    name: storageAccountName
    location: location
    sku: {
        name: 'Standard_LRS'
    }
    kind: 'StorageV2'
}

resource automationAccount 'Microsoft.Automation/automationAccounts@2021-06-22' = {
  name: automationAccountName
  location: location
  properties: {
    sku: {
      name: 'Basic'
    }
  }
}

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The resource ID of the created Automation Account.')
output automationAccountResourceId string = automationAccount.id
