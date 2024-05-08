# Network NetworkManagers SecurityAdminConfigurations RuleCollections `[Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections]`

This module deploys Network NetworkManagers SecurityAdminConfigurations RuleCollections.
A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules. Security admin rules allows enforcing security policy criteria that matches the conditions set. Warning: A rule collection without rule will cause a deployment configuration for security admin goal state in network manager to fail.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers/securityAdminConfigurations/ruleCollections) |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers/securityAdminConfigurations/ruleCollections/rules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `appliesToGroups` | array | List of network groups for configuration. An admin rule collection must be associated to at least one network group. |
| `name` | string | The name of the admin rule collection. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `networkManagerName` | string | The name of the parent network manager. Required if the template is used in a standalone deployment. |
| `securityAdminConfigurationName` | string | The name of the parent security admin configuration. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `description` | string | `''` | A description of the admin rule collection. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `rules` | _[rules](rules/readme.md)_ array |  | List of rules for the admin rules collection. Security admin rules allows enforcing security policy criteria that matches the conditions set. Warning: A rule collection without rule will cause a deployment configuration for security admin goal state in network manager to fail. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed admin rule collection. |
| `resourceGroupName` | string | The resource group the admin rule collection was deployed into. |
| `resourceId` | string | The resource ID of the deployed admin rule collection. |

## Cross-referenced modules

_None_
