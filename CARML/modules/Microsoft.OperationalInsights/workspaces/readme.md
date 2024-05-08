# Log Analytics Workspaces `[Microsoft.OperationalInsights/workspaces]`

This template deploys a log analytics workspace.

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
| `Microsoft.OperationalInsights/workspaces` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2021-06-01/workspaces) |
| `Microsoft.OperationalInsights/workspaces/dataSources` | [2020-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataSources) |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2020-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedServices) |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | [2020-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedStorageAccounts) |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | [2020-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/savedSearches) |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | [2020-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/storageInsightConfigs) |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Log Analytics workspace. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `linkedStorageAccounts` | _[linkedStorageAccounts](linkedStorageAccounts/readme.md)_ array | List of Storage Accounts to be linked. Required if 'forceCmkForQuery' is set to 'true' and 'savedSearches' is not empty. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `dailyQuotaGb` | int | `-1` |  | The workspace daily quota for ingestion. |
| `dataRetention` | int | `365` |  | Number of days data will be retained for. |
| `dataSources` | _[dataSources](dataSources/readme.md)_ array | `[]` |  | LAW data sources to configure. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, Audit]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of a log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `forceCmkForQuery` | bool | `True` |  | Indicates whether customer managed storage is mandatory for query management. |
| `gallerySolutions` | array | `[]` |  | List of gallerySolutions to be created in the log analytics workspace. |
| `linkedServices` | _[linkedServices](linkedServices/readme.md)_ array | `[]` |  | List of services to be linked. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `publicNetworkAccessForIngestion` | string | `'Enabled'` | `[Disabled, Enabled]` | The network access type for accessing Log Analytics ingestion. |
| `publicNetworkAccessForQuery` | string | `'Enabled'` | `[Disabled, Enabled]` | The network access type for accessing Log Analytics query. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `savedSearches` | _[savedSearches](savedSearches/readme.md)_ array | `[]` |  | Kusto Query Language searches to save. |
| `serviceTier` | string | `'PerGB2018'` | `[Free, PerGB2018, PerNode, Standalone]` | Service Tier: PerGB2018, Free, Standalone, PerGB or PerNode. |
| `storageInsightsConfigs` | array | `[]` |  | List of storage accounts to be read by the workspace. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `useResourcePermissions` | bool | `False` |  | Set to 'true' to use resource or workspace permissions and 'false' (or leave empty) to require workspace permissions. |


### Parameter Usage: `gallerySolutions`

Ref cross-referenced _[solutions](../../Microsoft.OperationsManagement/solutions/readme.md)_

<details>

<summary>Parameter JSON format</summary>

