# Network NetworkManagers ScopeConnections `[Microsoft.Network/networkManagers/scopeConnections]`

This module deploys Network NetworkManagers ScopeConnections.
Create a cross-tenant connection to manage a resource from another tenant.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/scopeConnections` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers/scopeConnections) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the scope connection. |
| `resourceId` | string | Enter the subscription or management group resource ID that you want to add to this network manager's scope. |
| `tenantId` | string | Tenant ID of the subscription or management group that you want to manage. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `networkManagerName` | string | The name of the parent network manager. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `description` | string | `''` | A description of the scope connection. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed scope connection. |
| `resourceGroupName` | string | The resource group the scope connection was deployed into. |
| `resourceId` | string | The resource ID of the deployed scope connection. |

## Cross-referenced modules

_None_
