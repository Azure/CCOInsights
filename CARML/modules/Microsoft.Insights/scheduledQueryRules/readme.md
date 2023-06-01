# Scheduled Query Rules `[Microsoft.Insights/scheduledQueryRules]`

This module deploys a scheduled query rule.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/scheduledQueryRules` | [2021-02-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-02-01-preview/scheduledQueryRules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `criterias` | object | The rule criteria that defines the conditions of the scheduled query rule. |
| `name` | string | The name of the Alert. |
| `scopes` | array | The list of resource IDs that this scheduled query rule is scoped to. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `actions` | array | `[]` |  | Actions to invoke when the alert fires. |
| `alertDescription` | string | `''` |  | The description of the scheduled query rule. |
| `autoMitigate` | bool | `True` |  | The flag that indicates whether the alert should be automatically resolved or not. Relevant only for rules of the kind LogAlert. |
| `enabled` | bool | `True` |  | The flag which indicates whether this scheduled query rule is enabled. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `evaluationFrequency` | string | `''` |  | How often the scheduled query rule is evaluated represented in ISO 8601 duration format. Relevant and required only for rules of the kind LogAlert. |
| `kind` | string | `'LogAlert'` | `[LogAlert, LogToMetric]` | Indicates the type of scheduled query rule. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `queryTimeRange` | string | `''` |  | If specified (in ISO 8601 duration format) then overrides the query time range. Relevant only for rules of the kind LogAlert. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `severity` | int | `3` | `[0, 1, 2, 3, 4]` | Severity of the alert. Should be an integer between [0-4]. Value of 0 is severest. Relevant and required only for rules of the kind LogAlert. |
| `skipQueryValidation` | bool | `False` |  | The flag which indicates whether the provided query should be validated or not. Relevant only for rules of the kind LogAlert. |
| `suppressForMinutes` | string | `''` |  | Mute actions for the chosen period of time (in ISO 8601 duration format) after the alert is fired. If set, autoMitigate must be disabled.Relevant only for rules of the kind LogAlert. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `targetResourceTypes` | array | `[]` |  | List of resource type of the target resource(s) on which the alert is created/updated. For example if the scope is a resource group and targetResourceTypes is Microsoft.Compute/virtualMachines, then a different alert will be fired for each virtual machine in the resource group which meet the alert criteria. Relevant only for rules of the kind LogAlert. |
| `windowSize` | string | `''` |  | The period of time (in ISO 8601 duration format) on which the Alert query will be executed (bin size). Relevant and required only for rules of the kind LogAlert. |


### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Reader'
        description: 'Reader Role Assignment'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
        ]
        principalType: 'ServicePrincipal'
    }
]
```

</details>
<p>

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
| `name` | string | The Name of the created query rule. |
| `resourceGroupName` | string | The Resource Group of the created query rule. |
| `resourceId` | string | The resource ID of the created query rule. |

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
module scheduledQueryRules './Microsoft.Insights/scheduledQueryRules/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-isqrcom'
  params: {
    // Required parameters
    criterias: {
      allOf: [
        {
          dimensions: [
            {
              name: 'Computer'
              operator: 'Include'
              values: [
                '*'
              ]
            }
            {
              name: 'InstanceName'
              operator: 'Include'
              values: [
                '*'
              ]
            }
          ]
          metricMeasureColumn: 'AggregatedValue'
          operator: 'GreaterThan'
          query: 'Perf | where ObjectName == \'LogicalDisk\' | where CounterName == \'% Free Space\' | where InstanceName <> \'HarddiskVolume1\' and InstanceName <> \'_Total\' | summarize AggregatedValue = min(CounterValue) by Computer InstanceName bin(TimeGenerated5m)'
          threshold: 0
          timeAggregation: 'Average'
        }
      ]
    }
    name: '<<namePrefix>>isqrcom001'
    scopes: [
      '<logAnalyticsWorkspaceResourceId>'
    ]
    // Non-required parameters
    alertDescription: 'My sample Alert'
    autoMitigate: false
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    evaluationFrequency: 'PT5M'
    queryTimeRange: 'PT5M'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    suppressForMinutes: 'PT5M'
    windowSize: 'PT5M'
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
    "criterias": {
      "value": {
        "allOf": [
          {
            "dimensions": [
              {
                "name": "Computer",
                "operator": "Include",
                "values": [
                  "*"
                ]
              },
              {
                "name": "InstanceName",
                "operator": "Include",
                "values": [
                  "*"
                ]
              }
            ],
            "metricMeasureColumn": "AggregatedValue",
            "operator": "GreaterThan",
            "query": "Perf | where ObjectName == \"LogicalDisk\" | where CounterName == \"% Free Space\" | where InstanceName <> \"HarddiskVolume1\" and InstanceName <> \"_Total\" | summarize AggregatedValue = min(CounterValue) by Computer, InstanceName, bin(TimeGenerated,5m)",
            "threshold": 0,
            "timeAggregation": "Average"
          }
        ]
      }
    },
    "name": {
      "value": "<<namePrefix>>isqrcom001"
    },
    "scopes": {
      "value": [
        "<logAnalyticsWorkspaceResourceId>"
      ]
    },
    // Non-required parameters
    "alertDescription": {
      "value": "My sample Alert"
    },
    "autoMitigate": {
      "value": false
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "evaluationFrequency": {
      "value": "PT5M"
    },
    "queryTimeRange": {
      "value": "PT5M"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "suppressForMinutes": {
      "value": "PT5M"
    },
    "windowSize": {
      "value": "PT5M"
    }
  }
}
```

</details>
<p>
