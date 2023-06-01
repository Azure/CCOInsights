@sys.description('Required. The name of the security rule.')
param name string

@sys.description('Conditional. The name of the parent network security group to deploy the security rule into. Required if the template is used in a standalone deployment.')
param networkSecurityGroupName string

@sys.description('Optional. Whether network traffic is allowed or denied.')
@allowed([
  'Allow'
  'Deny'
])
param access string = 'Deny'

@sys.description('Optional. A description for this rule.')
@maxLength(140)
param description string = ''

@sys.description('Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used.')
param destinationAddressPrefix string = ''

@sys.description('Optional. The destination address prefixes. CIDR or destination IP ranges.')
param destinationAddressPrefixes array = []

@sys.description('Optional. The application security group specified as destination.')
param destinationApplicationSecurityGroups array = []

@sys.description('Optional. The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.')
param destinationPortRange string = ''

@sys.description('Optional. The destination port ranges.')
param destinationPortRanges array = []

@sys.description('Required. The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic.')
@allowed([
  'Inbound'
  'Outbound'
])
param direction string

@sys.description('Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.')
param priority int

@sys.description('Required. Network protocol this rule applies to.')
@allowed([
  '*'
  'Ah'
  'Esp'
  'Icmp'
  'Tcp'
  'Udp'
])
param protocol string

@sys.description('Optional. The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from.')
param sourceAddressPrefix string = ''

@sys.description('Optional. The CIDR or source IP ranges.')
param sourceAddressPrefixes array = []

@sys.description('Optional. The application security group specified as source.')
param sourceApplicationSecurityGroups array = []

@sys.description('Optional. The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.')
param sourcePortRange string = ''

@sys.description('Optional. The source port ranges.')
param sourcePortRanges array = []

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-08-01' existing = {
  name: networkSecurityGroupName
}

resource securityRule 'Microsoft.Network/networkSecurityGroups/securityRules@2021-08-01' = {
  name: name
  parent: networkSecurityGroup
  properties: {
    access: access
    description: description
    destinationAddressPrefix: destinationAddressPrefix
    destinationAddressPrefixes: destinationAddressPrefixes
    destinationApplicationSecurityGroups: destinationApplicationSecurityGroups
    destinationPortRange: destinationPortRange
    destinationPortRanges: destinationPortRanges
    direction: direction
    priority: priority
    protocol: protocol
    sourceAddressPrefix: sourceAddressPrefix
    sourceAddressPrefixes: sourceAddressPrefixes
    sourceApplicationSecurityGroups: sourceApplicationSecurityGroups
    sourcePortRange: sourcePortRange
    sourcePortRanges: sourcePortRanges
  }
}

@sys.description('The resource group the security rule was deployed into.')
output resourceGroupName string = resourceGroup().name

@sys.description('The resource ID of the security rule.')
output resourceId string = securityRule.id

@sys.description('The name of the security rule.')
output name string = securityRule.name
