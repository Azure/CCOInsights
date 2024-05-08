# Traffic Manager Profiles `[Microsoft.Network/trafficmanagerprofiles]`

This module deploys a traffic manager profile.

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
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/trafficmanagerprofiles` | [2018-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-08-01/trafficmanagerprofiles) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Traffic Manager. |
| `relativeName` | string | The relative DNS name provided by this Traffic Manager profile. This value is combined with the DNS domain name used by Azure Traffic Manager to form the fully-qualified domain name (FQDN) of the profile. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, ProbeHealthStatusEvents]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `endpoints` | array | `[]` |  | The list of endpoints in the Traffic Manager profile. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `maxReturn` | int | `1` |  | Maximum number of endpoints to be returned for MultiValue routing type. |
| `monitorConfig` | object | `{object}` |  | The endpoint monitoring settings of the Traffic Manager profile. |
| `profileStatus` | string | `'Enabled'` | `[Disabled, Enabled]` | The status of the Traffic Manager profile. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Resource tags. |
| `trafficRoutingMethod` | string | `'Performance'` | `[Geographic, MultiValue, Performance, Priority, Subnet, Weighted]` | The traffic routing method of the Traffic Manager profile. |
| `trafficViewEnrollmentStatus` | string | `'Disabled'` | `[Disabled, Enabled]` | Indicates whether Traffic View is 'Enabled' or 'Disabled' for the Traffic Manager profile. Null, indicates 'Disabled'. Enabling this feature will increase the cost of the Traffic Manage profile. |
| `ttl` | int | `60` |  | The DNS Time-To-Live (TTL), in seconds. This informs the local DNS resolvers and DNS clients how long to cache DNS responses provided by this Traffic Manager profile. |


### Parameter Usage: `monitorConfig`

<details>

<summary>Parameter JSON format</summary>

```json
"monitorConfig": {
    "value": {
        "protocol": "http",
        "port": "80",
        "path": "/"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
monitorConfig: {
    protocol: 'http'
    port: '80'
    path: '/'
}
```

</details>
<p>

### Parameter Usage: `endpoints`

<details>

<summary>Parameter JSON format</summary>

```json
"endpoints": {
    "value": [
        {
            "id": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/<rgname>/providers/Microsoft.Network/trafficManagerProfiles/<tmname>/azureEndpoints/<endpointname>",
            "name": "MyEndpoint001",
            "type": "Microsoft.Network/trafficManagerProfiles/azureEndpoints",
            "properties":
            {
                "endpointStatus": "Enabled",
                "endpointMonitorStatus": "CheckingEndpoint",
                "targetResourceId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/<rgname>/providers/Microsoft.Network/publicIPAddresses/<pipname>",
                "target": "my-pip-001.eastus.cloudapp.azure.com",
                "weight": 1,
                "priority": 1,
                "endpointLocation": "East US"
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
endpoints: [
    {
        id: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/<rgname>/providers/Microsoft.Network/trafficManagerProfiles/<tmname>/azureEndpoints/<endpointname>'
        name: 'MyEndpoint001'
        type: 'Microsoft.Network/trafficManagerProfiles/azureEndpoints'
        properties:
        {
            endpointStatus: 'Enabled'
            endpointMonitorStatus: 'CheckingEndpoint'
            targetResourceId: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/<rgname>/providers/Microsoft.Network/publicIPAddresses/<pipname>'
            target: 'my-pip-001.eastus.cloudapp.azure.com'
            weight: 1
            priority: 1
            endpointLocation: 'East US'
        }
    }
]
```

</details>
<p>

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
| `name` | string | The name of the traffic manager was deployed into. |
| `resourceGroupName` | string | The resource group the traffic manager was deployed into. |
| `resourceId` | string | The resource ID of the traffic manager. |

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
module trafficmanagerprofiles './Microsoft.Network/trafficmanagerprofiles/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-ntmpcom'
  params: {
    // Required parameters
    name: '<name>'
    relativeName: '<relativeName>'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    "name": {
      "value": "<name>"
    },
    "relativeName": {
      "value": "<relativeName>"
    },
    // Non-required parameters
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticLogsRetentionInDays": {
      "value": 7
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
module trafficmanagerprofiles './Microsoft.Network/trafficmanagerprofiles/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-ntmpmin'
  params: {
    // Required parameters
    name: '<name>'
    relativeName: '<relativeName>'
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
    "name": {
      "value": "<name>"
    },
    "relativeName": {
      "value": "<relativeName>"
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
