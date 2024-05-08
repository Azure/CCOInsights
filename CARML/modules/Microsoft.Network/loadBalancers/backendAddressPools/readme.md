# Load Balancers Backend Address Pools `[Microsoft.Network/loadBalancers/backendAddressPools]`

This module deploys load balancer backend address pools.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/loadBalancers/backendAddressPools` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/loadBalancers/backendAddressPools) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backend address pool. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `loadBalancerName` | string | The name of the parent load balancer. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `loadBalancerBackendAddresses` | array | `[]` | An array of backend addresses. |
| `tunnelInterfaces` | array | `[]` | An array of gateway load balancer tunnel interfaces. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backend address pool. |
| `resourceGroupName` | string | The resource group the backend address pool was deployed into. |
| `resourceId` | string | The resource ID of the backend address pool. |

## Cross-referenced modules

_None_
