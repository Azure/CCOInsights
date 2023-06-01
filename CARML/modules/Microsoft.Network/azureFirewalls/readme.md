# Azure Firewalls `[Microsoft.Network/azureFirewalls]`

This module deploys a firewall.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Considerations](#Considerations)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/azureFirewalls` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/azureFirewalls) |
| `Microsoft.Network/publicIPAddresses` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/publicIPAddresses) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Azure Firewall. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `hubIPAddresses` | object | `{object}` | IP addresses associated with AzureFirewall. Required if `virtualHubId` is supplied. |
| `virtualHubId` | string | `''` | The virtualHub resource ID to which the firewall belongs. Required if `vNetId` is empty. |
| `vNetId` | string | `''` | Shared services Virtual Network resource ID. The virtual network ID containing AzureFirewallSubnet. If a public ip is not provided, then the public ip that is created as part of this module will be applied with the subnet provided in this variable. Required if `virtualHubId` is empty. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `additionalPublicIpConfigurations` | array | `[]` |  | This is to add any additional public ip configurations on top of the public ip with subnet ip configuration. |
| `applicationRuleCollections` | array | `[]` |  | Collection of application rule collections used by Azure Firewall. |
| `azureFirewallSubnetPublicIpId` | string | `''` |  | The public ip resource ID to associate to the AzureFirewallSubnet. If empty, then the public ip that is created as part of this module will be applied to the AzureFirewallSubnet. |
| `azureSkuTier` | string | `'Standard'` | `[Premium, Standard]` | Tier of an Azure Firewall. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, AzureFirewallApplicationRule, AzureFirewallDnsProxy, AzureFirewallNetworkRule]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Diagnostic Storage Account resource identifier. |
| `diagnosticWorkspaceId` | string | `''` |  | Log Analytics workspace resource identifier. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `firewallPolicyId` | string | `''` |  | Resource ID of the Firewall Policy that should be attached. |
| `isCreateDefaultPublicIP` | bool | `True` |  | Specifies if a public ip should be created by default if one is not provided. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `natRuleCollections` | array | `[]` |  | Collection of NAT rule collections used by Azure Firewall. |
| `networkRuleCollections` | array | `[]` |  | Collection of network rule collections used by Azure Firewall. |
| `publicIPAddressObject` | object | `{object}` |  | Specifies the properties of the public IP to create and be used by Azure Firewall. If it's not provided and publicIPAddressId is empty, a '-pip' suffix will be appended to the Firewall's name. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags of the Azure Firewall resource. |
| `threatIntelMode` | string | `'Deny'` | `[Alert, Deny, Off]` | The operation mode for Threat Intel. |
| `zones` | array | `[1, 2, 3]` |  | Zone numbers e.g. 1,2,3. |


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
| `applicationRuleCollections` | array | List of Application Rule Collections. |
| `ipConfAzureFirewallSubnet` | object | The public IP configuration object for the Azure Firewall Subnet. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Azure Firewall. |
| `natRuleCollections` | array | Collection of NAT rule collections used by Azure Firewall. |
| `networkRuleCollections` | array | List of Network Rule Collections. |
| `privateIp` | string | The private IP of the Azure firewall. |
| `resourceGroupName` | string | The resource group the Azure firewall was deployed into. |
| `resourceId` | string | The resource ID of the Azure Firewall. |

## Considerations

