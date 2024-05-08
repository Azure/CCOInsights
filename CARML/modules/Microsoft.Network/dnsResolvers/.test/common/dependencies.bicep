@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.100.0/24'
      ]
    }
    subnets: [
      {
        name: 'pdnsin'
        properties: {
          addressPrefix: '10.10.100.0/25'
          delegations: [
            {
              name: 'dnsdel'
              properties: {
                serviceName: 'Microsoft.Network/dnsResolvers'
              }
            }
          ]
        }
      }
      {
        name: 'pdnsout'
        properties: {
          addressPrefix: '10.10.100.128/25'
          delegations: [
            {
              name: 'dnsdel'
              properties: {
                serviceName: 'Microsoft.Network/dnsResolvers'
              }
            }
          ]
        }
      }
    ]
  }
}

@description('The resource ID of the created Virtual Network.')
output virtualNetworkId string = virtualNetwork.id

@description('The resource ID of the created inbound endpoint Virtual Network Subnet.')
output subnetResourceId_dnsIn string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created outbound endpoint Virtual Network Subnet.')
output subnetResourceId_dnsOut string = virtualNetwork.properties.subnets[1].id
