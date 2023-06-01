# Bastion Hosts `[Microsoft.Network/bastionHosts]`

This module deploys a bastion host.

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
| `Microsoft.Network/bastionHosts` | [2022-01-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-01-01/bastionHosts) |
| `Microsoft.Network/publicIPAddresses` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/publicIPAddresses) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Azure Bastion resource. |
| `vNetId` | string | Shared services Virtual Network resource identifier. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `azureBastionSubnetPublicIpId` | string | `''` |  | The public ip resource ID to associate to the azureBastionSubnet. If empty, then the public ip that is created as part of this module will be applied to the azureBastionSubnet. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, BastionAuditLogs]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `disableCopyPaste` | bool | `False` |  | Choose to disable or enable Copy Paste. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enableFileCopy` | bool | `True` |  | Choose to disable or enable File Copy. |
| `enableIpConnect` | bool | `False` |  | Choose to disable or enable IP Connect. |
| `enableShareableLink` | bool | `False` |  | Choose to disable or enable Shareable Link. |
| `isCreateDefaultPublicIP` | bool | `True` |  | Specifies if a public ip should be created by default if one is not provided. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `publicIPAddressObject` | object | `{object}` |  | Specifies the properties of the public IP to create and be used by Azure Bastion. If it's not provided and publicIPAddressResourceId is empty, a '-pip' suffix will be appended to the Bastion's name. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `scaleUnits` | int | `2` |  | The scale units for the Bastion Host resource. |
| `skuType` | string | `'Basic'` | `[Basic, Standard]` | The SKU of this Bastion Host. |
| `tags` | object | `{object}` |  | Tags of the resource. |


### Parameter Usage: `additionalPublicIpConfigurations`

Create additional public ip configurations from existing public ips

<details>

<summary>Parameter JSON format</summary>

```json
"additionalPublicIpConfigurations": {
    "value": [
        {
            "name": "ipConfig01",
            "publicIPAddressResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/publicIPAddresses/adp-<<namePrefix>>-az-pip-x-fw-01"
        },
        {
            "name": "ipConfig02",
            "publicIPAddressResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/publicIPAddresses/adp-<<namePrefix>>-az-pip-x-fw-02"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
additionalPublicIpConfigurations: [
    {
        name: 'ipConfig01'
        publicIPAddressResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/publicIPAddresses/adp-<<namePrefix>>-az-pip-x-fw-01'
    }
    {
        name: 'ipConfig02'
        publicIPAddressResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/publicIPAddresses/adp-<<namePrefix>>-az-pip-x-fw-02'
    }
]
```

</details>


### Parameter Usage: `publicIPAddressObject`

The Public IP Address object to create as part of the module. This will be created if `isCreateDefaultPublicIP` is true (which it is by default). If not provided, the name and other configurations will be set by default.


<details>

<summary>Parameter JSON format</summary>

```json
"publicIPAddressObject": {
    "value": {
        "name": "adp-<<namePrefix>>-az-pip-custom-x-fw",
        "publicIPPrefixResourceId": "",
        "publicIPAllocationMethod": "Static",
        "skuName": "Standard",
        "skuTier": "Regional",
        "roleAssignments": [
            {
                "roleDefinitionIdOrName": "Reader",
                "principalIds": [
                    "<<deploymentSpId>>"
                ]
            }
        ],
        "diagnosticMetricsToEnable": [
            "AllMetrics"
        ],
        "diagnosticLogCategoriesToEnable": [
            "DDoSProtectionNotifications",
            "DDoSMitigationFlowLogs",
            "DDoSMitigationReports"
        ]
    }
}
```

</details>



<details>

<summary>Bicep format</summary>


```bicep
publicIPAddressObject: {
    name: 'mypip'
    publicIPPrefixResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/publicIPPrefixes/myprefix'
    publicIPAllocationMethod: 'Dynamic'
    skuName: 'Basic'
    skuTier: 'Regional'
    roleAssignments: [
        {
            roleDefinitionIdOrName: 'Reader'
            principalIds: [
                '<<deploymentSpId>>'
            ]
        }
    ]
    diagnosticMetricsToEnable: [
        'AllMetrics'
    ]
    diagnosticLogCategoriesToEnable: [
        'DDoSProtectionNotifications'
        'DDoSMitigationFlowLogs'
        'DDoSMitigationReports'
    ]
}
```

</details>



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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `ipConfAzureBastionSubnet` | object | The public ipconfiguration object for the AzureBastionSubnet. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name the Azure Bastion. |
| `resourceGroupName` | string | The resource group the Azure Bastion was deployed into. |
| `resourceId` | string | The resource ID the Azure Bastion. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `Microsoft.Network/publicIPAddresses` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module bastionHosts './Microsoft.Network/bastionHosts/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nbhcom'
  params: {
    // Required parameters
    name: '<<namePrefix>>nbhcom001'
    vNetId: '<vNetId>'
    // Non-required parameters
    azureBastionSubnetPublicIpId: '<azureBastionSubnetPublicIpId>'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    disableCopyPaste: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enableFileCopy: false
    enableIpConnect: false
    enableShareableLink: false
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
    scaleUnits: 4
    skuType: 'Standard'
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
      "value": "<<namePrefix>>nbhcom001"
    },
    "vNetId": {
      "value": "<vNetId>"
    },
    // Non-required parameters
    "azureBastionSubnetPublicIpId": {
      "value": "<azureBastionSubnetPublicIpId>"
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
    "disableCopyPaste": {
      "value": true
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enableFileCopy": {
      "value": false
    },
    "enableIpConnect": {
      "value": false
    },
    "enableShareableLink": {
      "value": false
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
    "scaleUnits": {
      "value": 4
    },
    "skuType": {
      "value": "Standard"
    }
  }
}
```

</details>
<p>

<h3>Example 2: Custompip</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module bastionHosts './Microsoft.Network/bastionHosts/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nbhctmpip'
  params: {
    // Required parameters
    name: '<<namePrefix>>nbhctmpip001'
    vNetId: '<vNetId>'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    publicIPAddressObject: {
      diagnosticLogCategoriesToEnable: [
        'DDoSMitigationFlowLogs'
        'DDoSMitigationReports'
        'DDoSProtectionNotifications'
      ]
      diagnosticMetricsToEnable: [
        'AllMetrics'
      ]
      name: '<<namePrefix>>nbhctmpip001-pip'
      publicIPAllocationMethod: 'Static'
      publicIPPrefixResourceId: ''
      roleAssignments: [
        {
          principalIds: [
            '<managedIdentityPrincipalId>'
          ]
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: 'Reader'
        }
      ]
      skuName: 'Standard'
      skuTier: 'Regional'
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
    "name": {
      "value": "<<namePrefix>>nbhctmpip001"
    },
    "vNetId": {
      "value": "<vNetId>"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "publicIPAddressObject": {
      "value": {
        "diagnosticLogCategoriesToEnable": [
          "DDoSMitigationFlowLogs",
          "DDoSMitigationReports",
          "DDoSProtectionNotifications"
        ],
        "diagnosticMetricsToEnable": [
          "AllMetrics"
        ],
        "name": "<<namePrefix>>nbhctmpip001-pip",
        "publicIPAllocationMethod": "Static",
        "publicIPPrefixResourceId": "",
        "roleAssignments": [
          {
            "principalIds": [
              "<managedIdentityPrincipalId>"
            ],
            "principalType": "ServicePrincipal",
            "roleDefinitionIdOrName": "Reader"
          }
        ],
        "skuName": "Standard",
        "skuTier": "Regional"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 3: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module bastionHosts './Microsoft.Network/bastionHosts/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nbhmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>nbhmin001'
    vNetId: '<vNetId>'
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
      "value": "<<namePrefix>>nbhmin001"
    },
    "vNetId": {
      "value": "<vNetId>"
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
