# Blob Container Immutability Policy `[Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies]`

This module deploys an Immutability Policy for a blob container

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2021-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |

## Parameters

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `blobServicesName` | string | `'default'` | The name of the parent blob service. Required if the template is used in a standalone deployment. |
| `containerName` | string |  | The name of the parent container to apply the policy to. Required if the template is used in a standalone deployment. |
| `storageAccountName` | string |  | The name of the parent Storage Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `allowProtectedAppendWrites` | bool | `True` | This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `immutabilityPeriodSinceCreationInDays` | int | `365` | The immutability period for the blobs in the container since the policy creation, in days. |
| `name` | string | `'default'` | Name of the immutable policy. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed immutability policy. |
| `resourceGroupName` | string | The resource group of the deployed immutability policy. |
| `resourceId` | string | The resource ID of the deployed immutability policy. |

## Cross-referenced modules

_None_
