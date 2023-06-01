@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Server Farm to create.')
param serverFarmName string

resource serverFarm 'Microsoft.Web/serverfarms@2022-03-01' = {
    name: serverFarmName
    location: location
    sku: {
        name: 'S1'
        tier: 'Standard'
        size: 'S1'
        family: 'S'
        capacity: 1
    }
    properties: {}
}

@description('The resource ID of the created Server Farm.')
output serverFarmResourceId string = serverFarm.id
