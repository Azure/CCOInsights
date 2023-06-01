# Policy Definitions on Management Group level `[Microsoft.Authorization/policyDefinitions/managementGroup]`

With this module you can create policy definitions on a management group level.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyDefinitions` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-06-01/policyDefinitions) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Specifies the name of the policy definition. Maximum length is 64 characters. |
| `policyRule` | object | The Policy Rule details for the Policy Definition. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `description` | string | `''` |  | The policy definition description. |
| `displayName` | string | `''` |  | The display name of the policy definition. Maximum length is 128 characters. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[deployment().location]` |  | Location deployment metadata. |
| `metadata` | object | `{object}` |  | The policy Definition metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `mode` | string | `'All'` | `[All, Indexed, Microsoft.ContainerService.Data, Microsoft.KeyVault.Data, Microsoft.Kubernetes.Data, Microsoft.Network.Data]` | The policy definition mode. Default is All, Some examples are All, Indexed, Microsoft.KeyVault.Data. |
| `parameters` | object | `{object}` |  | The policy definition parameters that can be used in policy definition references. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Definition Name. |
| `resourceId` | string | Policy Definition resource ID. |
| `roleDefinitionIds` | array | Policy Definition Role Definition IDs. |

## Cross-referenced modules

_None_
