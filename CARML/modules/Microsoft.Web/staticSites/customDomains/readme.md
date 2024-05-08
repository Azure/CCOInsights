# Static Site Custom Domain `[Microsoft.Web/staticSites/customDomains]`

This module deploys a Custom Domain into a Static Site.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/staticSites/customDomains` | [2022-03-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-03-01/staticSites/customDomains) |

## Parameters

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The custom domain name. Required if the template is used in a standalone deployment. |
| `staticSiteName` | string | The name of the parent Static Web App. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |
| `validationMethod` | string | `'cname-delegation'` | Validation method for adding a custom domain. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the static site custom domain. |
| `resourceGroupName` | string | The resource group the static site custom domain was deployed into. |
| `resourceId` | string | The resource ID of the static site custom domain. |

## Cross-referenced modules

_None_
