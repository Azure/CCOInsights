@description('Required. Name of the Application Gateway WAF policy.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Resource tags.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Describes the managedRules structure.')
param managedRules object = {}

@description('Optional. The custom rules inside the policy.')
param customRules array = []

@description('Optional. The PolicySettings for policy.')
param policySettings object = {}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource applicationGatewayWAFPolicy 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2022-01-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    managedRules: managedRules
    customRules: customRules
    policySettings: policySettings
  }
}

@description('The name of the application gateway WAF policy.')
output name string = applicationGatewayWAFPolicy.name

@description('The resource ID of the application gateway WAF policy.')
output resourceId string = applicationGatewayWAFPolicy.id

@description('The resource group the application gateway WAF policy was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = applicationGatewayWAFPolicy.location
