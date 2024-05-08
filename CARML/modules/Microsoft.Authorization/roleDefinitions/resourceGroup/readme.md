# Role Definitions on Resource Group level `[Microsoft.Authorization/roleDefinitions/resourceGroup]`

With this module you can create role definitions on a resource group level

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleDefinitions` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleDefinitions) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `roleName` | string | Name of the custom RBAC role to be created. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `actions` | array | `[]` | List of allowed actions. |
| `assignableScopes` | array | `[]` | Role definition assignable scopes. If not provided, will use the current scope provided. |
| `dataActions` | array | `[]` | List of allowed data actions. This is not supported if the assignableScopes contains Management Group Scopes. |
| `description` | string | `''` | Description of the custom RBAC role to be created. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `notActions` | array | `[]` | List of denied actions. |
| `notDataActions` | array | `[]` | List of denied data actions. This is not supported if the assignableScopes contains Management Group Scopes. |
| `resourceGroupName` | string | `[resourceGroup().name]` | The name of the Resource Group where the Role Definition and Target Scope will be applied to. If not provided, will use the current scope for deployment. |
| `subscriptionId` | string | `[subscription().subscriptionId]` | The subscription ID where the Role Definition and Target Scope will be applied to. If not provided, will use the current scope for deployment. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The GUID of the Role Definition. |
| `resourceGroupName` | string | The name of the resource group the role definition was created at. |
| `resourceId` | string | The resource ID of the Role Definition. |
| `scope` | string | The scope this Role Definition applies to. |

## Cross-referenced modules

_None_
