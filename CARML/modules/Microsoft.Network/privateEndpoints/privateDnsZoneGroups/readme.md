# Network Private Endpoint Private DNS Zone Group `[Microsoft.Network/privateEndpoints/privateDnsZoneGroups]`

This module deploys a private endpoint private DNS zone group

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-05-01/privateEndpoints/privateDnsZoneGroups) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `privateDNSResourceIds` | array | Array of private DNS zone resource IDs. A DNS zone group can support up to 5 DNS zones. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `privateEndpointName` | string | The name of the parent private endpoint. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `name` | string | `'default'` | The name of the private DNS zone group. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the private endpoint DNS zone group. |
| `resourceGroupName` | string | The resource group the private endpoint DNS zone group was deployed into. |
| `resourceId` | string | The resource ID of the private endpoint DNS zone group. |

## Cross-referenced modules

_None_
