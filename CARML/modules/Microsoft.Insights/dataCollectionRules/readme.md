# DataCollectionRules `[Microsoft.Insights/dataCollectionRules]`

This module deploys DataCollection Rules.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/dataCollectionRules` | [2021-09-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-09-01-preview/dataCollectionRules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `dataFlows` | array | The specification of data flows. |
| `dataSources` | object | Specification of data sources that will be collected. |
| `destinations` | object | Specification of destinations that can be used in data flows. |
| `name` | string | The name of the data collection rule. The name is case insensitive. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `dataCollectionEndpointId` | string | `''` |  | The resource ID of the data collection endpoint that this rule can be used with. |
| `dataCollectionRuleDescription` | string | `''` |  | Description of the data collection rule. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `kind` | string | `'Linux'` | `[Linux, Windows]` | The kind of the resource. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `streamDeclarations` | object | `{object}` |  | Declaration of custom streams used in this rule. |
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
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the dataCollectionRule. |
| `resourceGroupName` | string | The name of the resource group the dataCollectionRule was created in. |
| `resourceId` | string | The resource ID of the dataCollectionRule. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Customadv</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRules './Microsoft.Insights/dataCollectionRules/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-idcrcusadv'
  params: {
    // Required parameters
    dataFlows: [
      {
        destinations: [
          '<logAnalyticsWorkspaceName>'
        ]
        outputStream: 'Custom-CustomTableAdvanced_CL'
        streams: [
          'Custom-CustomTableAdvanced_CL'
        ]
        transformKql: 'source | extend LogFields = split(RawData \'\') | extend EventTime = todatetime(LogFields[0]) | extend EventLevel = tostring(LogFields[1]) | extend EventCode = toint(LogFields[2]) | extend Message = tostring(LogFields[3]) | project TimeGenerated EventTime EventLevel EventCode Message'
      }
    ]
    dataSources: {
      logFiles: [
        {
          filePatterns: [
            'C:\\TestLogsAdvanced\\TestLog*.log'
          ]
          format: 'text'
          name: 'CustomTableAdvanced_CL'
          samplingFrequencyInSeconds: 10
          settings: {
            text: {
              recordStartTimestampFormat: 'ISO 8601'
            }
          }
          streams: [
            'Custom-CustomTableAdvanced_CL'
          ]
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          name: '<name>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
    }
    name: '<<namePrefix>>idcrcusadv001'
    // Non-required parameters
    dataCollectionEndpointId: '<dataCollectionEndpointId>'
    dataCollectionRuleDescription: 'Collecting custom text logs with ingestion-time transformation to columns. Expected format of a log line (comma separated values): \'<DateTime><EventLevel><EventCode><Message>\' for example: \'2023-01-25T20:15:05ZERROR404Page not found\''
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    kind: 'Windows'
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
    streamDeclarations: {
      'Custom-CustomTableAdvanced_CL': {
        columns: [
          {
            name: 'TimeGenerated'
            type: 'datetime'
          }
          {
            name: 'EventTime'
            type: 'datetime'
          }
          {
            name: 'EventLevel'
            type: 'string'
          }
          {
            name: 'EventCode'
            type: 'int'
          }
          {
            name: 'Message'
            type: 'string'
          }
          {
            name: 'RawData'
            type: 'string'
          }
        ]
      }
    }
    tags: {
      kind: 'Windows'
      resourceType: 'Data Collection Rules'
    }
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
    "dataFlows": {
      "value": [
        {
          "destinations": [
            "<logAnalyticsWorkspaceName>"
          ],
          "outputStream": "Custom-CustomTableAdvanced_CL",
          "streams": [
            "Custom-CustomTableAdvanced_CL"
          ],
          "transformKql": "source | extend LogFields = split(RawData, \",\") | extend EventTime = todatetime(LogFields[0]) | extend EventLevel = tostring(LogFields[1]) | extend EventCode = toint(LogFields[2]) | extend Message = tostring(LogFields[3]) | project TimeGenerated, EventTime, EventLevel, EventCode, Message"
        }
      ]
    },
    "dataSources": {
      "value": {
        "logFiles": [
          {
            "filePatterns": [
              "C:\\TestLogsAdvanced\\TestLog*.log"
            ],
            "format": "text",
            "name": "CustomTableAdvanced_CL",
            "samplingFrequencyInSeconds": 10,
            "settings": {
              "text": {
                "recordStartTimestampFormat": "ISO 8601"
              }
            },
            "streams": [
              "Custom-CustomTableAdvanced_CL"
            ]
          }
        ]
      }
    },
    "destinations": {
      "value": {
        "logAnalytics": [
          {
            "name": "<name>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ]
      }
    },
    "name": {
      "value": "<<namePrefix>>idcrcusadv001"
    },
    // Non-required parameters
    "dataCollectionEndpointId": {
      "value": "<dataCollectionEndpointId>"
    },
    "dataCollectionRuleDescription": {
      "value": "Collecting custom text logs with ingestion-time transformation to columns. Expected format of a log line (comma separated values): \"<DateTime>,<EventLevel>,<EventCode>,<Message>\", for example: \"2023-01-25T20:15:05Z,ERROR,404,Page not found\""
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "kind": {
      "value": "Windows"
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
    "streamDeclarations": {
      "value": {
        "Custom-CustomTableAdvanced_CL": {
          "columns": [
            {
              "name": "TimeGenerated",
              "type": "datetime"
            },
            {
              "name": "EventTime",
              "type": "datetime"
            },
            {
              "name": "EventLevel",
              "type": "string"
            },
            {
              "name": "EventCode",
              "type": "int"
            },
            {
              "name": "Message",
              "type": "string"
            },
            {
              "name": "RawData",
              "type": "string"
            }
          ]
        }
      }
    },
    "tags": {
      "value": {
        "kind": "Windows",
        "resourceType": "Data Collection Rules"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 2: Custombasic</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRules './Microsoft.Insights/dataCollectionRules/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-idcrcusbas'
  params: {
    // Required parameters
    dataFlows: [
      {
        destinations: [
          '<logAnalyticsWorkspaceName>'
        ]
        outputStream: 'Custom-CustomTableBasic_CL'
        streams: [
          'Custom-CustomTableBasic_CL'
        ]
        transformKql: 'source'
      }
    ]
    dataSources: {
      logFiles: [
        {
          filePatterns: [
            'C:\\TestLogsBasic\\TestLog*.log'
          ]
          format: 'text'
          name: 'CustomTableBasic_CL'
          samplingFrequencyInSeconds: 10
          settings: {
            text: {
              recordStartTimestampFormat: 'ISO 8601'
            }
          }
          streams: [
            'Custom-CustomTableBasic_CL'
          ]
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          name: '<name>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
    }
    name: '<<namePrefix>>idcrcusbas001'
    // Non-required parameters
    dataCollectionEndpointId: '<dataCollectionEndpointId>'
    dataCollectionRuleDescription: 'Collecting custom text logs without ingestion-time transformation.'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    kind: 'Windows'
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
    streamDeclarations: {
      'Custom-CustomTableBasic_CL': {
        columns: [
          {
            name: 'TimeGenerated'
            type: 'datetime'
          }
          {
            name: 'RawData'
            type: 'string'
          }
        ]
      }
    }
    tags: {
      kind: 'Windows'
      resourceType: 'Data Collection Rules'
    }
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
    "dataFlows": {
      "value": [
        {
          "destinations": [
            "<logAnalyticsWorkspaceName>"
          ],
          "outputStream": "Custom-CustomTableBasic_CL",
          "streams": [
            "Custom-CustomTableBasic_CL"
          ],
          "transformKql": "source"
        }
      ]
    },
    "dataSources": {
      "value": {
        "logFiles": [
          {
            "filePatterns": [
              "C:\\TestLogsBasic\\TestLog*.log"
            ],
            "format": "text",
            "name": "CustomTableBasic_CL",
            "samplingFrequencyInSeconds": 10,
            "settings": {
              "text": {
                "recordStartTimestampFormat": "ISO 8601"
              }
            },
            "streams": [
              "Custom-CustomTableBasic_CL"
            ]
          }
        ]
      }
    },
    "destinations": {
      "value": {
        "logAnalytics": [
          {
            "name": "<name>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ]
      }
    },
    "name": {
      "value": "<<namePrefix>>idcrcusbas001"
    },
    // Non-required parameters
    "dataCollectionEndpointId": {
      "value": "<dataCollectionEndpointId>"
    },
    "dataCollectionRuleDescription": {
      "value": "Collecting custom text logs without ingestion-time transformation."
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "kind": {
      "value": "Windows"
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
    "streamDeclarations": {
      "value": {
        "Custom-CustomTableBasic_CL": {
          "columns": [
            {
              "name": "TimeGenerated",
              "type": "datetime"
            },
            {
              "name": "RawData",
              "type": "string"
            }
          ]
        }
      }
    },
    "tags": {
      "value": {
        "kind": "Windows",
        "resourceType": "Data Collection Rules"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 3: Customiis</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRules './Microsoft.Insights/dataCollectionRules/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-idcrcusiis'
  params: {
    // Required parameters
    dataFlows: [
      {
        destinations: [
          '<logAnalyticsWorkspaceName>'
        ]
        outputStream: 'Microsoft-W3CIISLog'
        streams: [
          'Microsoft-W3CIISLog'
        ]
        transformKql: 'source'
      }
    ]
    dataSources: {
      iisLogs: [
        {
          logDirectories: [
            'C:\\inetpub\\logs\\LogFiles\\W3SVC1'
          ]
          name: 'iisLogsDataSource'
          streams: [
            'Microsoft-W3CIISLog'
          ]
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          name: '<name>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
    }
    name: '<<namePrefix>>idcrcusiis001'
    // Non-required parameters
    dataCollectionEndpointId: '<dataCollectionEndpointId>'
    dataCollectionRuleDescription: 'Collecting IIS logs.'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    kind: 'Windows'
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
    tags: {
      kind: 'Windows'
      resourceType: 'Data Collection Rules'
    }
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
    "dataFlows": {
      "value": [
        {
          "destinations": [
            "<logAnalyticsWorkspaceName>"
          ],
          "outputStream": "Microsoft-W3CIISLog",
          "streams": [
            "Microsoft-W3CIISLog"
          ],
          "transformKql": "source"
        }
      ]
    },
    "dataSources": {
      "value": {
        "iisLogs": [
          {
            "logDirectories": [
              "C:\\inetpub\\logs\\LogFiles\\W3SVC1"
            ],
            "name": "iisLogsDataSource",
            "streams": [
              "Microsoft-W3CIISLog"
            ]
          }
        ]
      }
    },
    "destinations": {
      "value": {
        "logAnalytics": [
          {
            "name": "<name>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ]
      }
    },
    "name": {
      "value": "<<namePrefix>>idcrcusiis001"
    },
    // Non-required parameters
    "dataCollectionEndpointId": {
      "value": "<dataCollectionEndpointId>"
    },
    "dataCollectionRuleDescription": {
      "value": "Collecting IIS logs."
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "kind": {
      "value": "Windows"
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
    "tags": {
      "value": {
        "kind": "Windows",
        "resourceType": "Data Collection Rules"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 4: Linux</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRules './Microsoft.Insights/dataCollectionRules/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-idcrlin'
  params: {
    // Required parameters
    dataFlows: [
      {
        destinations: [
          'azureMonitorMetrics-default'
        ]
        streams: [
          'Microsoft-InsightsMetrics'
        ]
      }
      {
        destinations: [
          '<logAnalyticsWorkspaceName>'
        ]
        streams: [
          'Microsoft-Syslog'
        ]
      }
    ]
    dataSources: {
      performanceCounters: [
        {
          counterSpecifiers: [
            'Memory(*)\\% Available Memory'
            'Memory(*)\\% Available Swap Space'
            'Memory(*)\\% Used Memory'
            'Memory(*)\\% Used Swap Space'
            'Memory(*)\\Available MBytes Memory'
            'Memory(*)\\Available MBytes Swap'
            'Memory(*)\\Page Reads/sec'
            'Memory(*)\\Page Writes/sec'
            'Memory(*)\\Pages/sec'
            'Memory(*)\\Used MBytes Swap Space'
            'Memory(*)\\Used Memory MBytes'
            'Processor(*)\\% DPC Time'
            'Processor(*)\\% Idle Time'
            'Processor(*)\\% Interrupt Time'
            'Processor(*)\\% IO Wait Time'
            'Processor(*)\\% Nice Time'
            'Processor(*)\\% Privileged Time'
            'Processor(*)\\% Processor Time'
            'Processor(*)\\% User Time'
          ]
          name: 'perfCounterDataSource10'
          samplingFrequencyInSeconds: 10
          streams: [
            'Microsoft-InsightsMetrics'
          ]
        }
        {
          counterSpecifiers: [
            'Logical Disk(*)\\% Free Inodes'
            'Logical Disk(*)\\% Free Space'
            'Logical Disk(*)\\% Used Inodes'
            'Logical Disk(*)\\% Used Space'
            'Logical Disk(*)\\Disk Read Bytes/sec'
            'Logical Disk(*)\\Disk Reads/sec'
            'Logical Disk(*)\\Disk Transfers/sec'
            'Logical Disk(*)\\Disk Write Bytes/sec'
            'Logical Disk(*)\\Disk Writes/sec'
            'Logical Disk(*)\\Free Megabytes'
            'Logical Disk(*)\\Logical Disk Bytes/sec'
            'Network(*)\\Total Bytes'
            'Network(*)\\Total Bytes Received'
            'Network(*)\\Total Bytes Transmitted'
            'Network(*)\\Total Collisions'
            'Network(*)\\Total Packets Received'
            'Network(*)\\Total Packets Transmitted'
            'Network(*)\\Total Rx Errors'
            'Network(*)\\Total Tx Errors'
          ]
          name: 'perfCounterDataSource15'
          samplingFrequencyInSeconds: 15
          streams: [
            'Microsoft-InsightsMetrics'
          ]
        }
      ]
      syslog: [
        {
          facilityNames: [
            'auth'
            'authpriv'
          ]
          logLevels: [
            'Alert'
            'Critical'
            'Debug'
            'Emergency'
            'Error'
            'Info'
            'Notice'
            'Warning'
          ]
          name: 'sysLogsDataSource-debugLevel'
          streams: [
            'Microsoft-Syslog'
          ]
        }
        {
          facilityNames: [
            'cron'
            'daemon'
            'kern'
            'local0'
            'mark'
          ]
          logLevels: [
            'Alert'
            'Critical'
            'Emergency'
            'Error'
            'Warning'
          ]
          name: 'sysLogsDataSource-warningLevel'
          streams: [
            'Microsoft-Syslog'
          ]
        }
        {
          facilityNames: [
            'local1'
            'local2'
            'local3'
            'local4'
            'local5'
            'local6'
            'local7'
            'lpr'
            'mail'
            'news'
            'syslog'
          ]
          logLevels: [
            'Alert'
            'Critical'
            'Emergency'
            'Error'
          ]
          name: 'sysLogsDataSource-errLevel'
          streams: [
            'Microsoft-Syslog'
          ]
        }
      ]
    }
    destinations: {
      azureMonitorMetrics: {
        name: 'azureMonitorMetrics-default'
      }
      logAnalytics: [
        {
          name: '<name>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
    }
    name: '<<namePrefix>>idcrlin001'
    // Non-required parameters
    dataCollectionRuleDescription: 'Collecting Linux-specific performance counters and Linux Syslog'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    kind: 'Linux'
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
    tags: {
      kind: 'Linux'
      resourceType: 'Data Collection Rules'
    }
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
    "dataFlows": {
      "value": [
        {
          "destinations": [
            "azureMonitorMetrics-default"
          ],
          "streams": [
            "Microsoft-InsightsMetrics"
          ]
        },
        {
          "destinations": [
            "<logAnalyticsWorkspaceName>"
          ],
          "streams": [
            "Microsoft-Syslog"
          ]
        }
      ]
    },
    "dataSources": {
      "value": {
        "performanceCounters": [
          {
            "counterSpecifiers": [
              "Memory(*)\\% Available Memory",
              "Memory(*)\\% Available Swap Space",
              "Memory(*)\\% Used Memory",
              "Memory(*)\\% Used Swap Space",
              "Memory(*)\\Available MBytes Memory",
              "Memory(*)\\Available MBytes Swap",
              "Memory(*)\\Page Reads/sec",
              "Memory(*)\\Page Writes/sec",
              "Memory(*)\\Pages/sec",
              "Memory(*)\\Used MBytes Swap Space",
              "Memory(*)\\Used Memory MBytes",
              "Processor(*)\\% DPC Time",
              "Processor(*)\\% Idle Time",
              "Processor(*)\\% Interrupt Time",
              "Processor(*)\\% IO Wait Time",
              "Processor(*)\\% Nice Time",
              "Processor(*)\\% Privileged Time",
              "Processor(*)\\% Processor Time",
              "Processor(*)\\% User Time"
            ],
            "name": "perfCounterDataSource10",
            "samplingFrequencyInSeconds": 10,
            "streams": [
              "Microsoft-InsightsMetrics"
            ]
          },
          {
            "counterSpecifiers": [
              "Logical Disk(*)\\% Free Inodes",
              "Logical Disk(*)\\% Free Space",
              "Logical Disk(*)\\% Used Inodes",
              "Logical Disk(*)\\% Used Space",
              "Logical Disk(*)\\Disk Read Bytes/sec",
              "Logical Disk(*)\\Disk Reads/sec",
              "Logical Disk(*)\\Disk Transfers/sec",
              "Logical Disk(*)\\Disk Write Bytes/sec",
              "Logical Disk(*)\\Disk Writes/sec",
              "Logical Disk(*)\\Free Megabytes",
              "Logical Disk(*)\\Logical Disk Bytes/sec",
              "Network(*)\\Total Bytes",
              "Network(*)\\Total Bytes Received",
              "Network(*)\\Total Bytes Transmitted",
              "Network(*)\\Total Collisions",
              "Network(*)\\Total Packets Received",
              "Network(*)\\Total Packets Transmitted",
              "Network(*)\\Total Rx Errors",
              "Network(*)\\Total Tx Errors"
            ],
            "name": "perfCounterDataSource15",
            "samplingFrequencyInSeconds": 15,
            "streams": [
              "Microsoft-InsightsMetrics"
            ]
          }
        ],
        "syslog": [
          {
            "facilityNames": [
              "auth",
              "authpriv"
            ],
            "logLevels": [
              "Alert",
              "Critical",
              "Debug",
              "Emergency",
              "Error",
              "Info",
              "Notice",
              "Warning"
            ],
            "name": "sysLogsDataSource-debugLevel",
            "streams": [
              "Microsoft-Syslog"
            ]
          },
          {
            "facilityNames": [
              "cron",
              "daemon",
              "kern",
              "local0",
              "mark"
            ],
            "logLevels": [
              "Alert",
              "Critical",
              "Emergency",
              "Error",
              "Warning"
            ],
            "name": "sysLogsDataSource-warningLevel",
            "streams": [
              "Microsoft-Syslog"
            ]
          },
          {
            "facilityNames": [
              "local1",
              "local2",
              "local3",
              "local4",
              "local5",
              "local6",
              "local7",
              "lpr",
              "mail",
              "news",
              "syslog"
            ],
            "logLevels": [
              "Alert",
              "Critical",
              "Emergency",
              "Error"
            ],
            "name": "sysLogsDataSource-errLevel",
            "streams": [
              "Microsoft-Syslog"
            ]
          }
        ]
      }
    },
    "destinations": {
      "value": {
        "azureMonitorMetrics": {
          "name": "azureMonitorMetrics-default"
        },
        "logAnalytics": [
          {
            "name": "<name>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ]
      }
    },
    "name": {
      "value": "<<namePrefix>>idcrlin001"
    },
    // Non-required parameters
    "dataCollectionRuleDescription": {
      "value": "Collecting Linux-specific performance counters and Linux Syslog"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "kind": {
      "value": "Linux"
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
    "tags": {
      "value": {
        "kind": "Linux",
        "resourceType": "Data Collection Rules"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 5: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRules './Microsoft.Insights/dataCollectionRules/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-idcrmin'
  params: {
    // Required parameters
    dataFlows: [
      {
        destinations: [
          'azureMonitorMetrics-default'
        ]
        streams: [
          'Microsoft-InsightsMetrics'
        ]
      }
    ]
    dataSources: {
      performanceCounters: [
        {
          counterSpecifiers: [
            '\\Process(_Total)\\Handle Count'
            '\\Process(_Total)\\Thread Count'
            '\\Processor Information(_Total)\\% Privileged Time'
            '\\Processor Information(_Total)\\% Processor Time'
            '\\Processor Information(_Total)\\% User Time'
            '\\Processor Information(_Total)\\Processor Frequency'
            '\\System\\Context Switches/sec'
            '\\System\\Processes'
            '\\System\\Processor Queue Length'
            '\\System\\System Up Time'
          ]
          name: 'perfCounterDataSource10'
          samplingFrequencyInSeconds: 10
          streams: [
            'Microsoft-InsightsMetrics'
          ]
        }
      ]
    }
    destinations: {
      azureMonitorMetrics: {
        name: 'azureMonitorMetrics-default'
      }
    }
    name: '<<namePrefix>>idcrmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    kind: 'Windows'
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
    "dataFlows": {
      "value": [
        {
          "destinations": [
            "azureMonitorMetrics-default"
          ],
          "streams": [
            "Microsoft-InsightsMetrics"
          ]
        }
      ]
    },
    "dataSources": {
      "value": {
        "performanceCounters": [
          {
            "counterSpecifiers": [
              "\\Process(_Total)\\Handle Count",
              "\\Process(_Total)\\Thread Count",
              "\\Processor Information(_Total)\\% Privileged Time",
              "\\Processor Information(_Total)\\% Processor Time",
              "\\Processor Information(_Total)\\% User Time",
              "\\Processor Information(_Total)\\Processor Frequency",
              "\\System\\Context Switches/sec",
              "\\System\\Processes",
              "\\System\\Processor Queue Length",
              "\\System\\System Up Time"
            ],
            "name": "perfCounterDataSource10",
            "samplingFrequencyInSeconds": 10,
            "streams": [
              "Microsoft-InsightsMetrics"
            ]
          }
        ]
      }
    },
    "destinations": {
      "value": {
        "azureMonitorMetrics": {
          "name": "azureMonitorMetrics-default"
        }
      }
    },
    "name": {
      "value": "<<namePrefix>>idcrmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "kind": {
      "value": "Windows"
    }
  }
}
```

