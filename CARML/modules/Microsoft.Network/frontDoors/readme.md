# Front Doors `[Microsoft.Network/frontDoors]`

This module deploys Front Doors.


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
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/frontDoors` | [2020-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-05-01/frontDoors) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `backendPools` | array | Backend address pool of the frontdoor resource. |
| `frontendEndpoints` | array | Frontend endpoints of the frontdoor resource. |
| `healthProbeSettings` | array | Heath probe settings of the frontdoor resource. |
| `loadBalancingSettings` | array | Load balancing settings of the frontdoor resource. |
| `name` | string | The name of the frontDoor. |
| `routingRules` | array | Routing rules settings of the frontdoor resource. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, FrontdoorAccessLog, FrontdoorWebApplicationFirewallLog]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enabledState` | string | `'Enabled'` |  | State of the frontdoor resource. |
| `enforceCertificateNameCheck` | string | `'Disabled'` |  | Enforce certificate name check of the frontdoor resource. |
| `friendlyName` | string | `''` |  | Friendly name of the frontdoor resource. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `sendRecvTimeoutSeconds` | int | `240` |  | Certificate name check time of the frontdoor resource. |
| `tags` | object | `{object}` |  | Resource tags. |


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
| `name` | string | The name of the front door. |
| `resourceGroupName` | string | The resource group the front door was deployed into. |
| `resourceId` | string | The resource ID of the front door. |

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
module frontDoors './Microsoft.Network/frontDoors/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nfdcom'
  params: {
    // Required parameters
    backendPools: [
      {
        name: 'backendPool'
        properties: {
          backends: [
            {
              address: 'biceptest.local'
              backendHostHeader: 'backendAddress'
              enabledState: 'Enabled'
              httpPort: 80
              httpsPort: 443
              priority: 1
              privateLinkAlias: ''
              privateLinkApprovalMessage: ''
              privateLinkLocation: ''
              privateLinkResourceId: ''
              weight: 50
            }
          ]
          HealthProbeSettings: {
            id: '<id>'
          }
          LoadBalancingSettings: {
            id: '<id>'
          }
        }
      }
    ]
    frontendEndpoints: [
      {
        name: 'frontEnd'
        properties: {
          hostName: '<hostName>'
          sessionAffinityEnabledState: 'Disabled'
          sessionAffinityTtlSeconds: 60
        }
      }
    ]
    healthProbeSettings: [
      {
        name: 'heathProbe'
        properties: {
          enabledState: ''
          healthProbeMethod: ''
          intervalInSeconds: 60
          path: '/'
          protocol: 'Https'
        }
      }
    ]
    loadBalancingSettings: [
      {
        name: 'loadBalancer'
        properties: {
          additionalLatencyMilliseconds: 0
          sampleSize: 50
          successfulSamplesRequired: 1
        }
      }
    ]
    name: '<name>'
    routingRules: [
      {
        name: 'routingRule'
        properties: {
          acceptedProtocols: [
            'Http'
            'Https'
          ]
          enabledState: 'Enabled'
          frontendEndpoints: [
            {
              id: '<id>'
            }
          ]
          patternsToMatch: [
            '/*'
          ]
          routeConfiguration: {
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
            backendPool: {
              id: '<id>'
            }
            forwardingProtocol: 'MatchRequest'
          }
        }
      }
    ]
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enforceCertificateNameCheck: 'Disabled'
    lock: 'CanNotDelete'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    sendRecvTimeoutSeconds: 10
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
    "backendPools": {
      "value": [
        {
          "name": "backendPool",
          "properties": {
            "backends": [
              {
                "address": "biceptest.local",
                "backendHostHeader": "backendAddress",
                "enabledState": "Enabled",
                "httpPort": 80,
                "httpsPort": 443,
                "priority": 1,
                "privateLinkAlias": "",
                "privateLinkApprovalMessage": "",
                "privateLinkLocation": "",
                "privateLinkResourceId": "",
                "weight": 50
              }
            ],
            "HealthProbeSettings": {
              "id": "<id>"
            },
            "LoadBalancingSettings": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "frontendEndpoints": {
      "value": [
        {
          "name": "frontEnd",
          "properties": {
            "hostName": "<hostName>",
            "sessionAffinityEnabledState": "Disabled",
            "sessionAffinityTtlSeconds": 60
          }
        }
      ]
    },
    "healthProbeSettings": {
      "value": [
        {
          "name": "heathProbe",
          "properties": {
            "enabledState": "",
            "healthProbeMethod": "",
            "intervalInSeconds": 60,
            "path": "/",
            "protocol": "Https"
          }
        }
      ]
    },
    "loadBalancingSettings": {
      "value": [
        {
          "name": "loadBalancer",
          "properties": {
            "additionalLatencyMilliseconds": 0,
            "sampleSize": 50,
            "successfulSamplesRequired": 1
          }
        }
      ]
    },
    "name": {
      "value": "<name>"
    },
    "routingRules": {
      "value": [
        {
          "name": "routingRule",
          "properties": {
            "acceptedProtocols": [
              "Http",
              "Https"
            ],
            "enabledState": "Enabled",
            "frontendEndpoints": [
              {
                "id": "<id>"
              }
            ],
            "patternsToMatch": [
              "/*"
            ],
            "routeConfiguration": {
              "@odata.type": "#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration",
              "backendPool": {
                "id": "<id>"
              },
              "forwardingProtocol": "MatchRequest"
            }
          }
        }
      ]
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enforceCertificateNameCheck": {
      "value": "Disabled"
    },
    "lock": {
      "value": "CanNotDelete"
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
    "sendRecvTimeoutSeconds": {
      "value": 10
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
module frontDoors './Microsoft.Network/frontDoors/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nfdmin'
  params: {
    // Required parameters
    backendPools: [
      {
        name: 'backendPool'
        properties: {
          backends: [
            {
              address: 'biceptest.local'
              backendHostHeader: 'backendAddress'
              enabledState: 'Enabled'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 50
            }
          ]
          HealthProbeSettings: {
            id: '<id>'
          }
          LoadBalancingSettings: {
            id: '<id>'
          }
        }
      }
    ]
    frontendEndpoints: [
      {
        name: 'frontEnd'
        properties: {
          hostName: '<hostName>'
          sessionAffinityEnabledState: 'Disabled'
          sessionAffinityTtlSeconds: 60
        }
      }
    ]
    healthProbeSettings: [
      {
        name: 'heathProbe'
        properties: {
          intervalInSeconds: 60
          path: '/'
          protocol: 'Https'
        }
      }
    ]
    loadBalancingSettings: [
      {
        name: 'loadBalancer'
        properties: {
          additionalLatencyMilliseconds: 0
          sampleSize: 50
          successfulSamplesRequired: 1
        }
      }
    ]
    name: '<name>'
    routingRules: [
      {
        name: 'routingRule'
        properties: {
          acceptedProtocols: [
            'Https'
          ]
          enabledState: 'Enabled'
          frontendEndpoints: [
            {
              id: '<id>'
            }
          ]
          patternsToMatch: [
            '/*'
          ]
          routeConfiguration: {
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
            backendPool: {
              id: '<id>'
            }
          }
        }
      }
    ]
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    "backendPools": {
      "value": [
        {
          "name": "backendPool",
          "properties": {
            "backends": [
              {
                "address": "biceptest.local",
                "backendHostHeader": "backendAddress",
                "enabledState": "Enabled",
                "httpPort": 80,
                "httpsPort": 443,
                "priority": 1,
                "weight": 50
              }
            ],
            "HealthProbeSettings": {
              "id": "<id>"
            },
            "LoadBalancingSettings": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "frontendEndpoints": {
      "value": [
        {
          "name": "frontEnd",
          "properties": {
            "hostName": "<hostName>",
            "sessionAffinityEnabledState": "Disabled",
            "sessionAffinityTtlSeconds": 60
          }
        }
      ]
    },
    "healthProbeSettings": {
      "value": [
        {
          "name": "heathProbe",
          "properties": {
            "intervalInSeconds": 60,
            "path": "/",
            "protocol": "Https"
          }
        }
      ]
    },
    "loadBalancingSettings": {
      "value": [
        {
          "name": "loadBalancer",
          "properties": {
            "additionalLatencyMilliseconds": 0,
            "sampleSize": 50,
            "successfulSamplesRequired": 1
          }
        }
      ]
    },
    "name": {
      "value": "<name>"
    },
    "routingRules": {
      "value": [
        {
          "name": "routingRule",
          "properties": {
            "acceptedProtocols": [
              "Https"
            ],
            "enabledState": "Enabled",
            "frontendEndpoints": [
              {
                "id": "<id>"
              }
            ],
            "patternsToMatch": [
              "/*"
            ],
            "routeConfiguration": {
              "@odata.type": "#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration",
              "backendPool": {
                "id": "<id>"
              }
            }
          }
        }
      ]
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>
