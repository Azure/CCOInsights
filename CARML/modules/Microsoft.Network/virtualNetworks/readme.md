# Virtual Networks `[Microsoft.Network/virtualNetworks]`

This template deploys a virtual network (vNet).

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Considerations](#Considerations)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/virtualNetworks` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/virtualNetworks/virtualNetworkPeerings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `addressPrefixes` | array | An Array of 1 or more IP Address Prefixes for the Virtual Network. |
| `name` | string | The Virtual Network (vNet) Name. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `ddosProtectionPlanId` | string | `''` |  | Resource ID of the DDoS protection plan to assign the VNET to. If it's left blank, DDoS protection will not be configured. If it's provided, the VNET created by this template will be attached to the referenced DDoS protection plan. The DDoS protection plan can exist in the same or in a different subscription. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, VMProtectionAlerts]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `dnsServers` | array | `[]` |  | DNS Servers associated to the Virtual Network. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `subnets` | _[subnets](subnets/readme.md)_ array | `[]` |  | An Array of subnets to deploy to the Virtual Network. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `virtualNetworkPeerings` | _[virtualNetworkPeerings](virtualNetworkPeerings/readme.md)_ array | `[]` |  | Virtual Network Peerings configurations. |


### Parameter Usage: `subnets`

Below you can find an example for the subnet property's usage. For all remaining properties, please refer to the _[subnets](subnets/readme.md)_ readme.

<details>

<summary>Template JSON format</summary>

```json
"subnets": {
    "value": [
        {
            "name": "GatewaySubnet",
            "addressPrefix": "10.0.255.0/24"
        },
        {
            "name": "<<namePrefix>>-az-subnet-x-001",
            "addressPrefix": "10.0.0.0/24",
            "networkSecurityGroupId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/networkSecurityGroups/adp-<<namePrefix>>-az-nsg-x-001",
            "serviceEndpoints": [
                {
                    "service": "Microsoft.Storage"
                },
                {
                    "service": "Microsoft.Sql"
                }
            ],
            "routeTableId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/routeTables/adp-<<namePrefix>>-az-udr-x-001",
            "delegations": [
                {
                    "name": "netappDel",
                    "properties": {
                        "serviceName": "Microsoft.Netapp/volumes"
                    }
                }
            ],
            "privateEndpointNetworkPolicies": "Disabled",
            "privateLinkServiceNetworkPolicies": "Enabled"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
subnets: [
    {
        name: 'GatewaySubnet'
        addressPrefix: '10.0.255.0/24'
    }
    {
        name: '<<namePrefix>>-az-subnet-x-001'
        addressPrefix: '10.0.0.0/24'
        networkSecurityGroupId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/networkSecurityGroups/adp-<<namePrefix>>-az-nsg-x-001'
        serviceEndpoints: [
            {
                service: 'Microsoft.Storage'
            }
            {
                service: 'Microsoft.Sql'
            }
        ]
        routeTableId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/routeTables/adp-<<namePrefix>>-az-udr-x-001'
        delegations: [
            {
                name: 'netappDel'
                properties: {
                    serviceName: 'Microsoft.Netapp/volumes'
                }
            }
        ]
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
    }
]
```

</details>
<p>

### Parameter Usage: `virtualNetworkPeerings`

As the virtual network peering array allows you to deploy not only a one-way but also two-way peering (i.e reverse), you can use the following ***additional*** properties on top of what is documented in _[virtualNetworkPeerings](virtualNetworkPeerings/readme.md)_.

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `remotePeeringEnabled` | bool | `false` |  | Optional. Set to true to also deploy the reverse peering for the configured remote virtual networks to the local network |
| `remotePeeringName` | string | `'${last(split(peering.remoteVirtualNetworkId, '/'))}-${name}'` | | Optional. The Name of Vnet Peering resource. If not provided, default value will be <remoteVnetName>-<localVnetName> |
| `remotePeeringAllowForwardedTraffic` | bool | `true` | | Optional. Whether the forwarded traffic from the VMs in the local virtual network will be allowed/disallowed in remote virtual network. |
| `remotePeeringAllowGatewayTransit` | bool | `false` | | Optional. If gateway links can be used in remote virtual networking to link to this virtual network. |
| `remotePeeringAllowVirtualNetworkAccess` | bool | `true` | | Optional. Whether the VMs in the local virtual network space would be able to access the VMs in remote virtual network space. |
| `remotePeeringDoNotVerifyRemoteGateways` | bool | `true` | | Optional. If we need to verify the provisioning state of the remote gateway. |
| `remotePeeringUseRemoteGateways` | bool | `false` | |  Optional. If remote gateways can be used on this virtual network. If the flag is set to `true`, and allowGatewayTransit on local peering is also `true`, virtual network will use gateways of local virtual network for transit. Only one peering can have this flag set to `true`. This flag cannot be set if virtual network already has a gateway.  |

<details>

<summary>Parameter JSON format</summary>

```json
"virtualNetworkPeerings": {
    "value": [
        {
            "remoteVirtualNetworkId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-peer01",
            "allowForwardedTraffic": true,
            "allowGatewayTransit": false,
            "allowVirtualNetworkAccess": true,
            "useRemoteGateways": false,
            "remotePeeringEnabled": true,
            "remotePeeringName": "customName",
            "remotePeeringAllowVirtualNetworkAccess": true,
            "remotePeeringAllowForwardedTraffic": true
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
virtualNetworkPeerings: [
    {
        remoteVirtualNetworkId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-peer01'
        allowForwardedTraffic: true
        allowGatewayTransit: false
        allowVirtualNetworkAccess: true
        useRemoteGateways: false
        remotePeeringEnabled: true
        remotePeeringName: 'customName'
        remotePeeringAllowVirtualNetworkAccess: true
        remotePeeringAllowForwardedTraffic: true
    }
]
```

