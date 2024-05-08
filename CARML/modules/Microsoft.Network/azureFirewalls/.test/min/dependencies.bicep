@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

var addressPrefix = '10.0.0.0/16'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
    name: virtualNetworkName
    location: location
    properties: {
        addressSpace: {
            addressPrefixes: [
                addressPrefix
            ]
        }
        subnets: [
            {
                name: 'AzureFirewallSubnet'
                properties: {
                    addressPrefix: addressPrefix
                }
            }
        ]
    }
}
@description('The resource ID of the created Virtual Network.')
output virtualNetworkResourceId string = virtualNetwork.id
