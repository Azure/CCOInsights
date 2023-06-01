# Network NetworkManagers NetworkGroups `[Microsoft.Network/networkManagers/networkGroups]`

This module deploys Network NetworkManagers NetworkGroups.
A network group is a collection of same-type network resources that you can associate with network manager configurations. You can add same-type network resources after you create the network group.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/networkGroups` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers/networkGroups) |
| `Microsoft.Network/networkManagers/networkGroups/staticMembers` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers/networkGroups/staticMembers) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the network group. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `networkManagerName` | string | The name of the parent network manager. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `description` | string | `''` | A description of the network group. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `staticMembers` | _[staticMembers](staticMembers/readme.md)_ array | `[]` | Static Members to create for the network group. Contains virtual networks to add to the network group. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed network group. |
| `resourceGroupName` | string | The resource group the network group was deployed into. |
| `resourceId` | string | The resource ID of the deployed network group. |

## Cross-referenced modules

_None_
