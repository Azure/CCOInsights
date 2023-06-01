# Authorization Locks on Resource Group level `[Microsoft.Authorization/locks/resourceGroup]`

This module deploys Authorization Locks on Resource Group level.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `level` | string | `[CanNotDelete, ReadOnly]` | Set lock level. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `name` | string | `[format('{0}-lock', parameters('level'))]` | The name of the lock. |
| `notes` | string | `[if(equals(parameters('level'), 'CanNotDelete'), 'Cannot delete resource or child resources.', 'Cannot modify the resource or child resources.')]` | The decription attached to the lock. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the lock. |
| `resourceGroupName` | string | The name of the resource group name the lock was applied to. |
| `resourceId` | string | The resource ID of the lock. |
| `scope` | string | The scope this lock applies to. |

## Cross-referenced modules

_None_
