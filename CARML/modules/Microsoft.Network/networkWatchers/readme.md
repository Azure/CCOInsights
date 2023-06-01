# Network Watchers `[Microsoft.Network/networkWatchers]`

- This template deploys a network watcher.
- Network Watcher is a default resource which will get created automatically in every region where a virtual network is present with in the network watcher resource group.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Network/networkWatchers` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/networkWatchers) |
| `Microsoft.Network/networkWatchers/connectionMonitors` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/networkWatchers/connectionMonitors) |
| `Microsoft.Network/networkWatchers/flowLogs` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/networkWatchers/flowLogs) |

## Parameters

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `connectionMonitors` | _[connectionMonitors](connectionMonitors/readme.md)_ array | `[]` |  | Array that contains the Connection Monitors. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `flowLogs` | _[flowLogs](flowLogs/readme.md)_ array | `[]` |  | Array that contains the Flow Logs. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `name` | string | `[format('NetworkWatcher_{0}', parameters('location'))]` |  | Name of the Network Watcher resource (hidden). |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags of the resource. |


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
| `name` | string | The name of the deployed network watcher. |
| `resourceGroupName` | string | The resource group the network watcher was deployed into. |
| `resourceId` | string | The resource ID of the deployed network watcher. |

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
module networkWatchers './Microsoft.Network/networkWatchers/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nnwcom'
  params: {
    connectionMonitors: [
      {
        endpoints: [
          {
            name: '<name>'
            resourceId: '<resourceId>'
            type: 'AzureVM'
          }
          {
            address: 'www.office.com'
            name: 'Office Portal'
            type: 'ExternalAddress'
          }
        ]
        name: '<<namePrefix>>-nnwcom-cm-001'
        testConfigurations: [
          {
            httpConfiguration: {
              method: 'Get'
              port: 80
              preferHTTPS: false
              requestHeaders: []
              validStatusCodeRanges: [
                '200'
              ]
            }
            name: 'HTTP Test'
            protocol: 'Http'
            successThreshold: {
              checksFailedPercent: 5
              roundTripTimeMs: 100
            }
            testFrequencySec: 30
          }
        ]
        testGroups: [
          {
            destinations: [
              'Office Portal'
            ]
            disable: false
            name: 'TestHTTPBing'
            sources: [
              '<<namePrefix>>-subnet-001(${resourceGroup.name})'
            ]
            testConfigurations: [
              'HTTP Test'
            ]
          }
        ]
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    flowLogs: [
      {
        enabled: false
        storageId: '<storageId>'
        targetResourceId: '<targetResourceId>'
      }
      {
        formatVersion: 1
        name: '<<namePrefix>>-nnwcom-fl-001'
        retentionInDays: 8
        storageId: '<storageId>'
        targetResourceId: '<targetResourceId>'
        trafficAnalyticsInterval: 10
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    location: '<location>'
    name: '<name>'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
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
    "connectionMonitors": {
      "value": [
        {
          "endpoints": [
            {
              "name": "<name>",
              "resourceId": "<resourceId>",
              "type": "AzureVM"
            },
            {
              "address": "www.office.com",
              "name": "Office Portal",
              "type": "ExternalAddress"
            }
          ],
          "name": "<<namePrefix>>-nnwcom-cm-001",
          "testConfigurations": [
            {
              "httpConfiguration": {
                "method": "Get",
                "port": 80,
                "preferHTTPS": false,
                "requestHeaders": [],
                "validStatusCodeRanges": [
                  "200"
                ]
              },
              "name": "HTTP Test",
              "protocol": "Http",
              "successThreshold": {
                "checksFailedPercent": 5,
                "roundTripTimeMs": 100
              },
              "testFrequencySec": 30
            }
          ],
          "testGroups": [
            {
              "destinations": [
                "Office Portal"
              ],
              "disable": false,
              "name": "TestHTTPBing",
              "sources": [
                "<<namePrefix>>-subnet-001(${resourceGroup.name})"
              ],
              "testConfigurations": [
                "HTTP Test"
              ]
            }
          ],
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "flowLogs": {
      "value": [
        {
          "enabled": false,
          "storageId": "<storageId>",
          "targetResourceId": "<targetResourceId>"
        },
        {
          "formatVersion": 1,
          "name": "<<namePrefix>>-nnwcom-fl-001",
          "retentionInDays": 8,
          "storageId": "<storageId>",
          "targetResourceId": "<targetResourceId>",
          "trafficAnalyticsInterval": 10,
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "name": {
      "value": "<name>"
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
    }
  }
}
```

</details>
<p>

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module networkWatchers './Microsoft.Network/networkWatchers/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nnwmin'
  params: {
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    location: '<location>'
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>
