# Virtual Hub Virtual Network Connections `[Microsoft.Network/virtualHubs/hubVirtualNetworkConnections]`

This module deploys virtual hub virtual network connections.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/virtualHubs/hubVirtualNetworkConnections` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-05-01/virtualHubs/hubVirtualNetworkConnections) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The connection name. |
| `remoteVirtualNetworkId` | string | Resource ID of the virtual network to link to. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `virtualHubName` | string | The name of the parent virtual hub. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enableInternetSecurity` | bool | `True` | Enable internet security. |
| `routingConfiguration` | object | `{object}` | Routing Configuration indicating the associated and propagated route tables for this connection. |


### Parameter Usage: `hubVirtualNetworkConnections`

...

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the virtual hub connection. |
| `resourceGroupName` | string | The resource group the virtual hub connection was deployed into. |
| `resourceId` | string | The resource ID of the virtual hub connection. |

## Cross-referenced modules

_None_
