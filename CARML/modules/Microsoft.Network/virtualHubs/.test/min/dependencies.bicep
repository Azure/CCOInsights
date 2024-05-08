@description('Required. The name of the virtual WAN to create.')
param virtualWANName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource virtualWan 'Microsoft.Network/virtualWans@2021-05-01' = {
  name: virtualWANName
  location: location
}

@description('The resource ID of the created Virtual WAN.')
output virtualWWANResourceId string = virtualWan.id
