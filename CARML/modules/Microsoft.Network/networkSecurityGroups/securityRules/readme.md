# Network Security Groups Security Rules `[Microsoft.Network/networkSecurityGroups/securityRules]`

This module deploys Network Security Group Security Rules.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkSecurityGroups/securityRules` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/networkSecurityGroups/securityRules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `direction` | string | `[Inbound, Outbound]` | The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic. |
| `name` | string |  | The name of the security rule. |
| `priority` | int |  | The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
| `protocol` | string | `[*, Ah, Esp, Icmp, Tcp, Udp]` | Network protocol this rule applies to. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `networkSecurityGroupName` | string | The name of the parent network security group to deploy the security rule into. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `access` | string | `'Deny'` | `[Allow, Deny]` | Whether network traffic is allowed or denied. |
| `description` | string | `''` |  | A description for this rule. |
| `destinationAddressPrefix` | string | `''` |  | The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. |
| `destinationAddressPrefixes` | array | `[]` |  | The destination address prefixes. CIDR or destination IP ranges. |
| `destinationApplicationSecurityGroups` | array | `[]` |  | The application security group specified as destination. |
| `destinationPortRange` | string | `''` |  | The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| `destinationPortRanges` | array | `[]` |  | The destination port ranges. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `sourceAddressPrefix` | string | `''` |  | The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from. |
| `sourceAddressPrefixes` | array | `[]` |  | The CIDR or source IP ranges. |
| `sourceApplicationSecurityGroups` | array | `[]` |  | The application security group specified as source. |
| `sourcePortRange` | string | `''` |  | The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| `sourcePortRanges` | array | `[]` |  | The source port ranges. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the security rule. |
| `resourceGroupName` | string | The resource group the security rule was deployed into. |
| `resourceId` | string | The resource ID of the security rule. |

## Cross-referenced modules

_None_
