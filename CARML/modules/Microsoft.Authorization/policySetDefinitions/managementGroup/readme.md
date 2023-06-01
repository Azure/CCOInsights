# Policy Set Definitions on Management Group level `[Microsoft.Authorization/policySetDefinitions/managementGroup]`

With this module you can create policy set definitions on a management group level.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policySetDefinitions` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-06-01/policySetDefinitions) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Specifies the name of the policy Set Definition (Initiative). |
| `policyDefinitions` | array | The array of Policy definitions object to include for this policy set. Each object must include the Policy definition ID, and optionally other properties like parameters. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `description` | string | `''` | The description name of the Set Definition (Initiative). |
| `displayName` | string | `''` | The display name of the Set Definition (Initiative). Maximum length is 128 characters. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[deployment().location]` | Location deployment metadata. |
| `metadata` | object | `{object}` | The Set Definition (Initiative) metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `parameters` | object | `{object}` | The Set Definition (Initiative) parameters that can be used in policy definition references. |
| `policyDefinitionGroups` | array | `[]` | The metadata describing groups of policy definition references within the Policy Set Definition (Initiative). |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Set Definition Name. |
| `resourceId` | string | Policy Set Definition resource ID. |

## Cross-referenced modules

_None_
