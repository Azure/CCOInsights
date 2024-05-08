// ================ //
// Parameters       //
// ================ //
@description('Conditional. The name of the parent site resource. Required if the template is used in a standalone deployment.')
param appName string

@description('Required. Slot name to be configured.')
param slotName string

@description('Required. Type of slot to deploy.')
@allowed([
  'functionapp' // function app windows os
  'functionapp,linux' // function app linux os
  'functionapp,workflowapp' // logic app workflow
  'functionapp,workflowapp,linux' // logic app docker container
  'app' // normal web app
])
param kind string

@description('Required. The auth settings V2 configuration.')
param authSettingV2Configuration object

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

// =========== //
// Existing resources //
// =========== //
resource app 'Microsoft.Web/sites@2022-03-01' existing = {
  name: appName

  resource slot 'slots' existing = {
    name: slotName
  }
}

// ============ //
// Dependencies //
// ============ //
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

resource slotSettings 'Microsoft.Web/sites/slots/config@2022-03-01' = {
  name: 'authsettingsV2'
  kind: kind
  parent: app::slot
  properties: authSettingV2Configuration
}

// =========== //
// Outputs     //
// =========== //
@description('The name of the slot config.')
output name string = slotSettings.name

@description('The resource ID of the slot config.')
output resourceId string = slotSettings.id

@description('The resource group the slot config was deployed into.')
output resourceGroupName string = resourceGroup().name
