# StorageAccounts LocalUsers `[Microsoft.Storage/storageAccounts/localUsers]`

This module deploys LocalUsers used for SFTP authentication.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/localUsers` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-05-01/storageAccounts/localUsers) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `hasSshKey` | bool | Indicates whether SSH key exists. Set it to false to remove existing SSH key. |
| `hasSshPassword` | bool | Indicates whether SSH password exists. Set it to false to remove existing SSH password. |
| `name` | string | The name of the local user used for SFTP Authentication. |
| `permissionScopes` | array | The permission scopes of the local user. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `storageAccountName` | string | The name of the parent Storage Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `hasSharedKey` | bool | `False` | Indicates whether shared key exists. Set it to false to remove existing shared key. |
| `homeDirectory` | string | `''` | The local user home directory. |
| `sshAuthorizedKeys` | array | `[]` | The local user SSH authorized keys for SFTP. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed local user. |
| `resourceGroupName` | string | The resource group of the deployed local user. |
| `resourceId` | string | The resource ID of the deployed local user. |

## Cross-referenced modules

_None_
