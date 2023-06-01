# Web/Function Apps `[Microsoft.Web/sites]`

This module deploys a web or function app.

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
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-05-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-05-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Web/sites` | [2021-03-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2021-03-01/sites) |
| `Microsoft.Web/sites/config` | [2022-03-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/sites) |
| `Microsoft.Web/sites/slots` | [2022-03-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-03-01/sites/slots) |
| `Microsoft.Web/sites/slots/config` | [2022-03-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/sites) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `kind` | string | `[app, functionapp, functionapp,linux, functionapp,workflowapp, functionapp,workflowapp,linux]` | Type of site to deploy. |
| `name` | string |  | Name of the site. |
| `serverFarmResourceId` | string |  | The resource ID of the app service plan to use for the site. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `appInsightId` | string | `''` |  | Resource ID of the app insight to leverage for this resource. |
| `appServiceEnvironmentId` | string | `''` |  | The resource ID of the app service environment to use for this resource. |
| `appSettingsKeyValuePairs` | object | `{object}` |  | The app settings-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING. |
| `authSettingV2Configuration` | object | `{object}` |  | The auth settings V2 configuration. |
| `clientAffinityEnabled` | bool | `True` |  | If client affinity is enabled. |
| `clientCertEnabled` | bool | `False` |  | To enable client certificate authentication (TLS mutual authentication). |
| `clientCertExclusionPaths` | string | `''` |  | Client certificate authentication comma-separated exclusion paths. |
| `clientCertMode` | string | `'Optional'` | `[Optional, OptionalInteractiveUser, Required]` | This composes with ClientCertEnabled setting.<p>- ClientCertEnabled: false means ClientCert is ignored.<p>- ClientCertEnabled: true and ClientCertMode: Required means ClientCert is required.<p>- ClientCertEnabled: true and ClientCertMode: Optional means ClientCert is optional or accepted. |
| `cloningInfo` | object | `{object}` |  | If specified during app creation, the app is cloned from a source app. |
| `containerSize` | int | `-1` |  | Size of the function container. |
| `customDomainVerificationId` | string | `''` |  | Unique identifier that verifies the custom domains assigned to the app. Customer will add this ID to a txt record for verification. |
| `dailyMemoryTimeQuota` | int | `-1` |  | Maximum allowed daily memory-time quota (applicable on dynamic apps only). |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[if(equals(parameters('kind'), 'functionapp'), createArray('FunctionAppLogs'), createArray('AppServiceHTTPLogs', 'AppServiceConsoleLogs', 'AppServiceAppLogs', 'AppServiceAuditLogs', 'AppServiceIPSecAuditLogs', 'AppServicePlatformLogs'))]` | `[allLogs, AppServiceAppLogs, AppServiceAuditLogs, AppServiceConsoleLogs, AppServiceHTTPLogs, AppServiceIPSecAuditLogs, AppServicePlatformLogs, FunctionAppLogs]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of log analytics workspace. |
| `enabled` | bool | `True` |  | Setting this value to false disables the app (takes the app offline). |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `hostNameSslStates` | array | `[]` |  | Hostname SSL states are used to manage the SSL bindings for app's hostnames. |
| `httpsOnly` | bool | `True` |  | Configures a site to accept only HTTPS requests. Issues redirect for HTTP requests. |
| `hyperV` | bool | `False` |  | Hyper-V sandbox. |
| `keyVaultAccessIdentityResourceId` | string | `''` |  | The resource ID of the assigned identity to be used to access a key vault with. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `privateEndpoints` | array | `[]` |  | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| `redundancyMode` | string | `'None'` | `[ActiveActive, Failover, GeoRedundant, Manual, None]` | Site redundancy mode. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `setAzureWebJobsDashboard` | bool | `[if(contains(parameters('kind'), 'functionapp'), true(), false())]` |  | For function apps. If true the app settings "AzureWebJobsDashboard" will be set. If false not. In case you use Application Insights it can make sense to not set it for performance reasons. |
| `siteConfig` | object | `{object}` |  | The site config object. |
| `slots` | _[slots](slots/readme.md)_ array | `[]` |  | Configuration for deployment slots for an app. |
| `storageAccountId` | string | `''` |  | Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions. |
| `storageAccountRequired` | bool | `False` |  | Checks if Customer provided storage account is required. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `virtualNetworkSubnetId` | string | `''` |  | Azure Resource Manager ID of the Virtual network and subnet to be joined by Regional VNET Integration. This must be of the form /subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}. |


### Parameter Usage: `appSettingsKeyValuePairs`

AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING are set separately (check parameters storageAccountId, setAzureWebJobsDashboard, appInsightId).
For all other app settings key-value pairs use this object.

<details>

<summary>Parameter JSON format</summary>

```json
"appSettingsKeyValuePairs": {
    "value": {
      "AzureFunctionsJobHost__logging__logLevel__default": "Trace",
      "EASYAUTH_SECRET": "https://adp-<<namePrefix>>-az-kv-x-001.vault.azure.net/secrets/Modules-Test-SP-Password",
      "FUNCTIONS_EXTENSION_VERSION": "~4",
      "FUNCTIONS_WORKER_RUNTIME": "dotnet"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
appSettingsKeyValuePairs: {
  AzureFunctionsJobHost__logging__logLevel__default: 'Trace'
  EASYAUTH_SECRET: 'https://adp-<<namePrefix>>-az-kv-x-001.vault.azure.net/secrets/Modules-Test-SP-Password'
  FUNCTIONS_EXTENSION_VERSION: '~4'
  FUNCTIONS_WORKER_RUNTIME: 'dotnet'
}
```

</details>
<p>

### Parameter Usage: `authSettingV2Configuration`

The auth settings V2 configuration.

<details>

<summary>Parameter JSON format</summary>

```json
"siteConfig": {
    "value": [
        // Check out https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sites/config-authsettingsv2?tabs=bicep#siteauthsettingsv2properties for possible properties
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
siteConfig: [
    // Check out https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sites/config-authsettingsv2?tabs=bicep#siteauthsettingsv2properties for possible properties
]
```

</details>
<p>

### Parameter Usage: `siteConfig`

The site config.

<details>

<summary>Parameter JSON format</summary>

```json
"siteConfig": {
    "value": [
        // Check out https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/sites?tabs=bicep#siteconfig for possible properties
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
siteConfig: [
    // Check out https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/sites?tabs=bicep#siteconfig for possible properties
]
```

</details>
<p>

### Parameter Usage: `privateEndpoints`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`. Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.
- Although not strictly required, it is highly recommended to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

<details>

<summary>Parameter JSON format</summary>

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<serviceName>", // e.g. vault, registry, blob
            "privateDnsZoneGroup": {
                "privateDNSResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                    "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/<privateDnsZoneName>" // e.g. privatelink.vaultcore.azure.net, privatelink.azurecr.io, privatelink.blob.core.windows.net
                ]
            },
            "ipConfigurations":[
                {
                    "name": "myIPconfigTest02",
                    "properties": {
                        "groupId": "blob",
                        "memberName": "blob",
                        "privateIPAddress": "10.0.0.30"
                    }
                }
            ],
            "customDnsConfigs": [
                {
                    "fqdn": "customname.test.local",
                    "ipAddresses": [
                        "10.10.10.10"
                    ]
                }
            ]
        },
        // Example showing only mandatory fields
        {
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<serviceName>" // e.g. vault, registry, blob
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
privateEndpoints:  [
    // Example showing all available fields
    {
        name: 'sxx-az-pe' // Optional: Name will be automatically generated if one is not provided here
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<serviceName>' // e.g. vault, registry, blob
        privateDnsZoneGroup: {
            privateDNSResourceIds: [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/<privateDnsZoneName>' // e.g. privatelink.vaultcore.azure.net, privatelink.azurecr.io, privatelink.blob.core.windows.net
            ]
        }
        customDnsConfigs: [
            {
                fqdn: 'customname.test.local'
                ipAddresses: [
                    '10.10.10.10'
                ]
            }
        ]
        ipConfigurations:[
          {
            name: 'myIPconfigTest02'
            properties: {
              groupId: 'blob'
              memberName: 'blob'
              privateIPAddress: '10.0.0.30'
            }
          }
        ]
    }
    // Example showing only mandatory fields
    {
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<serviceName>' // e.g. vault, registry, blob
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
| `defaultHostname` | string | Default hostname of the app. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the site. |
| `resourceGroupName` | string | The resource group the site was deployed into. |
| `resourceId` | string | The resource ID of the site. |
| `slotResourceIds` | array | The list of the slot resource ids. |
| `slots` | array | The list of the slots. |
| `slotSystemAssignedPrincipalIds` | array | The principal ID of the system assigned identity of slots. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `Microsoft.Network/privateEndpoints` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Functionappcommon</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module sites './Microsoft.Web/sites/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-wsfacom'
  params: {
    // Required parameters
    kind: 'functionapp'
    name: '<<namePrefix>>wsfacom001'
    serverFarmResourceId: '<serverFarmResourceId>'
    // Non-required parameters
    appInsightId: '<appInsightId>'
    appSettingsKeyValuePairs: {
      AzureFunctionsJobHost__logging__logLevel__default: 'Trace'
      EASYAUTH_SECRET: '<EASYAUTH_SECRET>'
      FUNCTIONS_EXTENSION_VERSION: '~4'
      FUNCTIONS_WORKER_RUNTIME: 'dotnet'
    }
    authSettingV2Configuration: {
      globalValidation: {
        requireAuthentication: true
        unauthenticatedClientAction: 'Return401'
      }
      httpSettings: {
        forwardProxy: {
          convention: 'NoProxy'
        }
        requireHttps: true
        routes: {
          apiPrefix: '/.auth'
        }
      }
      identityProviders: {
        azureActiveDirectory: {
          enabled: true
          login: {
            disableWWWAuthenticate: false
          }
          registration: {
            clientId: 'd874dd2f-2032-4db1-a053-f0ec243685aa'
            clientSecretSettingName: 'EASYAUTH_SECRET'
            openIdIssuer: '<openIdIssuer>'
          }
          validation: {
            allowedAudiences: [
              'api://d874dd2f-2032-4db1-a053-f0ec243685aa'
            ]
            defaultAuthorizationPolicy: {
              allowedPrincipals: {}
            }
            jwtClaimChecks: {}
          }
        }
      }
      login: {
        allowedExternalRedirectUrls: [
          'string'
        ]
        cookieExpiration: {
          convention: 'FixedTime'
          timeToExpiration: '08:00:00'
        }
        nonce: {
          nonceExpirationInterval: '00:05:00'
          validateNonce: true
        }
        preserveUrlFragmentsForLogins: false
        routes: {}
        tokenStore: {
          azureBlobStorage: {}
          enabled: true
          fileSystem: {}
          tokenRefreshExtensionHours: 72
        }
      }
      platform: {
        enabled: true
        runtimeVersion: '~1'
      }
    }
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    keyVaultAccessIdentityResourceId: '<keyVaultAccessIdentityResourceId>'
    lock: 'CanNotDelete'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSZoneResourceId>'
          ]
        }
        service: 'sites'
        subnetResourceId: '<subnetResourceId>'
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
    setAzureWebJobsDashboard: true
    siteConfig: {
      alwaysOn: true
      use32BitWorkerProcess: false
    }
    storageAccountId: '<storageAccountId>'
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
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
    "kind": {
      "value": "functionapp"
    },
    "name": {
      "value": "<<namePrefix>>wsfacom001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
    },
    // Non-required parameters
    "appInsightId": {
      "value": "<appInsightId>"
    },
    "appSettingsKeyValuePairs": {
      "value": {
        "AzureFunctionsJobHost__logging__logLevel__default": "Trace",
        "EASYAUTH_SECRET": "<EASYAUTH_SECRET>",
        "FUNCTIONS_EXTENSION_VERSION": "~4",
        "FUNCTIONS_WORKER_RUNTIME": "dotnet"
      }
    },
    "authSettingV2Configuration": {
      "value": {
        "globalValidation": {
          "requireAuthentication": true,
          "unauthenticatedClientAction": "Return401"
        },
        "httpSettings": {
          "forwardProxy": {
            "convention": "NoProxy"
          },
          "requireHttps": true,
          "routes": {
            "apiPrefix": "/.auth"
          }
        },
        "identityProviders": {
          "azureActiveDirectory": {
            "enabled": true,
            "login": {
              "disableWWWAuthenticate": false
            },
            "registration": {
              "clientId": "d874dd2f-2032-4db1-a053-f0ec243685aa",
              "clientSecretSettingName": "EASYAUTH_SECRET",
              "openIdIssuer": "<openIdIssuer>"
            },
            "validation": {
              "allowedAudiences": [
                "api://d874dd2f-2032-4db1-a053-f0ec243685aa"
              ],
              "defaultAuthorizationPolicy": {
                "allowedPrincipals": {}
              },
              "jwtClaimChecks": {}
            }
          }
        },
        "login": {
          "allowedExternalRedirectUrls": [
            "string"
          ],
          "cookieExpiration": {
            "convention": "FixedTime",
            "timeToExpiration": "08:00:00"
          },
          "nonce": {
            "nonceExpirationInterval": "00:05:00",
            "validateNonce": true
          },
          "preserveUrlFragmentsForLogins": false,
          "routes": {},
          "tokenStore": {
            "azureBlobStorage": {},
            "enabled": true,
            "fileSystem": {},
            "tokenRefreshExtensionHours": 72
          }
        },
        "platform": {
          "enabled": true,
          "runtimeVersion": "~1"
        }
      }
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
    "keyVaultAccessIdentityResourceId": {
      "value": "<keyVaultAccessIdentityResourceId>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSZoneResourceId>"
            ]
          },
          "service": "sites",
          "subnetResourceId": "<subnetResourceId>"
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
    "setAzureWebJobsDashboard": {
      "value": true
    },
    "siteConfig": {
      "value": {
        "alwaysOn": true,
        "use32BitWorkerProcess": false
      }
    },
    "storageAccountId": {
      "value": "<storageAccountId>"
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>

<h3>Example 2: Functionappmin</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module sites './Microsoft.Web/sites/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-wsfamin'
  params: {
    // Required parameters
    kind: 'functionapp'
    name: '<<namePrefix>>wsfamin001'
    serverFarmResourceId: '<serverFarmResourceId>'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    siteConfig: {
      alwaysOn: true
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
    "kind": {
      "value": "functionapp"
    },
    "name": {
      "value": "<<namePrefix>>wsfamin001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "siteConfig": {
      "value": {
        "alwaysOn": true
      }
    }
  }
}
```

</details>
<p>

<h3>Example 3: Webappcommon</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module sites './Microsoft.Web/sites/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-wswa'
  params: {
    // Required parameters
    kind: 'app'
    name: '<<namePrefix>>wswa001'
    serverFarmResourceId: '<serverFarmResourceId>'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    httpsOnly: true
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSZoneResourceId>'
          ]
        }
        service: 'sites'
        subnetResourceId: '<subnetResourceId>'
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
    siteConfig: {
      alwaysOn: true
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnetcore'
        }
      ]
    }
    slots: [
      {
        diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
        diagnosticEventHubName: '<diagnosticEventHubName>'
        diagnosticLogsRetentionInDays: 7
        diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
        diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
        name: 'slot1'
        privateEndpoints: [
          {
            privateDnsZoneGroup: {
              privateDNSResourceIds: [
                '<privateDNSZoneResourceId>'
              ]
            }
            service: 'sites'
            subnetResourceId: '<subnetResourceId>'
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
        siteConfig: {
          alwaysOn: true
          metadata: [
            {
              name: 'CURRENT_STACK'
              value: 'dotnetcore'
            }
          ]
        }
      }
      {
        name: 'slot2'
      }
    ]
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
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
    "kind": {
      "value": "app"
    },
    "name": {
      "value": "<<namePrefix>>wswa001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
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
    "httpsOnly": {
      "value": true
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSZoneResourceId>"
            ]
          },
          "service": "sites",
          "subnetResourceId": "<subnetResourceId>"
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
    "siteConfig": {
      "value": {
        "alwaysOn": true,
        "metadata": [
          {
            "name": "CURRENT_STACK",
            "value": "dotnetcore"
          }
        ]
      }
    },
    "slots": {
      "value": [
        {
          "diagnosticEventHubAuthorizationRuleId": "<diagnosticEventHubAuthorizationRuleId>",
          "diagnosticEventHubName": "<diagnosticEventHubName>",
          "diagnosticLogsRetentionInDays": 7,
          "diagnosticStorageAccountId": "<diagnosticStorageAccountId>",
          "diagnosticWorkspaceId": "<diagnosticWorkspaceId>",
          "name": "slot1",
          "privateEndpoints": [
            {
              "privateDnsZoneGroup": {
                "privateDNSResourceIds": [
                  "<privateDNSZoneResourceId>"
                ]
              },
              "service": "sites",
              "subnetResourceId": "<subnetResourceId>"
            }
          ],
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "siteConfig": {
            "alwaysOn": true,
            "metadata": [
              {
                "name": "CURRENT_STACK",
                "value": "dotnetcore"
              }
            ]
          }
        },
        {
          "name": "slot2"
        }
      ]
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>

<h3>Example 4: Webappmin</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module sites './Microsoft.Web/sites/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-wswamin'
  params: {
    // Required parameters
    kind: 'app'
    name: '<<namePrefix>>wswamin001'
    serverFarmResourceId: '<serverFarmResourceId>'
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
    "kind": {
      "value": "app"
    },
    "name": {
      "value": "<<namePrefix>>wswamin001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
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
