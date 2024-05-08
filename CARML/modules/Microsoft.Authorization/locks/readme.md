# Authorization Locks `[Microsoft.Authorization/locks]`

This module deploys Authorization Locks.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `level` | string | `[CanNotDelete, ReadOnly]` | Set lock level. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[deployment().location]` | Location for all resources. |
| `notes` | string | `[if(equals(parameters('level'), 'CanNotDelete'), 'Cannot delete resource or child resources.', 'Cannot modify the resource or child resources.')]` | The decription attached to the lock. |
| `resourceGroupName` | string | `''` | Name of the Resource Group to assign the lock to. If Resource Group name is provided, and Subscription ID is provided, the module deploys at resource group level, therefore assigns the provided lock to the resource group. |
| `subscriptionId` | string | `[subscription().id]` | Subscription ID of the subscription to assign the lock to. If not provided, will use the current scope for deployment. If no resource group name is provided, the module deploys at subscription level, therefore assigns the provided locks to the subscription. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the lock. |
| `resourceId` | string | The resource ID of the lock. |
| `scope` | string | The scope this lock applies to. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module locks './Microsoft.Authorization/locks/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-alcom'
  params: {
    // Required parameters
    level: 'CanNotDelete'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    resourceGroupName: '<resourceGroupName>'
    subscriptionId: '<subscriptionId>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "level": {
      "value": "CanNotDelete"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    }
  }
}
```

</details>
<p>
