# Virtual Network Gateways `[Microsoft.Network/virtualNetworkGateways]`

This module deploys a virtual network gateway.

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
| `Microsoft.Network/publicIPAddresses` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/publicIPAddresses) |
| `Microsoft.Network/virtualNetworkGateways` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/virtualNetworkGateways) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `name` | string |  | Specifies the Virtual Network Gateway name. |
| `virtualNetworkGatewaySku` | string | `[Basic, ErGw1AZ, ErGw2AZ, ErGw3AZ, HighPerformance, Standard, UltraPerformance, VpnGw1, VpnGw1AZ, VpnGw2, VpnGw2AZ, VpnGw3, VpnGw3AZ]` | The SKU of the Gateway. |
| `virtualNetworkGatewayType` | string | `[ExpressRoute, Vpn]` | Specifies the gateway type. E.g. VPN, ExpressRoute. |
| `vNetResourceId` | string |  | Virtual Network resource ID. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `activeActive` | bool | `True` |  | Value to specify if the Gateway should be deployed in active-active or active-passive configuration. |
| `activeGatewayPipName` | string | `[format('{0}-pip2', parameters('name'))]` |  | Specifies the name of the Public IP used by the Virtual Network Gateway when active-active configuration is required. If it's not provided, a '-pip' suffix will be appended to the gateway's name. |
| `asn` | int | `65815` |  | ASN value. |
| `clientRevokedCertThumbprint` | string | `''` |  | Thumbprint of the revoked certificate. This would revoke VPN client certificates matching this thumbprint from connecting to the VNet. |
| `clientRootCertData` | string | `''` |  | Client root certificate data used to authenticate VPN clients. Cannot be configured if vpnClientAadConfiguration is provided. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `domainNameLabel` | array | `[]` |  | DNS name(s) of the Public IP resource(s). If you enabled active-active configuration, you need to provide 2 DNS names, if you want to use this feature. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com. |
| `enableBgp` | bool | `True` |  | Value to specify if BGP is enabled or not. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `gatewayPipName` | string | `[format('{0}-pip1', parameters('name'))]` |  | Specifies the name of the Public IP used by the Virtual Network Gateway. If it's not provided, a '-pip' suffix will be appended to the gateway's name. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `publicIpdiagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, DDoSMitigationFlowLogs, DDoSMitigationReports, DDoSProtectionNotifications]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `publicIpDiagnosticSettingsName` | string | `'diagnosticSettings'` |  | The name of the diagnostic setting, if deployed. |
| `publicIPPrefixResourceId` | string | `''` |  | Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix. |
| `publicIpZones` | array | `[]` |  | Specifies the zones of the Public IP address. Basic IP SKU does not support Availability Zones. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `virtualNetworkGatewaydiagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, GatewayDiagnosticLog, IKEDiagnosticLog, P2SDiagnosticLog, RouteDiagnosticLog, TunnelDiagnosticLog]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `virtualNetworkGatewayDiagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `vpnClientAadConfiguration` | object | `{object}` |  | Configuration for AAD Authentication for P2S Tunnel Type, Cannot be configured if clientRootCertData is provided. |
| `vpnClientAddressPoolPrefix` | string | `''` |  | The IP address range from which VPN clients will receive an IP address when connected. Range specified must not overlap with on-premise network. |
| `vpnType` | string | `'RouteBased'` | `[PolicyBased, RouteBased]` | Specifies the VPN type. |


### Parameter Usage: `subnets`

The `subnets` parameter accepts a JSON Array of `subnet` objects to deploy to the Virtual Network.

Here's an example of specifying a couple Subnets to deploy:

<details>

<summary>Parameter JSON format</summary>

```json
"subnets": {
    "value": [
    {
        "name": "app",
        "properties": {
            "addressPrefix": "10.1.0.0/24",
            "networkSecurityGroup": {
                "id": "[resourceId('Microsoft.Network/networkSecurityGroups', 'app-nsg')]"
            },
            "routeTable": {
                "id": "[resourceId('Microsoft.Network/routeTables', 'app-udr')]"
            }
        }
    },
    {
        "name": "data",
        "properties": {
            "addressPrefix": "10.1.1.0/24"
        }
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
        name: 'app'
        properties: {
            addressPrefix: '10.1.0.0/24'
            networkSecurityGroup: {
                id: '[resourceId('Microsoft.Network/networkSecurityGroups' 'app-nsg')]'
            }
            routeTable: {
                id: '[resourceId('Microsoft.Network/routeTables' 'app-udr')]'
            }
        }
    }
    {
        name: 'data'
        properties: {
            addressPrefix: '10.1.1.0/24'
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
| `activeActive` | bool | Shows if the virtual network gateway is configured in active-active mode. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the virtual network gateway. |
| `resourceGroupName` | string | The resource group the virtual network gateway was deployed. |
| `resourceId` | string | The resource ID of the virtual network gateway. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `Microsoft.Network/publicIPAddresses` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Aadvpn</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateways './Microsoft.Network/virtualNetworkGateways/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nvngavpn'
  params: {
    // Required parameters
    name: '<<namePrefix>>nvngavpn001'
    virtualNetworkGatewaySku: 'VpnGw2AZ'
    virtualNetworkGatewayType: 'Vpn'
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    activeActive: false
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    domainNameLabel: [
      '<<namePrefix>>-dm-nvngavpn'
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    publicIpZones: [
      '1'
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
    vpnClientAadConfiguration: {
      aadAudience: '41b23e61-6c1e-4545-b367-cd054e0ed4b4'
      aadIssuer: '<aadIssuer>'
      aadTenant: '<aadTenant>'
      vpnAuthenticationTypes: [
        'AAD'
      ]
      vpnClientProtocols: [
        'OpenVPN'
      ]
    }
    vpnType: 'RouteBased'
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
      "value": "<<namePrefix>>nvngavpn001"
    },
    "virtualNetworkGatewaySku": {
      "value": "VpnGw2AZ"
    },
    "virtualNetworkGatewayType": {
      "value": "Vpn"
    },
    "vNetResourceId": {
      "value": "<vNetResourceId>"
    },
    // Non-required parameters
    "activeActive": {
      "value": false
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "domainNameLabel": {
      "value": [
        "<<namePrefix>>-dm-nvngavpn"
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "publicIpZones": {
      "value": [
        "1"
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
    "vpnClientAadConfiguration": {
      "value": {
        "aadAudience": "41b23e61-6c1e-4545-b367-cd054e0ed4b4",
        "aadIssuer": "<aadIssuer>",
        "aadTenant": "<aadTenant>",
        "vpnAuthenticationTypes": [
          "AAD"
        ],
        "vpnClientProtocols": [
          "OpenVPN"
        ]
      }
    },
    "vpnType": {
      "value": "RouteBased"
    }
  }
}
```

</details>
<p>

<h3>Example 2: Expressroute</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateways './Microsoft.Network/virtualNetworkGateways/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nvger'
  params: {
    // Required parameters
    name: '<<namePrefix>>nvger001'
    virtualNetworkGatewaySku: 'ErGw1AZ'
    virtualNetworkGatewayType: 'ExpressRoute'
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    domainNameLabel: [
      '<<namePrefix>>-dm-nvger'
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    gatewayPipName: '<<namePrefix>>-pip-nvger'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Contact: 'test.user@testcompany.com'
      CostCenter: ''
      Environment: 'Validation'
      PurchaseOrder: ''
      Role: 'DeploymentValidation'
      ServiceName: 'DeploymentValidation'
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
      "value": "<<namePrefix>>nvger001"
    },
    "virtualNetworkGatewaySku": {
      "value": "ErGw1AZ"
    },
    "virtualNetworkGatewayType": {
      "value": "ExpressRoute"
    },
    "vNetResourceId": {
      "value": "<vNetResourceId>"
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
    "domainNameLabel": {
      "value": [
        "<<namePrefix>>-dm-nvger"
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "gatewayPipName": {
      "value": "<<namePrefix>>-pip-nvger"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "Contact": "test.user@testcompany.com",
        "CostCenter": "",
        "Environment": "Validation",
        "PurchaseOrder": "",
        "Role": "DeploymentValidation",
        "ServiceName": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 3: Vpn</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateways './Microsoft.Network/virtualNetworkGateways/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nvgvpn'
  params: {
    // Required parameters
    name: '<<namePrefix>>nvgvpn001'
    virtualNetworkGatewaySku: 'VpnGw1AZ'
    virtualNetworkGatewayType: 'Vpn'
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    activeActive: true
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    domainNameLabel: [
      '<<namePrefix>>-dm-nvgvpn'
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    publicIpZones: [
      '1'
    ]
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    vpnType: 'RouteBased'
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
      "value": "<<namePrefix>>nvgvpn001"
    },
    "virtualNetworkGatewaySku": {
      "value": "VpnGw1AZ"
    },
    "virtualNetworkGatewayType": {
      "value": "Vpn"
    },
    "vNetResourceId": {
      "value": "<vNetResourceId>"
    },
    // Non-required parameters
    "activeActive": {
      "value": true
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
    "domainNameLabel": {
      "value": [
        "<<namePrefix>>-dm-nvgvpn"
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "publicIpZones": {
      "value": [
        "1"
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "vpnType": {
      "value": "RouteBased"
    }
  }
}
```

</details>
<p>
