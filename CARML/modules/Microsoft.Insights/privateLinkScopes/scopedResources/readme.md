# Insights PrivateLinkScopes ScopedResources `[Microsoft.Insights/privateLinkScopes/scopedResources]`

This module deploys Insights PrivateLinkScopes ScopedResources.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Insights/privateLinkScopes/scopedResources` | [2021-07-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-07-01-preview/privateLinkScopes/scopedResources) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `linkedResourceId` | string | The resource ID of the scoped Azure monitor resource. |
| `name` | string | Name of the private link scoped resource. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `privateLinkScopeName` | string | The name of the parent private link scope. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The full name of the deployed Scoped Resource. |
| `resourceGroupName` | string | The name of the resource group where the resource has been deployed. |
| `resourceId` | string | The resource ID of the deployed scopedResource. |

## Cross-referenced modules

_None_