</details>
<p>

<h3>Example 6: Windows</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRules './Microsoft.Insights/dataCollectionRules/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-idcrwin'
  params: {
    // Required parameters
    dataFlows: [
      {
        destinations: [
          'azureMonitorMetrics-default'
        ]
        streams: [
          'Microsoft-InsightsMetrics'
        ]
      }
      {
        destinations: [
          '<logAnalyticsWorkspaceName>'
        ]
        streams: [
          'Microsoft-Event'
        ]
      }
    ]
    dataSources: {
      performanceCounters: [
        {
          counterSpecifiers: [
            '\\Memory\\% Committed Bytes In Use'
            '\\Memory\\Available Bytes'
            '\\Memory\\Cache Bytes'
            '\\Memory\\Committed Bytes'
            '\\Memory\\Page Faults/sec'
            '\\Memory\\Pages/sec'
            '\\Memory\\Pool Nonpaged Bytes'
            '\\Memory\\Pool Paged Bytes'
            '\\Process(_Total)\\Handle Count'
            '\\Process(_Total)\\Thread Count'
            '\\Process(_Total)\\Working Set'
            '\\Process(_Total)\\Working Set - Private'
            '\\Processor Information(_Total)\\% Privileged Time'
            '\\Processor Information(_Total)\\% Processor Time'
            '\\Processor Information(_Total)\\% User Time'
            '\\Processor Information(_Total)\\Processor Frequency'
            '\\System\\Context Switches/sec'
            '\\System\\Processes'
            '\\System\\Processor Queue Length'
            '\\System\\System Up Time'
          ]
          name: 'perfCounterDataSource10'
          samplingFrequencyInSeconds: 10
          streams: [
            'Microsoft-InsightsMetrics'
          ]
        }
        {
          counterSpecifiers: [
            '\\LogicalDisk(_Total)\\% Disk Read Time'
            '\\LogicalDisk(_Total)\\% Disk Time'
            '\\LogicalDisk(_Total)\\% Disk Write Time'
            '\\LogicalDisk(_Total)\\% Free Space'
            '\\LogicalDisk(_Total)\\% Idle Time'
            '\\LogicalDisk(_Total)\\Avg. Disk Queue Length'
            '\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Read'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Write'
            '\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length'
            '\\LogicalDisk(_Total)\\Disk Bytes/sec'
            '\\LogicalDisk(_Total)\\Disk Read Bytes/sec'
            '\\LogicalDisk(_Total)\\Disk Reads/sec'
            '\\LogicalDisk(_Total)\\Disk Transfers/sec'
            '\\LogicalDisk(_Total)\\Disk Write Bytes/sec'
            '\\LogicalDisk(_Total)\\Disk Writes/sec'
            '\\LogicalDisk(_Total)\\Free Megabytes'
            '\\Network Interface(*)\\Bytes Received/sec'
            '\\Network Interface(*)\\Bytes Sent/sec'
            '\\Network Interface(*)\\Bytes Total/sec'
            '\\Network Interface(*)\\Packets Outbound Errors'
            '\\Network Interface(*)\\Packets Received Errors'
            '\\Network Interface(*)\\Packets Received/sec'
            '\\Network Interface(*)\\Packets Sent/sec'
            '\\Network Interface(*)\\Packets/sec'
          ]
          name: 'perfCounterDataSource15'
          samplingFrequencyInSeconds: 15
          streams: [
            'Microsoft-InsightsMetrics'
          ]
        }
      ]
      windowsEventLogs: [
        {
          name: 'eventLogsDataSource'
          streams: [
            'Microsoft-Event'
          ]
          xPathQueries: [
            'Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]'
            'Security!*[System[(band(Keywords13510798882111488))]]'
            'System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]'
          ]
        }
      ]
    }
    destinations: {
      azureMonitorMetrics: {
        name: 'azureMonitorMetrics-default'
      }
      logAnalytics: [
        {
          name: '<name>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
    }
    name: '<<namePrefix>>idcrwin001'
    // Non-required parameters
    dataCollectionRuleDescription: 'Collecting Windows-specific performance counters and Windows Event Logs'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    kind: 'Windows'
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
    tags: {
      kind: 'Windows'
      resourceType: 'Data Collection Rules'
    }
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
    "dataFlows": {
      "value": [
        {
          "destinations": [
            "azureMonitorMetrics-default"
          ],
          "streams": [
            "Microsoft-InsightsMetrics"
          ]
        },
        {
          "destinations": [
            "<logAnalyticsWorkspaceName>"
          ],
          "streams": [
            "Microsoft-Event"
          ]
        }
      ]
    },
    "dataSources": {
      "value": {
        "performanceCounters": [
          {
            "counterSpecifiers": [
              "\\Memory\\% Committed Bytes In Use",
              "\\Memory\\Available Bytes",
              "\\Memory\\Cache Bytes",
              "\\Memory\\Committed Bytes",
              "\\Memory\\Page Faults/sec",
              "\\Memory\\Pages/sec",
              "\\Memory\\Pool Nonpaged Bytes",
              "\\Memory\\Pool Paged Bytes",
              "\\Process(_Total)\\Handle Count",
              "\\Process(_Total)\\Thread Count",
              "\\Process(_Total)\\Working Set",
              "\\Process(_Total)\\Working Set - Private",
              "\\Processor Information(_Total)\\% Privileged Time",
              "\\Processor Information(_Total)\\% Processor Time",
              "\\Processor Information(_Total)\\% User Time",
              "\\Processor Information(_Total)\\Processor Frequency",
              "\\System\\Context Switches/sec",
              "\\System\\Processes",
              "\\System\\Processor Queue Length",
              "\\System\\System Up Time"
            ],
            "name": "perfCounterDataSource10",
            "samplingFrequencyInSeconds": 10,
            "streams": [
              "Microsoft-InsightsMetrics"
            ]
          },
          {
            "counterSpecifiers": [
              "\\LogicalDisk(_Total)\\% Disk Read Time",
              "\\LogicalDisk(_Total)\\% Disk Time",
              "\\LogicalDisk(_Total)\\% Disk Write Time",
              "\\LogicalDisk(_Total)\\% Free Space",
              "\\LogicalDisk(_Total)\\% Idle Time",
              "\\LogicalDisk(_Total)\\Avg. Disk Queue Length",
              "\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length",
              "\\LogicalDisk(_Total)\\Avg. Disk sec/Read",
              "\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer",
              "\\LogicalDisk(_Total)\\Avg. Disk sec/Write",
              "\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length",
              "\\LogicalDisk(_Total)\\Disk Bytes/sec",
              "\\LogicalDisk(_Total)\\Disk Read Bytes/sec",
              "\\LogicalDisk(_Total)\\Disk Reads/sec",
              "\\LogicalDisk(_Total)\\Disk Transfers/sec",
              "\\LogicalDisk(_Total)\\Disk Write Bytes/sec",
              "\\LogicalDisk(_Total)\\Disk Writes/sec",
              "\\LogicalDisk(_Total)\\Free Megabytes",
              "\\Network Interface(*)\\Bytes Received/sec",
              "\\Network Interface(*)\\Bytes Sent/sec",
              "\\Network Interface(*)\\Bytes Total/sec",
              "\\Network Interface(*)\\Packets Outbound Errors",
              "\\Network Interface(*)\\Packets Received Errors",
              "\\Network Interface(*)\\Packets Received/sec",
              "\\Network Interface(*)\\Packets Sent/sec",
              "\\Network Interface(*)\\Packets/sec"
            ],
            "name": "perfCounterDataSource15",
            "samplingFrequencyInSeconds": 15,
            "streams": [
              "Microsoft-InsightsMetrics"
            ]
          }
        ],
        "windowsEventLogs": [
          {
            "name": "eventLogsDataSource",
            "streams": [
              "Microsoft-Event"
            ],
            "xPathQueries": [
              "Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]",
              "Security!*[System[(band(Keywords,13510798882111488))]]",
              "System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]"
            ]
          }
        ]
      }
    },
    "destinations": {
      "value": {
        "azureMonitorMetrics": {
          "name": "azureMonitorMetrics-default"
        },
        "logAnalytics": [
          {
            "name": "<name>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ]
      }
    },
    "name": {
      "value": "<<namePrefix>>idcrwin001"
    },
    // Non-required parameters
    "dataCollectionRuleDescription": {
      "value": "Collecting Windows-specific performance counters and Windows Event Logs"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "kind": {
      "value": "Windows"
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
    "tags": {
      "value": {
        "kind": "Windows",
        "resourceType": "Data Collection Rules"
      }
    }
  }
}
```

</details>
<p>
