@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Application Security Group to create.')
param applicationSecurityGroupName string

@description('Required. The name of the Load Balancer Backend Address Pool to create.')
param loadBalancerName string

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
                }
            }
        ]
    }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
    name: managedIdentityName
    location: location
}

resource applicationSecurityGroup 'Microsoft.Network/applicationSecurityGroups@2022-01-01' = {
    name: applicationSecurityGroupName
    location: location
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
                name: 'privateIPConfig1'
                properties: {
                    subnet: {
                        id: virtualNetwork.properties.subnets[0].id
                    }
                }
            }
        ]
    }

    resource backendPool 'backendAddressPools@2022-01-01' = {
        name: 'default'
    }
}

resource inboundNatRule 'Microsoft.Network/loadBalancers/inboundNatRules@2021-08-01' = {
    name: 'inboundNatRule1'
    properties: {
        frontendPort: 443
        backendPort: 443
        enableFloatingIP: false
        enableTcpReset: false
        frontendIPConfiguration: {
            id: loadBalancer.properties.frontendIPConfigurations[0].id
        }
        idleTimeoutInMinutes: 4
        protocol: 'Tcp'
    }
    parent: loadBalancer
}

resource inboundNatRule2 'Microsoft.Network/loadBalancers/inboundNatRules@2021-08-01' = {
    name: 'inboundNatRule2'
    properties: {
        frontendPort: 3389
        backendPort: 3389
        frontendIPConfiguration: {
            id: loadBalancer.properties.frontendIPConfigurations[0].id
        }
        idleTimeoutInMinutes: 4
        protocol: 'Tcp'
    }
    parent: loadBalancer
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Application Security Group.')
output applicationSecurityGroupResourceId string = applicationSecurityGroup.id

@description('The resource ID of the created Load Balancer Backend Pool Name.')
output loadBalancerBackendPoolResourceId string = loadBalancer::backendPool.id
