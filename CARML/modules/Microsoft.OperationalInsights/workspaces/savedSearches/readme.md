# Operationalinsights Workspaces Saved Searches `[Microsoft.OperationalInsights/workspaces/savedSearches]`

This template deploys a saved search for a Log Analytics workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | [2020-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/savedSearches) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `category` | string | Query category. |
| `displayName` | string | Display name for the search. |
| `name` | string | Name of the saved search. |
| `query` | string | Kusto Query to be stored. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `logAnalyticsWorkspaceName` | string | The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `etag` | string | `'*'` | The ETag of the saved search. To override an existing saved search, use "*" or specify the current Etag. |
| `functionAlias` | string | `''` | The function alias if query serves as a function. |
| `functionParameters` | string | `''` | The optional function parameters if query serves as a function. Value should be in the following format: "param-name1:type1 = default_value1, param-name2:type2 = default_value2". For more examples and proper syntax please refer to /azure/kusto/query/functions/user-defined-functions. |
| `tags` | array | `[]` | Tags to configure in the resource. |
| `version` | int | `2` | The version number of the query language. |


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
| `name` | string | The name of the deployed saved search. |
| `resourceGroupName` | string | The resource group where the saved search is deployed. |
| `resourceId` | string | The resource ID of the deployed saved search. |

## Cross-referenced modules

_None_
