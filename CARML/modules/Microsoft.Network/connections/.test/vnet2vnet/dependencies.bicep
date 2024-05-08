@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the primary Public IP to create.')
param primaryPublicIPName string

@description('Required. The name of the primary VNET to create.')
param primaryVirtualNetworkName string

@description('Required. The name of the primary Virtual Network Gateway to create.')
param primaryVirtualNetworkGatewayName string

@description('Required. The name of the secondary Public IP to create.')
param secondaryPublicIPName string

@description('Required. The name of the secondary VNET to create.')
param secondaryVirtualNetworkName string

@description('Required. The name of the secondary Virtual Network Gateway to create.')
param secondaryVirtualNetworkGatewayName string

resource primaryVirtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
    name: primaryVirtualNetworkName
    location: location
    properties: {
        addressSpace: {
            addressPrefixes: [
                '10.0.0.0/24'
            ]
        }
        subnets: [
            {
                name: 'GatewaySubnet'
                properties: {
                    addressPrefix: '10.0.0.0/24'
                }
            }
        ]
    }
}

resource primaryPublicIP 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
    name: primaryPublicIPName
    location: location
}

resource primaryVNETGateway 'Microsoft.Network/virtualNetworkGateways@2021-08-01' = {
    name: primaryVirtualNetworkGatewayName
    location: location
    properties: {
        gatewayType: 'Vpn'
        ipConfigurations: [
            {
                name: 'default'
                properties: {
                    privateIPAllocationMethod: 'Dynamic'
                    subnet: {
                        id: primaryVirtualNetwork.properties.subnets[0].id
                    }
                    publicIPAddress: {
                        id: primaryPublicIP.id
                    }
                }
            }
        ]
        vpnType: 'RouteBased'
        vpnGatewayGeneration: 'Generation2'
        sku: {
            name: 'VpnGw2'
            tier: 'VpnGw2'
        }
    }
}

resource secondaryVirtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
    name: secondaryVirtualNetworkName
    location: location
    properties: {
        addressSpace: {
            addressPrefixes: [
                '10.0.1.0/24'
            ]
        }
        subnets: [
            {
                name: 'GatewaySubnet'
                properties: {
                    addressPrefix: '10.0.1.0/24'
                }
            }
        ]
    }
}

resource secondaryPublicIP 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
    name: secondaryPublicIPName
    location: location
}

resource secondaryVNETGateway 'Microsoft.Network/virtualNetworkGateways@2021-08-01' = {
    name: secondaryVirtualNetworkGatewayName
    location: location
    properties: {
        gatewayType: 'Vpn'
        ipConfigurations: [
            {
                name: 'default'
                properties: {
                    privateIPAllocationMethod: 'Dynamic'
                    subnet: {
                        id: secondaryVirtualNetwork.properties.subnets[0].id
                    }
                    publicIPAddress: {
                        id: secondaryPublicIP.id
                    }
                }
            }
        ]
        vpnType: 'RouteBased'
        vpnGatewayGeneration: 'Generation2'
        sku: {
            name: 'VpnGw2'
            tier: 'VpnGw2'
        }
    }
}

@description('The resource ID of the created primary Virtual Network Gateway.')
output primaryVNETGatewayResourceID string = primaryVNETGateway.id

@description('The resource ID of the created secondary Virtual Network Gateway.')
output secondaryVNETGatewayResourceID string = secondaryVNETGateway.id
