# Operational Insights Workspaces Linked Storage Accounts `[Microsoft.OperationalInsights/workspaces/linkedStorageAccounts]`

This template deploys a linked Storage Accounts for a Log Analytics workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | [2020-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedStorageAccounts) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `name` | string | `[Alerts, AzureWatson, CustomLogs, Query]` | Name of the link. |
| `resourceId` | string |  | The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require read access. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `logAnalyticsWorkspaceName` | string | The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed linked storage account. |
| `resourceGroupName` | string | The resource group where the linked storage account is deployed. |
| `resourceId` | string | The resource ID of the deployed linked storage account. |

## Cross-referenced modules

_None_