```json
"gallerySolutions": {
    "value": [
        {
            "name": "AgentHealthAssessment",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "AlertManagement",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "AntiMalware",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "AzureActivity",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "AzureAutomation",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "AzureCdnCoreAnalytics",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "AzureDataFactoryAnalytics",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "AzureNSGAnalytics",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "AzureSQLAnalytics",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "ChangeTracking",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "Containers",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "InfrastructureInsights",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "KeyVaultAnalytics",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "LogicAppsManagement",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "NetworkMonitoring",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "Security",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "SecurityCenterFree",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "ServiceFabric",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "ServiceMap",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "SQLAssessment",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "Updates",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "VMInsights",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "WireData2",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "WaaSUpdateInsights",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
gallerySolutions: [
    {
        name: 'AgentHealthAssessment'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'AlertManagement'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'AntiMalware'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'AzureActivity'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'AzureAutomation'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'AzureCdnCoreAnalytics'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'AzureDataFactoryAnalytics'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'AzureNSGAnalytics'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'AzureSQLAnalytics'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'ChangeTracking'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'Containers'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'InfrastructureInsights'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'KeyVaultAnalytics'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'LogicAppsManagement'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'NetworkMonitoring'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'Security'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'SecurityCenterFree'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'ServiceFabric'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'ServiceMap'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'SQLAssessment'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'Updates'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'VMInsights'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'WireData2'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'WaaSUpdateInsights'
        product: 'OMSGallery'
        publisher: 'Microsoft'
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
| `location` | string | The location the resource was deployed into. |
| `logAnalyticsWorkspaceId` | string | The ID associated with the workspace. |
| `name` | string | The name of the deployed log analytics workspace. |
| `resourceGroupName` | string | The resource group of the deployed log analytics workspace. |
| `resourceId` | string | The resource ID of the deployed log analytics workspace. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `Microsoft.OperationsManagement/solutions` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspaces './Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-oiwcom'
  params: {
    // Required parameters
    name: '<<namePrefix>>oiwcom001'
    // Non-required parameters
    dailyQuotaGb: 10
    dataSources: [
      {
        eventLogName: 'Application'
        eventTypes: [
          {
            eventType: 'Error'
          }
          {
            eventType: 'Warning'
          }
          {
            eventType: 'Information'
          }
        ]
        kind: 'WindowsEvent'
        name: 'applicationEvent'
      }
      {
        counterName: '% Processor Time'
        instanceName: '*'
        intervalSeconds: 60
        kind: 'WindowsPerformanceCounter'
        name: 'windowsPerfCounter1'
        objectName: 'Processor'
      }
      {
        kind: 'IISLogs'
        name: 'sampleIISLog1'
        state: 'OnPremiseEnabled'
      }
      {
        kind: 'LinuxSyslog'
        name: 'sampleSyslog1'
        syslogName: 'kern'
        syslogSeverities: [
          {
            severity: 'emerg'
          }
          {
            severity: 'alert'
          }
          {
            severity: 'crit'
          }
          {
            severity: 'err'
          }
          {
            severity: 'warning'
          }
        ]
      }
      {
        kind: 'LinuxSyslogCollection'
        name: 'sampleSyslogCollection1'
        state: 'Enabled'
      }
      {
        instanceName: '*'
        intervalSeconds: 10
        kind: 'LinuxPerformanceObject'
        name: 'sampleLinuxPerf1'
        objectName: 'Logical Disk'
        syslogSeverities: [
          {
            counterName: '% Used Inodes'
          }
          {
            counterName: 'Free Megabytes'
          }
          {
            counterName: '% Used Space'
          }
          {
            counterName: 'Disk Transfers/sec'
          }
          {
            counterName: 'Disk Reads/sec'
          }
          {
            counterName: 'Disk Writes/sec'
          }
        ]
      }
      {
        kind: 'LinuxPerformanceCollection'
        name: 'sampleLinuxPerfCollection1'
        state: 'Enabled'
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    gallerySolutions: [
      {
        name: 'AzureAutomation'
        product: 'OMSGallery'
        publisher: 'Microsoft'
      }
    ]
    linkedServices: [
      {
        name: 'Automation'
        resourceId: '<resourceId>'
      }
    ]
    linkedStorageAccounts: [
      {
        name: 'Query'
        resourceId: '<resourceId>'
      }
    ]
    lock: 'CanNotDelete'
    publicNetworkAccessForIngestion: 'Disabled'
    publicNetworkAccessForQuery: 'Disabled'
    savedSearches: [
      {
        category: 'VDC Saved Searches'
        displayName: 'VMSS Instance Count2'
        name: 'VMSSQueries'
        query: 'Event | where Source == ServiceFabricNodeBootstrapAgent | summarize AggregatedValue = count() by Computer'
      }
    ]
    storageInsightsConfigs: [
      {
        storageAccountId: '<storageAccountId>'
        tables: [
          'LinuxsyslogVer2v0'
          'WADETWEventTable'
          'WADServiceFabric*EventTable'
          'WADWindowsEventLogsTable'
        ]
      }
    ]
    useResourcePermissions: true
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
      "value": "<<namePrefix>>oiwcom001"
    },
    // Non-required parameters
    "dailyQuotaGb": {
      "value": 10
    },
    "dataSources": {
      "value": [
        {
          "eventLogName": "Application",
          "eventTypes": [
            {
              "eventType": "Error"
            },
            {
              "eventType": "Warning"
            },
            {
              "eventType": "Information"
            }
          ],
          "kind": "WindowsEvent",
          "name": "applicationEvent"
        },
        {
          "counterName": "% Processor Time",
          "instanceName": "*",
          "intervalSeconds": 60,
          "kind": "WindowsPerformanceCounter",
          "name": "windowsPerfCounter1",
          "objectName": "Processor"
        },
        {
          "kind": "IISLogs",
          "name": "sampleIISLog1",
          "state": "OnPremiseEnabled"
        },
        {
          "kind": "LinuxSyslog",
          "name": "sampleSyslog1",
          "syslogName": "kern",
          "syslogSeverities": [
            {
              "severity": "emerg"
            },
            {
              "severity": "alert"
            },
            {
              "severity": "crit"
            },
            {
              "severity": "err"
            },
            {
              "severity": "warning"
            }
          ]
        },
        {
          "kind": "LinuxSyslogCollection",
          "name": "sampleSyslogCollection1",
          "state": "Enabled"
        },
        {
          "instanceName": "*",
          "intervalSeconds": 10,
          "kind": "LinuxPerformanceObject",
          "name": "sampleLinuxPerf1",
          "objectName": "Logical Disk",
          "syslogSeverities": [
            {
              "counterName": "% Used Inodes"
            },
            {
              "counterName": "Free Megabytes"
            },
            {
              "counterName": "% Used Space"
            },
            {
              "counterName": "Disk Transfers/sec"
            },
            {
              "counterName": "Disk Reads/sec"
            },
            {
              "counterName": "Disk Writes/sec"
            }
          ]
        },
        {
          "kind": "LinuxPerformanceCollection",
          "name": "sampleLinuxPerfCollection1",
          "state": "Enabled"
        }
      ]
    },
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
    "gallerySolutions": {
      "value": [
        {
          "name": "AzureAutomation",
          "product": "OMSGallery",
          "publisher": "Microsoft"
        }
      ]
    },
    "linkedServices": {
      "value": [
        {
          "name": "Automation",
          "resourceId": "<resourceId>"
        }
      ]
    },
    "linkedStorageAccounts": {
      "value": [
        {
          "name": "Query",
          "resourceId": "<resourceId>"
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "publicNetworkAccessForIngestion": {
      "value": "Disabled"
    },
    "publicNetworkAccessForQuery": {
      "value": "Disabled"
    },
    "savedSearches": {
      "value": [
        {
          "category": "VDC Saved Searches",
          "displayName": "VMSS Instance Count2",
          "name": "VMSSQueries",
          "query": "Event | where Source == ServiceFabricNodeBootstrapAgent | summarize AggregatedValue = count() by Computer"
        }
      ]
    },
    "storageInsightsConfigs": {
      "value": [
        {
          "storageAccountId": "<storageAccountId>",
          "tables": [
            "LinuxsyslogVer2v0",
            "WADETWEventTable",
            "WADServiceFabric*EventTable",
            "WADWindowsEventLogsTable"
          ]
        }
      ]
    },
    "useResourcePermissions": {
      "value": true
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
module workspaces './Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-oiwmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>oiwmin001'
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
      "value": "<<namePrefix>>oiwmin001"
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
