# Network NetworkManagers SecurityAdminConfigurations `[Microsoft.Network/networkManagers/securityAdminConfigurations]`

This module deploys Network NetworkManagers SecurityAdminConfigurations.
A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/securityAdminConfigurations` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers/securityAdminConfigurations) |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers/securityAdminConfigurations/ruleCollections) |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers/securityAdminConfigurations/ruleCollections/rules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `applyOnNetworkIntentPolicyBasedServices` | array | `[None]` | `[All, AllowRulesOnly, None]` | Enum list of network intent policy based services. |
| `name` | string |  |  | The name of the security admin configuration. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `networkManagerName` | string | The name of the parent network manager. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `description` | string | `''` | A description of the security admin configuration. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `ruleCollections` | _[ruleCollections](ruleCollections/readme.md)_ array | `[]` | A security admin configuration contains a set of rule collections that are applied to network groups. Each rule collection contains one or more security admin rules. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed security admin configuration. |
| `resourceGroupName` | string | The resource group the security admin configuration was deployed into. |
| `resourceId` | string | The resource ID of the deployed security admin configuration. |

## Cross-referenced modules

_None_
