# Policy Exemptions on Subscription level `[Microsoft.Authorization/policyExemptions/subscription]`

With this module you can create policy exemptions on a subscription level.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyExemptions` | [2022-07-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-07-01-preview/policyExemptions) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Specifies the name of the policy exemption. Maximum length is 64 characters for subscription scope. |
| `policyAssignmentId` | string | The resource ID of the policy assignment that is being exempted. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `assignmentScopeValidation` | string | `''` | `['', Default, DoNotValidate]` | The option whether validate the exemption is at or under the assignment scope. |
| `description` | string | `''` |  | The description of the policy exemption. |
| `displayName` | string | `''` |  | The display name of the policy exemption. Maximum length is 128 characters. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `exemptionCategory` | string | `'Mitigated'` | `[Mitigated, Waiver]` | The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated. |
| `expiresOn` | string | `''` |  | The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z. |
| `location` | string | `[deployment().location]` |  | Location deployment metadata. |
| `metadata` | object | `{object}` |  | The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `policyDefinitionReferenceIds` | array | `[]` |  | The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition. |
| `resourceSelectors` | array | `[]` |  | The resource selector list to filter policies by resource properties. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Exemption Name. |
| `resourceId` | string | Policy Exemption resource ID. |
| `scope` | string | Policy Exemption Scope. |

## Cross-referenced modules

_None_
