# Policy Assignment on Management Group level `[Microsoft.Authorization/policyAssignments/managementGroup]`

With this module you can perform policy assignments on a management group level.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyAssignments` | [2022-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-06-01/policyAssignments) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Specifies the name of the policy assignment. Maximum length is 24 characters for management group scope. |
| `policyDefinitionId` | string | Specifies the ID of the policy definition or policy set definition being assigned. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `description` | string | `''` |  | This message will be part of response in case of policy violation. |
| `displayName` | string | `''` |  | The display name of the policy assignment. Maximum length is 128 characters. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enforcementMode` | string | `'Default'` | `[Default, DoNotEnforce]` | The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce. |
| `identity` | string | `'SystemAssigned'` | `[None, SystemAssigned, UserAssigned]` | The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning 'Modify' policy definitions. |
| `location` | string | `[deployment().location]` |  | Location for all resources. |
| `managementGroupId` | string | `[managementGroup().name]` |  | The Target Scope for the Policy. The name of the management group for the policy assignment. If not provided, will use the current scope for deployment. |
| `metadata` | object | `{object}` |  | The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `nonComplianceMessages` | array | `[]` |  | The messages that describe why a resource is non-compliant with the policy. |
| `notScopes` | array | `[]` |  | The policy excluded scopes. |
| `overrides` | array | `[]` |  | The policy property value override. Allows changing the effect of a policy definition without modifying the underlying policy definition or using a parameterized effect in the policy definition. |
| `parameters` | object | `{object}` |  | Parameters for the policy assignment if needed. |
| `resourceSelectors` | array | `[]` |  | The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out policy assignments based on factors like resource location, resource type, or whether a resource has a location. |
| `roleDefinitionIds` | array | `[]` |  | The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.. See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition. |
| `userAssignedIdentityId` | string | `''` |  | The Resource ID for the user assigned identity to assign to the policy assignment. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | Policy Assignment Name. |
| `principalId` | string | Policy Assignment principal ID. |
| `resourceId` | string | Policy Assignment resource ID. |

## Cross-referenced modules

_None_
