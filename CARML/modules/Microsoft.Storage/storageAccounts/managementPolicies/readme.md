# Storage Account Management Policies `[Microsoft.Storage/storageAccounts/managementPolicies]`

This module can be used to deploy a management policies into a storage account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/managementPolicies` | [2021-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/managementPolicies) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `rules` | array | The Storage Account ManagementPolicies Rules. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `storageAccountName` | string | The name of the parent Storage Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `name` | string | `'default'` | The name of the storage container to deploy. |


### Parameter Usage: `rules`

<details>

<summary>Parameter JSON format</summary>

```json
"rules": {
    "value": [
        {
            "enabled": true,
            "name": "retention-policy",
            "type": "Lifecycle",
            "definition": {
                "actions": {
                    "baseBlob": {
                        "tierToArchive": {
                            "daysAfterModificationGreaterThan": 30
                        },
                        "delete": {
                            "daysAfterModificationGreaterThan": 1096
                        }
                    },
                    "snapshot": {
                        "delete": {
                            "daysAfterCreationGreaterThan": 1096
                        }
                    }
                },
                "filters": {
                    "blobTypes": [
                        "blockBlob"
                    ]
                }
            }
        }
    ]
}
```
</details>


<details>

<summary>Bicep format</summary>

```bicep
rules: [
    {
        enabled: true
        name: 'retention-policy'
        type: 'Lifecycle'
        definition: {
            actions: {
                baseBlob: {
                    tierToArchive: {
                        daysAfterModificationGreaterThan: 30
                    }
                    delete: {
                        daysAfterModificationGreaterThan: 1096
                    }
                }
                snapshot: {
                    delete: {
                        daysAfterCreationGreaterThan: 1096
                    }
                }
            }
            filters: {
                blobTypes: [
                    'blockBlob'
                ]
            }
        }
    }
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed management policy. |
| `resourceGroupName` | string | The resource group of the deployed management policy. |
| `resourceId` | string | The resource ID of the deployed management policy. |

## Cross-referenced modules

_None_