The `applicationRuleCollections` parameter accepts a JSON Array of AzureFirewallApplicationRule objects.
The `networkRuleCollections` parameter accepts a JSON Array of AzureFirewallNetworkRuleCollection objects.

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `Microsoft.Network/publicIPAddresses` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Addpip</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewalls './Microsoft.Network/azureFirewalls/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nafaddpip'
  params: {
    // Required parameters
    name: '<<namePrefix>>nafaddpip001'
    // Non-required parameters
    additionalPublicIpConfigurations: [
      {
        name: 'ipConfig01'
        publicIPAddressResourceId: '<publicIPAddressResourceId>'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    vNetId: '<vNetId>'
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
      "value": "<<namePrefix>>nafaddpip001"
    },
    // Non-required parameters
    "additionalPublicIpConfigurations": {
      "value": [
        {
          "name": "ipConfig01",
          "publicIPAddressResourceId": "<publicIPAddressResourceId>"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "vNetId": {
      "value": "<vNetId>"
    }
  }
}
```

</details>
<p>

<h3>Example 2: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewalls './Microsoft.Network/azureFirewalls/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nafcom'
  params: {
    // Required parameters
    name: '<<namePrefix>>nafcom001'
    // Non-required parameters
    applicationRuleCollections: [
      {
        name: 'allow-app-rules'
        properties: {
          action: {
            type: 'allow'
          }
          priority: 100
          rules: [
            {
              fqdnTags: [
                'AppServiceEnvironment'
                'WindowsUpdate'
              ]
              name: 'allow-ase-tags'
              protocols: [
                {
                  port: '80'
                  protocolType: 'HTTP'
                }
                {
                  port: '443'
                  protocolType: 'HTTPS'
                }
              ]
              sourceAddresses: [
                '*'
              ]
            }
            {
              name: 'allow-ase-management'
              protocols: [
                {
                  port: '80'
                  protocolType: 'HTTP'
                }
                {
                  port: '443'
                  protocolType: 'HTTPS'
                }
              ]
              sourceAddresses: [
                '*'
              ]
              targetFqdns: [
                'bing.com'
              ]
            }
          ]
        }
      }
    ]
    azureFirewallSubnetPublicIpId: '<azureFirewallSubnetPublicIpId>'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    networkRuleCollections: [
      {
        name: 'allow-network-rules'
        properties: {
          action: {
            type: 'allow'
          }
          priority: 100
          rules: [
            {
              destinationAddresses: [
                '*'
              ]
              destinationPorts: [
                '12000'
                '123'
              ]
              name: 'allow-ntp'
              protocols: [
                'Any'
              ]
              sourceAddresses: [
                '*'
              ]
            }
          ]
        }
      }
    ]
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    vNetId: '<vNetId>'
    zones: [
      '1'
      '2'
      '3'
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
      "value": "<<namePrefix>>nafcom001"
    },
    // Non-required parameters
    "applicationRuleCollections": {
      "value": [
        {
          "name": "allow-app-rules",
          "properties": {
            "action": {
              "type": "allow"
            },
            "priority": 100,
            "rules": [
              {
                "fqdnTags": [
                  "AppServiceEnvironment",
                  "WindowsUpdate"
                ],
                "name": "allow-ase-tags",
                "protocols": [
                  {
                    "port": "80",
                    "protocolType": "HTTP"
                  },
                  {
                    "port": "443",
                    "protocolType": "HTTPS"
                  }
                ],
                "sourceAddresses": [
                  "*"
                ]
              },
              {
                "name": "allow-ase-management",
                "protocols": [
                  {
                    "port": "80",
                    "protocolType": "HTTP"
                  },
                  {
                    "port": "443",
                    "protocolType": "HTTPS"
                  }
                ],
                "sourceAddresses": [
                  "*"
                ],
                "targetFqdns": [
                  "bing.com"
                ]
              }
            ]
          }
        }
      ]
    },
    "azureFirewallSubnetPublicIpId": {
      "value": "<azureFirewallSubnetPublicIpId>"
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
    "lock": {
      "value": "CanNotDelete"
    },
    "networkRuleCollections": {
      "value": [
        {
          "name": "allow-network-rules",
          "properties": {
            "action": {
              "type": "allow"
            },
            "priority": 100,
            "rules": [
              {
                "destinationAddresses": [
                  "*"
                ],
                "destinationPorts": [
                  "12000",
                  "123"
                ],
                "name": "allow-ntp",
                "protocols": [
                  "Any"
                ],
                "sourceAddresses": [
                  "*"
                ]
              }
            ]
          }
        }
      ]
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
    "vNetId": {
      "value": "<vNetId>"
    },
    "zones": {
      "value": [
        "1",
        "2",
        "3"
      ]
    }
  }
}
```

</details>
<p>

<h3>Example 3: Custompip</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewalls './Microsoft.Network/azureFirewalls/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nafcstpip'
  params: {
    // Required parameters
    name: '<<namePrefix>>nafcstpip001'
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
      name: 'new-<<namePrefix>>-pip-nafcstpip'
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
    vNetId: '<vNetId>'
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
      "value": "<<namePrefix>>nafcstpip001"
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
        "name": "new-<<namePrefix>>-pip-nafcstpip",
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
    },
    "vNetId": {
      "value": "<vNetId>"
    }
  }
}
```

</details>
<p>

<h3>Example 4: Hub</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewalls './Microsoft.Network/azureFirewalls/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nafhub'
  params: {
    // Required parameters
    name: '<<namePrefix>>nafhub001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    firewallPolicyId: '<firewallPolicyId>'
    hubIPAddresses: {
      publicIPs: {
        count: 1
      }
    }
    virtualHubId: '<virtualHubId>'
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
      "value": "<<namePrefix>>nafhub001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "firewallPolicyId": {
      "value": "<firewallPolicyId>"
    },
    "hubIPAddresses": {
      "value": {
        "publicIPs": {
          "count": 1
        }
      }
    },
    "virtualHubId": {
      "value": "<virtualHubId>"
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
module azureFirewalls './Microsoft.Network/azureFirewalls/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nafmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>nafmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    vNetId: '<vNetId>'
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
      "value": "<<namePrefix>>nafmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "vNetId": {
      "value": "<vNetId>"
    }
  }
}
```

</details>
<p>
