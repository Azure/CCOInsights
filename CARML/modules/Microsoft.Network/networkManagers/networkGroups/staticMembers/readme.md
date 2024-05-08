# Network NetworkManagers NetworkGroups StaticMembers `[Microsoft.Network/networkManagers/networkGroups/staticMembers]`

This module deploys Network NetworkManagers NetworkGroups StaticMembers.
Static membership allows you to explicitly add virtual networks to a group by manually selecting individual virtual networks.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/networkGroups/staticMembers` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers/networkGroups/staticMembers) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the static member. |
| `resourceId` | string | Resource ID of the virtual network. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `networkGroupName` | string | The name of the parent network group. Required if the template is used in a standalone deployment. |
| `networkManagerName` | string | The name of the parent network manager. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed static member. |
| `resourceGroupName` | string | The resource group the static member was deployed into. |
| `resourceId` | string | The resource ID of the deployed static member. |

## Cross-referenced modules

_None_
