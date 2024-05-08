@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Optional. The name of the Virtual Hub to create.')
param virtualHubName string

@description('Required. The name of the virtual WAN to create.')
param virtualWANName string

resource virtualWan 'Microsoft.Network/virtualWans@2021-05-01' = {
  name: virtualWANName
  location: location
}

resource virtualHub 'Microsoft.Network/virtualHubs@2022-01-01' = {
  name: virtualHubName
  location: location
  properties: {
    virtualWan: {
      id: virtualWan.id
    }
    addressPrefix: '10.1.0.0/16'
  }
}

@description('The resource ID of the created Virtual Hub.')
output virtualHubResourceId string = virtualHub.id
