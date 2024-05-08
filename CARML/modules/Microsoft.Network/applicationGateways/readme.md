# Network Application Gateways `[Microsoft.Network/applicationGateways]`

This module deploys Network ApplicationGateways.

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
| `Microsoft.Network/applicationGateways` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/applicationGateways) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Application Gateway. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `authenticationCertificates` | array | `[]` |  | Authentication certificates of the application gateway resource. |
| `autoscaleMaxCapacity` | int | `-1` |  | Upper bound on number of Application Gateway capacity. |
| `autoscaleMinCapacity` | int | `-1` |  | Lower bound on number of Application Gateway capacity. |
| `backendAddressPools` | array | `[]` |  | Backend address pool of the application gateway resource. |
| `backendHttpSettingsCollection` | array | `[]` |  | Backend http settings of the application gateway resource. |
| `capacity` | int | `2` |  | The number of Application instances to be configured. |
| `customErrorConfigurations` | array | `[]` |  | Custom error configurations of the application gateway resource. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, ApplicationGatewayAccessLog, ApplicationGatewayFirewallLog, ApplicationGatewayPerformanceLog]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enableFips` | bool | `False` |  | Whether FIPS is enabled on the application gateway resource. |
| `enableHttp2` | bool | `False` |  | Whether HTTP2 is enabled on the application gateway resource. |
| `enableRequestBuffering` | bool | `False` |  | Enable request buffering. |
| `enableResponseBuffering` | bool | `False` |  | Enable response buffering. |
| `firewallPolicyId` | string | `''` |  | The resource ID of an associated firewall policy. Should be configured for security reasons. |
| `frontendIPConfigurations` | array | `[]` |  | Frontend IP addresses of the application gateway resource. |
| `frontendPorts` | array | `[]` |  | Frontend ports of the application gateway resource. |
| `gatewayIPConfigurations` | array | `[]` |  | Subnets of the application gateway resource. |
| `httpListeners` | array | `[]` |  | Http listeners of the application gateway resource. |
| `loadDistributionPolicies` | array | `[]` |  | Load distribution policies of the application gateway resource. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `privateLinkConfigurations` | array | `[]` |  | PrivateLink configurations on application gateway. |
| `probes` | array | `[]` |  | Probes of the application gateway resource. |
| `redirectConfigurations` | array | `[]` |  | Redirect configurations of the application gateway resource. |
| `requestRoutingRules` | array | `[]` |  | Request routing rules of the application gateway resource. |
| `rewriteRuleSets` | array | `[]` |  | Rewrite rules for the application gateway resource. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `sku` | string | `'WAF_Medium'` | `[Standard_Large, Standard_Medium, Standard_Small, Standard_v2, WAF_Large, WAF_Medium, WAF_v2]` | The name of the SKU for the Application Gateway. |
| `sslCertificates` | array | `[]` |  | SSL certificates of the application gateway resource. |
| `sslPolicyCipherSuites` | array | `[TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384]` | `[TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA, TLS_DHE_DSS_WITH_AES_128_CBC_SHA, TLS_DHE_DSS_WITH_AES_128_CBC_SHA256, TLS_DHE_DSS_WITH_AES_256_CBC_SHA, TLS_DHE_DSS_WITH_AES_256_CBC_SHA256, TLS_DHE_RSA_WITH_AES_128_CBC_SHA, TLS_DHE_RSA_WITH_AES_128_GCM_SHA256, TLS_DHE_RSA_WITH_AES_256_CBC_SHA, TLS_DHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_RSA_WITH_3DES_EDE_CBC_SHA, TLS_RSA_WITH_AES_128_CBC_SHA, TLS_RSA_WITH_AES_128_CBC_SHA256, TLS_RSA_WITH_AES_128_GCM_SHA256, TLS_RSA_WITH_AES_256_CBC_SHA, TLS_RSA_WITH_AES_256_CBC_SHA256, TLS_RSA_WITH_AES_256_GCM_SHA384]` | Ssl cipher suites to be enabled in the specified order to application gateway. |
| `sslPolicyMinProtocolVersion` | string | `'TLSv1_2'` | `[TLSv1_0, TLSv1_1, TLSv1_2]` | Ssl protocol enums. |
| `sslPolicyName` | string | `''` | `['', AppGwSslPolicy20150501, AppGwSslPolicy20170401, AppGwSslPolicy20170401S]` | Ssl predefined policy name enums. |
| `sslPolicyType` | string | `'Custom'` | `[Custom, Predefined]` | Type of Ssl Policy. |
| `sslProfiles` | array | `[]` |  | SSL profiles of the application gateway resource. |
| `tags` | object | `{object}` |  | Resource tags. |
| `trustedClientCertificates` | array | `[]` |  | Trusted client certificates of the application gateway resource. |
| `trustedRootCertificates` | array | `[]` |  | Trusted Root certificates of the application gateway resource. |
| `urlPathMaps` | array | `[]` |  | URL path map of the application gateway resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `webApplicationFirewallConfiguration` | object | `{object}` |  | Application gateway web application firewall configuration. Should be configured for security reasons. |
| `zones` | array | `[]` |  | A list of availability zones denoting where the resource needs to come from. |


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

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the application gateway. |
| `resourceGroupName` | string | The resource group the application gateway was deployed into. |
| `resourceId` | string | The resource ID of the application gateway. |

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
module applicationGateways './Microsoft.Network/applicationGateways/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nagcom'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    backendAddressPools: [
      {
        name: 'appServiceBackendPool'
        properties: {
          backendAddresses: [
            {
              fqdn: 'aghapp.azurewebsites.net'
            }
          ]
        }
      }
      {
        name: 'privateVmBackendPool'
        properties: {
          backendAddresses: [
            {
              ipAddress: '10.0.0.4'
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'appServiceBackendHttpsSetting'
        properties: {
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          port: 443
          protocol: 'Https'
          requestTimeout: 30
        }
      }
      {
        name: 'privateVmHttpSetting'
        properties: {
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          port: 80
          probe: {
            id: '<id>'
          }
          protocol: 'Http'
          requestTimeout: 30
        }
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enableHttp2: true
    frontendIPConfigurations: [
      {
        name: 'private'
        properties: {
          privateIPAddress: '10.0.0.20'
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: '<id>'
          }
        }
      }
      {
        name: 'public'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: '<id>'
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port443'
        properties: {
          port: 443
        }
      }
      {
        name: 'port4433'
        properties: {
          port: 4433
        }
      }
      {
        name: 'port80'
        properties: {
          port: 80
        }
      }
      {
        name: 'port8080'
        properties: {
          port: 8080
        }
      }
    ]
    gatewayIPConfigurations: [
      {
        name: 'apw-ip-configuration'
        properties: {
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    httpListeners: [
      {
        name: 'public443'
        properties: {
          frontendIPConfiguration: {
            id: '<id>'
          }
          frontendPort: {
            id: '<id>'
          }
          hostNames: []
          protocol: 'https'
          requireServerNameIndication: false
          sslCertificate: {
            id: '<id>'
          }
        }
      }
      {
        name: 'private4433'
        properties: {
          frontendIPConfiguration: {
            id: '<id>'
          }
          frontendPort: {
            id: '<id>'
          }
          hostNames: []
          protocol: 'https'
          requireServerNameIndication: false
          sslCertificate: {
            id: '<id>'
          }
        }
      }
      {
        name: 'httpRedirect80'
        properties: {
          frontendIPConfiguration: {
            id: '<id>'
          }
          frontendPort: {
            id: '<id>'
          }
          hostNames: []
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
      {
        name: 'httpRedirect8080'
        properties: {
          frontendIPConfiguration: {
            id: '<id>'
          }
          frontendPort: {
            id: '<id>'
          }
          hostNames: []
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
    ]
    lock: 'CanNotDelete'
    probes: [
      {
        name: 'privateVmHttpSettingProbe'
        properties: {
          host: '10.0.0.4'
          interval: 60
          match: {
            statusCodes: [
              '200'
              '401'
            ]
          }
          minServers: 3
          path: '/'
          pickHostNameFromBackendHttpSettings: false
          protocol: 'Http'
          timeout: 15
          unhealthyThreshold: 5
        }
      }
    ]
    redirectConfigurations: [
      {
        name: 'httpRedirect80'
        properties: {
          includePath: true
          includeQueryString: true
          redirectType: 'Permanent'
          requestRoutingRules: [
            {
              id: '<id>'
            }
          ]
          targetListener: {
            id: '<id>'
          }
        }
      }
      {
        name: 'httpRedirect8080'
        properties: {
          includePath: true
          includeQueryString: true
          redirectType: 'Permanent'
          requestRoutingRules: [
            {
              id: '<id>'
            }
          ]
          targetListener: {
            id: '<id>'
          }
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'public443-appServiceBackendHttpsSetting-appServiceBackendHttpsSetting'
        properties: {
          backendAddressPool: {
            id: '<id>'
          }
          backendHttpSettings: {
            id: '<id>'
          }
          httpListener: {
            id: '<id>'
          }
          priority: 200
          ruleType: 'Basic'
        }
      }
      {
        name: 'private4433-privateVmHttpSetting-privateVmHttpSetting'
        properties: {
          backendAddressPool: {
            id: '<id>'
          }
          backendHttpSettings: {
            id: '<id>'
          }
          httpListener: {
            id: '<id>'
          }
          priority: 250
          ruleType: 'Basic'
        }
      }
      {
        name: 'httpRedirect80-public443'
        properties: {
          httpListener: {
            id: '<id>'
          }
          priority: 300
          redirectConfiguration: {
            id: '<id>'
          }
          ruleType: 'Basic'
        }
      }
      {
        name: 'httpRedirect8080-private4433'
        properties: {
          httpListener: {
            id: '<id>'
          }
          priority: 350
          redirectConfiguration: {
            id: '<id>'
          }
          ruleType: 'Basic'
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
    sku: 'WAF_v2'
    sslCertificates: [
      {
        name: '<<namePrefix>>-az-apgw-x-001-ssl-certificate'
        properties: {
          keyVaultSecretId: '<keyVaultSecretId>'
        }
      }
    ]
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
    webApplicationFirewallConfiguration: {
      disabledRuleGroups: []
      enabled: true
      fileUploadLimitInMb: 100
      firewallMode: 'Detection'
      maxRequestBodySizeInKb: 128
      requestBodyCheck: true
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.0'
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
      "value": "<name>"
    },
    // Non-required parameters
    "backendAddressPools": {
      "value": [
        {
          "name": "appServiceBackendPool",
          "properties": {
            "backendAddresses": [
              {
                "fqdn": "aghapp.azurewebsites.net"
              }
            ]
          }
        },
        {
          "name": "privateVmBackendPool",
          "properties": {
            "backendAddresses": [
              {
                "ipAddress": "10.0.0.4"
              }
            ]
          }
        }
      ]
    },
    "backendHttpSettingsCollection": {
      "value": [
        {
          "name": "appServiceBackendHttpsSetting",
          "properties": {
            "cookieBasedAffinity": "Disabled",
            "pickHostNameFromBackendAddress": true,
            "port": 443,
            "protocol": "Https",
            "requestTimeout": 30
          }
        },
        {
          "name": "privateVmHttpSetting",
          "properties": {
            "cookieBasedAffinity": "Disabled",
            "pickHostNameFromBackendAddress": false,
            "port": 80,
            "probe": {
              "id": "<id>"
            },
            "protocol": "Http",
            "requestTimeout": 30
          }
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
    "enableHttp2": {
      "value": true
    },
    "frontendIPConfigurations": {
      "value": [
        {
          "name": "private",
          "properties": {
            "privateIPAddress": "10.0.0.20",
            "privateIPAllocationMethod": "Static",
            "subnet": {
              "id": "<id>"
            }
          }
        },
        {
          "name": "public",
          "properties": {
            "privateIPAllocationMethod": "Dynamic",
            "publicIPAddress": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "frontendPorts": {
      "value": [
        {
          "name": "port443",
          "properties": {
            "port": 443
          }
        },
        {
          "name": "port4433",
          "properties": {
            "port": 4433
          }
        },
        {
          "name": "port80",
          "properties": {
            "port": 80
          }
        },
        {
          "name": "port8080",
          "properties": {
            "port": 8080
          }
        }
      ]
    },
    "gatewayIPConfigurations": {
      "value": [
        {
          "name": "apw-ip-configuration",
          "properties": {
            "subnet": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "httpListeners": {
      "value": [
        {
          "name": "public443",
          "properties": {
            "frontendIPConfiguration": {
              "id": "<id>"
            },
            "frontendPort": {
              "id": "<id>"
            },
            "hostNames": [],
            "protocol": "https",
            "requireServerNameIndication": false,
            "sslCertificate": {
              "id": "<id>"
            }
          }
        },
        {
          "name": "private4433",
          "properties": {
            "frontendIPConfiguration": {
              "id": "<id>"
            },
            "frontendPort": {
              "id": "<id>"
            },
            "hostNames": [],
            "protocol": "https",
            "requireServerNameIndication": false,
            "sslCertificate": {
              "id": "<id>"
            }
          }
        },
        {
          "name": "httpRedirect80",
          "properties": {
            "frontendIPConfiguration": {
              "id": "<id>"
            },
            "frontendPort": {
              "id": "<id>"
            },
            "hostNames": [],
            "protocol": "Http",
            "requireServerNameIndication": false
          }
        },
        {
          "name": "httpRedirect8080",
          "properties": {
            "frontendIPConfiguration": {
              "id": "<id>"
            },
            "frontendPort": {
              "id": "<id>"
            },
            "hostNames": [],
            "protocol": "Http",
            "requireServerNameIndication": false
          }
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "probes": {
      "value": [
        {
          "name": "privateVmHttpSettingProbe",
          "properties": {
            "host": "10.0.0.4",
            "interval": 60,
            "match": {
              "statusCodes": [
                "200",
                "401"
              ]
            },
            "minServers": 3,
            "path": "/",
            "pickHostNameFromBackendHttpSettings": false,
            "protocol": "Http",
            "timeout": 15,
            "unhealthyThreshold": 5
          }
        }
      ]
    },
    "redirectConfigurations": {
      "value": [
        {
          "name": "httpRedirect80",
          "properties": {
            "includePath": true,
            "includeQueryString": true,
            "redirectType": "Permanent",
            "requestRoutingRules": [
              {
                "id": "<id>"
              }
            ],
            "targetListener": {
              "id": "<id>"
            }
          }
        },
        {
          "name": "httpRedirect8080",
          "properties": {
            "includePath": true,
            "includeQueryString": true,
            "redirectType": "Permanent",
            "requestRoutingRules": [
              {
                "id": "<id>"
              }
            ],
            "targetListener": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "requestRoutingRules": {
      "value": [
        {
          "name": "public443-appServiceBackendHttpsSetting-appServiceBackendHttpsSetting",
          "properties": {
            "backendAddressPool": {
              "id": "<id>"
            },
            "backendHttpSettings": {
              "id": "<id>"
            },
            "httpListener": {
              "id": "<id>"
            },
            "priority": 200,
            "ruleType": "Basic"
          }
        },
        {
          "name": "private4433-privateVmHttpSetting-privateVmHttpSetting",
          "properties": {
            "backendAddressPool": {
              "id": "<id>"
            },
            "backendHttpSettings": {
              "id": "<id>"
            },
            "httpListener": {
              "id": "<id>"
            },
            "priority": 250,
            "ruleType": "Basic"
          }
        },
        {
          "name": "httpRedirect80-public443",
          "properties": {
            "httpListener": {
              "id": "<id>"
            },
            "priority": 300,
            "redirectConfiguration": {
              "id": "<id>"
            },
            "ruleType": "Basic"
          }
        },
        {
          "name": "httpRedirect8080-private4433",
          "properties": {
            "httpListener": {
              "id": "<id>"
            },
            "priority": 350,
            "redirectConfiguration": {
              "id": "<id>"
            },
            "ruleType": "Basic"
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
    "sku": {
      "value": "WAF_v2"
    },
    "sslCertificates": {
      "value": [
        {
          "name": "<<namePrefix>>-az-apgw-x-001-ssl-certificate",
          "properties": {
            "keyVaultSecretId": "<keyVaultSecretId>"
          }
        }
      ]
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    },
    "webApplicationFirewallConfiguration": {
      "value": {
        "disabledRuleGroups": [],
        "enabled": true,
        "fileUploadLimitInMb": 100,
        "firewallMode": "Detection",
        "maxRequestBodySizeInKb": 128,
        "requestBodyCheck": true,
        "ruleSetType": "OWASP",
        "ruleSetVersion": "3.0"
      }
    }
  }
}
```

</details>
<p>
