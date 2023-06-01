@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Network Security Group to create.')
param networkSecurityGroupName string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

var addressPrefix = '10.0.0.0/16'

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowPortsForASE'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '10.0.7.0/24'
          destinationPortRange: '454-455'
          direction: 'Inbound'
          priority: 1010
          protocol: '*'
          sourceAddressPrefix: 'AppServiceManagement'
          sourcePortRange: '*'
        }
      }
    ]
  }
}

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
                    networkSecurityGroup: {
                        id: networkSecurityGroup.id
                    }
                    delegations: [
                        {
                            name: 'ase'
                            properties: {
                            serviceName: 'Microsoft.Web/hostingEnvironments'
                            }
                        }
                    ]
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

