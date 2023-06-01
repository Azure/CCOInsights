# Network Firewall Policies Rule Collection Groups `[Microsoft.Network/firewallPolicies/ruleCollectionGroups]`

This module deploys Network Firewall Policies Rule Collection Groups.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/firewallPolicies/ruleCollectionGroups` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/firewallPolicies/ruleCollectionGroups) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the rule collection group to deploy. |
| `priority` | int | Priority of the Firewall Policy Rule Collection Group resource. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `firewallPolicyName` | string | The name of the parent Firewall Policy. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `ruleCollections` | array | `[]` | Group of Firewall Policy rule collections. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed rule collection group. |
| `resourceGroupName` | string | The resource group of the deployed rule collection group. |
| `resourceId` | string | The resource ID of the deployed rule collection group. |

## Cross-referenced modules

_None_
