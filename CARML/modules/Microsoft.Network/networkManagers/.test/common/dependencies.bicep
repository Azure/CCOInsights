@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Hub Virtual Network to create.')
param virtualNetworkHubName string

@description('Required. The name of the Spoke 1 Virtual Network to create.')
param virtualNetworkSpoke1Name string

@description('Required. The name of the Spoke 2 Virtual Network to create.')
param virtualNetworkSpoke2Name string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

var addressPrefixHub = '10.0.0.0/16'
var addressPrefixSpoke1 = '172.16.0.0/12'
var addressPrefixSpoke2 = '192.168.0.0/16'
var subnetName = 'defaultSubnet'

resource virtualNetworkHub 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: virtualNetworkHubName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefixHub
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: addressPrefixHub
        }
      }
    ]
  }
}

resource virtualNetworkSpoke1 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: virtualNetworkSpoke1Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefixSpoke1
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: addressPrefixSpoke1
        }
      }
    ]
  }
}

resource virtualNetworkSpoke2 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: virtualNetworkSpoke2Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefixSpoke2
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: addressPrefixSpoke2
        }
      }
    ]
  }
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Hub Virtual Network.')
output virtualNetworkHubId string = virtualNetworkHub.id

@description('The resource ID of the created Spoke 1 Virtual Network.')
output virtualNetworkSpoke1Id string = virtualNetworkSpoke1.id

@description('The resource ID of the created Spoke 2 Virtual Network.')
output virtualNetworkSpoke2Id string = virtualNetworkSpoke2.id
