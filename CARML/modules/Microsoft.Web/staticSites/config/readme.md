# Static Site Config `[Microsoft.Web/staticSites/config]`

This module deploys a Static Site Config.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/staticSites/config` | [2022-03-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/staticSites/config) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `kind` | string | `[appsettings, functionappsettings]` | Type of settings to apply. |
| `properties` | object |  | App settings. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `staticSiteName` | string | The name of the parent Static Web App. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the config. |
| `resourceGroupName` | string | The name of the resource group the config was created in. |
| `resourceId` | string | The resource ID of the config. |

## Cross-referenced modules

_None_
