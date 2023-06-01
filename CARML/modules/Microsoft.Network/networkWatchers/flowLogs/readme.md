# NSG Flow Logs `[Microsoft.Network/networkWatchers/flowLogs]`

This module controls the Network Security Group Flow Logs and analytics settings
**Note: this module must be run on the Resource Group where Network Watcher is deployed**

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkWatchers/flowLogs` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/networkWatchers/flowLogs) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `storageId` | string | Resource ID of the diagnostic storage account. |
| `targetResourceId` | string | Resource ID of the NSG that must be enabled for Flow Logs. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enabled` | bool | `True` |  | If the flow log should be enabled. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `formatVersion` | int | `2` | `[1, 2]` | The flow log format version. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `name` | string | `[format('{0}-{1}-flowlog', last(split(parameters('targetResourceId'), '/')), split(parameters('targetResourceId'), '/')[4])]` |  | Name of the resource. |
| `networkWatcherName` | string | `[format('NetworkWatcher_{0}', resourceGroup().location)]` |  | Name of the network watcher resource. Must be in the resource group where the Flow log will be created and same region as the NSG. |
| `retentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `trafficAnalyticsInterval` | int | `60` | `[10, 60]` | The interval in minutes which would decide how frequently TA service should do flow analytics. |
| `workspaceResourceId` | string | `''` |  | Specify the Log Analytics Workspace Resource ID. |


### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the flow log. |
| `resourceGroupName` | string | The resource group the flow log was deployed into. |
| `resourceId` | string | The resource ID of the flow log. |

## Cross-referenced modules

_None_