</details>
<p>

### Parameter Usage: `addressPrefixes`

The `addressPrefixes` parameter accepts a JSON Array of string values containing the IP Address Prefixes for the Virtual Network (vNet).

Here's an example of specifying a single Address Prefix:


<details>

<summary>Parameter JSON format</summary>

```json
"addressPrefixes": {
    "value": [
        "10.1.0.0/16"
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
addressPrefixes: [
    '10.1.0.0/16'
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

## Considerations

The network security group and route table resources must reside in the same resource group as the virtual network.

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `diagnosticsLogs` | array | The Diagnostic Settings of the virtual network. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the virtual network. |
| `resourceGroupName` | string | The resource group the virtual network was deployed into. |
| `resourceId` | string | The resource ID of the virtual network. |
| `subnetNames` | array | The names of the deployed subnets. |
| `subnetResourceIds` | array | The resource IDs of the deployed subnets. |

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
module virtualNetworks './Microsoft.Network/virtualNetworks/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nvncom'
  params: {
    // Required parameters
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    name: '<<namePrefix>>nvncom001'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    dnsServers: [
      '10.0.1.4'
      '10.0.1.5'
    ]
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
    subnets: [
      {
        addressPrefix: '10.0.255.0/24'
        name: 'GatewaySubnet'
      }
      {
        addressPrefix: '10.0.0.0/24'
        name: '<<namePrefix>>-az-subnet-x-001'
        networkSecurityGroupId: '<networkSecurityGroupId>'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        routeTableId: '<routeTableId>'
        serviceEndpoints: [
          {
            service: 'Microsoft.Storage'
          }
          {
            service: 'Microsoft.Sql'
          }
        ]
      }
      {
        addressPrefix: '10.0.3.0/24'
        delegations: [
          {
            name: 'netappDel'
            properties: {
              serviceName: 'Microsoft.Netapp/volumes'
            }
          }
        ]
        name: '<<namePrefix>>-az-subnet-x-002'
      }
      {
        addressPrefix: '10.0.6.0/24'
        name: '<<namePrefix>>-az-subnet-x-003'
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
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
    "addressPrefixes": {
      "value": [
        "10.0.0.0/16"
      ]
    },
    "name": {
      "value": "<<namePrefix>>nvncom001"
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
    "dnsServers": {
      "value": [
        "10.0.1.4",
        "10.0.1.5"
      ]
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
    },
    "subnets": {
      "value": [
        {
          "addressPrefix": "10.0.255.0/24",
          "name": "GatewaySubnet"
        },
        {
          "addressPrefix": "10.0.0.0/24",
          "name": "<<namePrefix>>-az-subnet-x-001",
          "networkSecurityGroupId": "<networkSecurityGroupId>",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "routeTableId": "<routeTableId>",
          "serviceEndpoints": [
            {
              "service": "Microsoft.Storage"
            },
            {
              "service": "Microsoft.Sql"
            }
          ]
        },
        {
          "addressPrefix": "10.0.3.0/24",
          "delegations": [
            {
              "name": "netappDel",
              "properties": {
                "serviceName": "Microsoft.Netapp/volumes"
              }
            }
          ],
          "name": "<<namePrefix>>-az-subnet-x-002"
        },
        {
          "addressPrefix": "10.0.6.0/24",
          "name": "<<namePrefix>>-az-subnet-x-003",
          "privateEndpointNetworkPolicies": "Disabled",
          "privateLinkServiceNetworkPolicies": "Enabled"
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
module virtualNetworks './Microsoft.Network/virtualNetworks/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nvnmin'
  params: {
    // Required parameters
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    name: '<<namePrefix>>nvnmin001'
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
    "addressPrefixes": {
      "value": [
        "10.0.0.0/16"
      ]
    },
    "name": {
      "value": "<<namePrefix>>nvnmin001"
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

<h3>Example 3: Vnetpeering</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworks './Microsoft.Network/virtualNetworks/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nvnpeer'
  params: {
    // Required parameters
    addressPrefixes: [
      '10.1.0.0/24'
    ]
    name: '<<namePrefix>>nvnpeer001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    subnets: [
      {
        addressPrefix: '10.1.0.0/26'
        name: 'GatewaySubnet'
      }
    ]
    virtualNetworkPeerings: [
      {
        allowForwardedTraffic: true
        allowGatewayTransit: false
        allowVirtualNetworkAccess: true
        remotePeeringAllowForwardedTraffic: true
        remotePeeringAllowVirtualNetworkAccess: true
        remotePeeringEnabled: true
        remotePeeringName: 'customName'
        remoteVirtualNetworkId: '<remoteVirtualNetworkId>'
        useRemoteGateways: false
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
    "addressPrefixes": {
      "value": [
        "10.1.0.0/24"
      ]
    },
    "name": {
      "value": "<<namePrefix>>nvnpeer001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "subnets": {
      "value": [
        {
          "addressPrefix": "10.1.0.0/26",
          "name": "GatewaySubnet"
        }
      ]
    },
    "virtualNetworkPeerings": {
      "value": [
        {
          "allowForwardedTraffic": true,
          "allowGatewayTransit": false,
          "allowVirtualNetworkAccess": true,
          "remotePeeringAllowForwardedTraffic": true,
          "remotePeeringAllowVirtualNetworkAccess": true,
          "remotePeeringEnabled": true,
          "remotePeeringName": "customName",
          "remoteVirtualNetworkId": "<remoteVirtualNetworkId>",
          "useRemoteGateways": false
        }
      ]
    }
  }
}
```

</details>
<p>
