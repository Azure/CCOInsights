# Load Balancer Inbound NAT Rules `[Microsoft.Network/loadBalancers/inboundNatRules]`

This module deploys load balancers inbound NAT rules.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/loadBalancers/inboundNatRules` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/loadBalancers/inboundNatRules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `frontendIPConfigurationName` | string | The name of the frontend IP address to set for the inbound NAT rule. |
| `frontendPort` | int | The port for the external endpoint. Port numbers for each rule must be unique within the Load Balancer. |
| `name` | string | The name of the inbound NAT rule. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `loadBalancerName` | string | The name of the parent load balancer. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `backendAddressPoolName` | string | `''` |  | Name of the backend address pool. |
| `backendPort` | int | `[parameters('frontendPort')]` |  | The port used for the internal endpoint. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enableFloatingIP` | bool | `False` |  | Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn Availability Group. This setting is required when using the SQL AlwaysOn Availability Groups in SQL server. This setting can't be changed after you create the endpoint. |
| `enableTcpReset` | bool | `False` |  | Receive bidirectional TCP Reset on TCP flow idle timeout or unexpected connection termination. This element is only used when the protocol is set to TCP. |
| `frontendPortRangeEnd` | int | `-1` |  | The port range end for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeStart. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. |
| `frontendPortRangeStart` | int | `-1` |  | The port range start for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeEnd. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. |
| `idleTimeoutInMinutes` | int | `4` |  | The timeout for the TCP idle connection. The value can be set between 4 and 30 minutes. The default value is 4 minutes. This element is only used when the protocol is set to TCP. |
| `protocol` | string | `'Tcp'` | `[All, Tcp, Udp]` | The transport protocol for the endpoint. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the inbound NAT rule. |
| `resourceGroupName` | string | The resource group the inbound NAT rule was deployed into. |
| `resourceId` | string | The resource ID of the inbound NAT rule. |

## Cross-referenced modules

_None_
