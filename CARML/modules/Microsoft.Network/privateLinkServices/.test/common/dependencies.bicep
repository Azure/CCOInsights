@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Load Balancer to create.')
param loadBalancerName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

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
                name: 'defaultSubnet'
                properties: {
                    addressPrefix: addressPrefix
                    privateLinkServiceNetworkPolicies: 'Disabled'
                }
            }
        ]
    }
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2022-01-01' = {
    name: loadBalancerName
    location: location
    sku: {
        name: 'Standard'
    }
    properties: {
        frontendIPConfigurations: [
            {
                name: 'frontendIPConfiguration'
                properties: {
                    subnet: {
                        id: virtualNetwork.properties.subnets[0].id
                    }
                }
            }
        ]
    }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
    name: managedIdentityName
    location: location
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Load Balancer Frontend IP Configuration.')
output loadBalancerFrontendIpConfigurationResourceId string = loadBalancer.properties.frontendIPConfigurations[0].id
