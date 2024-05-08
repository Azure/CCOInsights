# Storage Accounts `[Microsoft.Storage/storageAccounts]`

This module is used to deploy a storage account, with the ability to deploy 1 or more blob containers, file shares, tables and queues. Optional ACLs can be configured on the storage account and optional RBAC can be assigned on the storage account and on each child resource.

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
| `Microsoft.Network/privateEndpoints` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-05-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-05-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Storage/storageAccounts` | [2022-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2021-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2021-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2021-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |
| `Microsoft.Storage/storageAccounts/fileServices` | [2021-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/fileServices) |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | [2021-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/fileServices/shares) |
| `Microsoft.Storage/storageAccounts/localUsers` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-05-01/storageAccounts/localUsers) |
| `Microsoft.Storage/storageAccounts/managementPolicies` | [2021-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/managementPolicies) |
| `Microsoft.Storage/storageAccounts/queueServices` | [2021-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/queueServices) |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | [2021-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/queueServices/queues) |
| `Microsoft.Storage/storageAccounts/tableServices` | [2021-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/tableServices) |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | [2021-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/tableServices/tables) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Storage Account. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `cMKKeyVaultResourceId` | string | `''` | The resource ID of a key vault to reference a customer managed key for encryption from. Required if 'cMKKeyName' is not empty. |
| `cMKUserAssignedIdentityResourceId` | string | `''` | User assigned identity to use when fetching the customer managed key. Required if 'cMKKeyName' is not empty. |
| `enableHierarchicalNamespace` | bool | `False` | If true, enables Hierarchical Namespace for the storage account. Required if enableSftp or enableNfsV3 is set to true. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowBlobPublicAccess` | bool | `False` |  | Indicates whether public access is enabled for all blobs or containers in the storage account. For security reasons, it is recommended to set it to false. |
| `allowCrossTenantReplication` | bool | `True` |  | Allow or disallow cross AAD tenant object replication. |
| `allowedCopyScope` | string | `''` | `['', AAD, PrivateLink]` | Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet. |
| `allowSharedKeyAccess` | bool | `True` |  | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is null, which is equivalent to true. |
| `azureFilesIdentityBasedAuthentication` | object | `{object}` |  | Provides the identity based authentication settings for Azure Files. |
| `blobServices` | _[blobServices](blobServices/readme.md)_ object | `{object}` |  | Blob service and containers to deploy. |
| `cMKKeyName` | string | `''` |  | The name of the customer managed key to use for encryption. Cannot be deployed together with the parameter 'systemAssignedIdentity' enabled. |
| `cMKKeyVersion` | string | `''` |  | The version of the customer managed key to reference for encryption. If not provided, latest is used. |
| `customDomainName` | string | `''` |  | Sets the custom domain name assigned to the storage account. Name is the CNAME source. |
| `customDomainUseSubDomainName` | bool | `False` |  | Indicates whether indirect CName validation is enabled. This should only be set on updates. |
| `defaultToOAuthAuthentication` | bool | `False` |  | A boolean flag which indicates whether the default authentication is OAuth or not. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[Transaction]` | `[Transaction]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `dnsEndpointType` | string | `''` | `['', AzureDnsZone, Standard]` | Allows you to specify the type of endpoint. Set this to AzureDNSZone to create a large number of accounts in a single subscription, which creates accounts in an Azure DNS Zone and the endpoint URL will have an alphanumeric DNS Zone identifier. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enableNfsV3` | bool | `False` |  | If true, enables NFS 3.0 support for the storage account. Requires enableHierarchicalNamespace to be true. |
| `enableSftp` | bool | `False` |  | If true, enables Secure File Transfer Protocol for the storage account. Requires enableHierarchicalNamespace to be true. |
| `fileServices` | _[fileServices](fileServices/readme.md)_ object | `{object}` |  | File service and shares to deploy. |
| `isLocalUserEnabled` | bool | `False` |  | Enables local users feature, if set to true. |
| `largeFileSharesState` | string | `'Disabled'` | `[Disabled, Enabled]` | Allow large file shares if sets to 'Enabled'. It cannot be disabled once it is enabled. Only supported on locally redundant and zone redundant file shares. It cannot be set on FileStorage storage accounts (storage accounts for premium file shares). |
| `localUsers` | _[localUsers](localUsers/readme.md)_ array | `[]` |  | Local users to deploy for SFTP authentication. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `managementPolicyRules` | array | `[]` |  | The Storage Account ManagementPolicies Rules. |
| `minimumTlsVersion` | string | `'TLS1_2'` | `[TLS1_0, TLS1_1, TLS1_2]` | Set the minimum TLS version on request to storage. |
| `networkAcls` | object | `{object}` |  | Networks ACLs, this value contains IPs to whitelist and/or Subnet information. For security reasons, it is recommended to set the DefaultAction Deny. |
| `privateEndpoints` | array | `[]` |  | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| `publicNetworkAccess` | string | `''` | `['', Disabled, Enabled]` | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set. |
| `queueServices` | _[queueServices](queueServices/readme.md)_ object | `{object}` |  | Queue service and queues to create. |
| `requireInfrastructureEncryption` | bool | `True` |  | A Boolean indicating whether or not the service applies a secondary layer of encryption with platform managed keys for data at rest. For security reasons, it is recommended to set it to true. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `storageAccountAccessTier` | string | `'Hot'` | `[Cool, Hot, Premium]` | Storage Account Access Tier. |
| `storageAccountKind` | string | `'StorageV2'` | `[BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2]` | Type of Storage Account to create. |
| `storageAccountSku` | string | `'Standard_GRS'` | `[Premium_LRS, Premium_ZRS, Standard_GRS, Standard_GZRS, Standard_LRS, Standard_RAGRS, Standard_RAGZRS, Standard_ZRS]` | Storage Account Sku Name. |
| `supportsHttpsTrafficOnly` | bool | `True` |  | Allows HTTPS traffic only to storage service if sets to true. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tableServices` | _[tableServices](tableServices/readme.md)_ object | `{object}` |  | Table service and tables to create. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |


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

### Parameter Usage: `networkAcls`

<details>

<summary>Parameter JSON format</summary>

```json
"networkAcls": {
    "value": {
        "bypass": "AzureServices",
        "defaultAction": "Deny",
        "virtualNetworkRules": [
            {
                "action": "Allow",
                "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001"
            }
        ],
        "ipRules": [
            {
                "action": "Allow",
                "value": "1.1.1.1"
            }
        ]
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
networkAcls: {
    bypass: 'AzureServices'
    defaultAction: 'Deny'
    virtualNetworkRules: [
        {
            action: 'Allow'
            id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        }
    ]
    ipRules: [
        {
            action: 'Allow'
            value: '1.1.1.1'
        }
    ]
}
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
| `name` | string | The name of the deployed storage account. |
| `primaryBlobEndpoint` | string | The primary blob endpoint reference if blob services are deployed. |
| `resourceGroupName` | string | The resource group of the deployed storage account. |
| `resourceId` | string | The resource ID of the deployed storage account. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Considerations

This is a generic module for deploying a Storage Account. Any customization for different storage needs (such as a diagnostic or other storage account) need to be done through the Archetype.
The hierarchical namespace of the storage account (see parameter `enableHierarchicalNamespace`), can be only set at creation time.

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `Microsoft.Network/privateEndpoints` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module storageAccounts './Microsoft.Storage/storageAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-ssacom'
  params: {
    // Required parameters
    name: '<<namePrefix>>ssacom001'
    // Non-required parameters
    allowBlobPublicAccess: false
    blobServices: {
      containers: [
        {
          name: 'avdscripts'
          publicAccess: 'None'
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
        {
          allowProtectedAppendWrites: false
          enableWORM: true
          name: 'archivecontainer'
          publicAccess: 'None'
          WORMRetention: 666
        }
      ]
      diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
      diagnosticEventHubName: '<diagnosticEventHubName>'
      diagnosticLogsRetentionInDays: 7
      diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
      diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    }
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enableHierarchicalNamespace: true
    enableNfsV3: true
    enableSftp: true
    fileServices: {
      diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
      diagnosticEventHubName: '<diagnosticEventHubName>'
      diagnosticLogsRetentionInDays: 7
      diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
      diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
      shares: [
        {
          name: 'avdprofiles'
          roleAssignments: [
            {
              principalIds: [
                '<managedIdentityPrincipalId>'
              ]
              principalType: 'ServicePrincipal'
              roleDefinitionIdOrName: 'Reader'
            }
          ]
          shareQuota: 5120
        }
        {
          name: 'avdprofiles2'
          shareQuota: 102400
        }
      ]
    }
    largeFileSharesState: 'Enabled'
    localUsers: [
      {
        hasSharedKey: false
        hasSshKey: true
        hasSshPassword: false
        homeDirectory: 'avdscripts'
        name: 'testuser'
        permissionScopes: [
          {
            permissions: 'r'
            resourceName: 'avdscripts'
            service: 'blob'
          }
        ]
        storageAccountName: '<<namePrefix>>ssacom001'
      }
    ]
    lock: 'CanNotDelete'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: [
        {
          action: 'Allow'
          value: '1.1.1.1'
        }
      ]
      virtualNetworkRules: [
        {
          action: 'Allow'
          id: '<id>'
        }
      ]
    }
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSZoneResourceId>'
          ]
        }
        service: 'blob'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    queueServices: {
      diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
      diagnosticEventHubName: '<diagnosticEventHubName>'
      diagnosticLogsRetentionInDays: 7
      diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
      diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
      queues: [
        {
          metadata: {
            key1: 'value1'
            key2: 'value2'
          }
          name: 'queue1'
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
        {
          metadata: {}
          name: 'queue2'
        }
      ]
    }
    requireInfrastructureEncryption: true
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    storageAccountSku: 'Standard_LRS'
    systemAssignedIdentity: true
    tableServices: {
      diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
      diagnosticEventHubName: '<diagnosticEventHubName>'
      diagnosticLogsRetentionInDays: 7
      diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
      diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
      tables: [
        'table1'
        'table2'
      ]
    }
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
    "name": {
      "value": "<<namePrefix>>ssacom001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
    },
    "blobServices": {
      "value": {
        "containers": [
          {
            "name": "avdscripts",
            "publicAccess": "None",
            "roleAssignments": [
              {
                "principalIds": [
                  "<managedIdentityPrincipalId>"
                ],
                "principalType": "ServicePrincipal",
                "roleDefinitionIdOrName": "Reader"
              }
            ]
          },
          {
            "allowProtectedAppendWrites": false,
            "enableWORM": true,
            "name": "archivecontainer",
            "publicAccess": "None",
            "WORMRetention": 666
          }
        ],
        "diagnosticEventHubAuthorizationRuleId": "<diagnosticEventHubAuthorizationRuleId>",
        "diagnosticEventHubName": "<diagnosticEventHubName>",
        "diagnosticLogsRetentionInDays": 7,
        "diagnosticStorageAccountId": "<diagnosticStorageAccountId>",
        "diagnosticWorkspaceId": "<diagnosticWorkspaceId>"
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
    "enableHierarchicalNamespace": {
      "value": true
    },
    "enableNfsV3": {
      "value": true
    },
    "enableSftp": {
      "value": true
    },
    "fileServices": {
      "value": {
        "diagnosticEventHubAuthorizationRuleId": "<diagnosticEventHubAuthorizationRuleId>",
        "diagnosticEventHubName": "<diagnosticEventHubName>",
        "diagnosticLogsRetentionInDays": 7,
        "diagnosticStorageAccountId": "<diagnosticStorageAccountId>",
        "diagnosticWorkspaceId": "<diagnosticWorkspaceId>",
        "shares": [
          {
            "name": "avdprofiles",
            "roleAssignments": [
              {
                "principalIds": [
                  "<managedIdentityPrincipalId>"
                ],
                "principalType": "ServicePrincipal",
                "roleDefinitionIdOrName": "Reader"
              }
            ],
            "shareQuota": 5120
          },
          {
            "name": "avdprofiles2",
            "shareQuota": 102400
          }
        ]
      }
    },
    "largeFileSharesState": {
      "value": "Enabled"
    },
    "localUsers": {
      "value": [
        {
          "hasSharedKey": false,
          "hasSshKey": true,
          "hasSshPassword": false,
          "homeDirectory": "avdscripts",
          "name": "testuser",
          "permissionScopes": [
            {
              "permissions": "r",
              "resourceName": "avdscripts",
              "service": "blob"
            }
          ],
          "storageAccountName": "<<namePrefix>>ssacom001"
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "networkAcls": {
      "value": {
        "bypass": "AzureServices",
        "defaultAction": "Deny",
        "ipRules": [
          {
            "action": "Allow",
            "value": "1.1.1.1"
          }
        ],
        "virtualNetworkRules": [
          {
            "action": "Allow",
            "id": "<id>"
          }
        ]
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSZoneResourceId>"
            ]
          },
          "service": "blob",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "queueServices": {
      "value": {
        "diagnosticEventHubAuthorizationRuleId": "<diagnosticEventHubAuthorizationRuleId>",
        "diagnosticEventHubName": "<diagnosticEventHubName>",
        "diagnosticLogsRetentionInDays": 7,
        "diagnosticStorageAccountId": "<diagnosticStorageAccountId>",
        "diagnosticWorkspaceId": "<diagnosticWorkspaceId>",
        "queues": [
          {
            "metadata": {
              "key1": "value1",
              "key2": "value2"
            },
            "name": "queue1",
            "roleAssignments": [
              {
                "principalIds": [
                  "<managedIdentityPrincipalId>"
                ],
                "principalType": "ServicePrincipal",
                "roleDefinitionIdOrName": "Reader"
              }
            ]
          },
          {
            "metadata": {},
            "name": "queue2"
          }
        ]
      }
    },
    "requireInfrastructureEncryption": {
      "value": true
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
    "storageAccountSku": {
      "value": "Standard_LRS"
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "tableServices": {
      "value": {
        "diagnosticEventHubAuthorizationRuleId": "<diagnosticEventHubAuthorizationRuleId>",
        "diagnosticEventHubName": "<diagnosticEventHubName>",
        "diagnosticLogsRetentionInDays": 7,
        "diagnosticStorageAccountId": "<diagnosticStorageAccountId>",
        "diagnosticWorkspaceId": "<diagnosticWorkspaceId>",
        "tables": [
          "table1",
          "table2"
        ]
      }
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

<h3>Example 2: Encr</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module storageAccounts './Microsoft.Storage/storageAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-stsencr'
  params: {
    // Required parameters
    name: '<<namePrefix>>stsencr001'
    // Non-required parameters
    allowBlobPublicAccess: false
    blobServices: {
      containers: [
        {
          name: '<<namePrefix>>container'
          publicAccess: 'None'
        }
      ]
    }
    cMKKeyName: '<cMKKeyName>'
    cMKKeyVaultResourceId: '<cMKKeyVaultResourceId>'
    cMKUserAssignedIdentityResourceId: '<cMKUserAssignedIdentityResourceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSZoneResourceId>'
          ]
        }
        service: 'blob'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    requireInfrastructureEncryption: true
    storageAccountSku: 'Standard_LRS'
    systemAssignedIdentity: false
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
    "name": {
      "value": "<<namePrefix>>stsencr001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
    },
    "blobServices": {
      "value": {
        "containers": [
          {
            "name": "<<namePrefix>>container",
            "publicAccess": "None"
          }
        ]
      }
    },
    "cMKKeyName": {
      "value": "<cMKKeyName>"
    },
    "cMKKeyVaultResourceId": {
      "value": "<cMKKeyVaultResourceId>"
    },
    "cMKUserAssignedIdentityResourceId": {
      "value": "<cMKUserAssignedIdentityResourceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSZoneResourceId>"
            ]
          },
          "service": "blob",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "requireInfrastructureEncryption": {
      "value": true
    },
    "storageAccountSku": {
      "value": "Standard_LRS"
    },
    "systemAssignedIdentity": {
      "value": false
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

<h3>Example 3: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module storageAccounts './Microsoft.Storage/storageAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-ssamin'
  params: {
    // Required parameters
    name: '<<namePrefix>>ssamin001'
    // Non-required parameters
    allowBlobPublicAccess: false
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
      "value": "<<namePrefix>>ssamin001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>

<h3>Example 4: Minprem</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module storageAccounts './Microsoft.Storage/storageAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-ssaminprem'
  params: {
    // Required parameters
    name: '<<namePrefix>>ssaminprem001'
    // Non-required parameters
    allowBlobPublicAccess: false
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    storageAccountAccessTier: 'Premium'
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
      "value": "<<namePrefix>>ssaminprem001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "storageAccountAccessTier": {
      "value": "Premium"
    }
  }
}
```

</details>
<p>

<h3>Example 5: Nfs</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module storageAccounts './Microsoft.Storage/storageAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-ssanfs'
  params: {
    // Required parameters
    name: '<<namePrefix>>ssanfs001'
    // Non-required parameters
    allowBlobPublicAccess: false
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    fileServices: {
      shares: [
        {
          enabledProtocols: 'NFS'
          name: 'nfsfileshare'
        }
      ]
    }
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
    storageAccountKind: 'FileStorage'
    storageAccountSku: 'Premium_LRS'
    supportsHttpsTrafficOnly: false
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
    "name": {
      "value": "<<namePrefix>>ssanfs001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
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
    "fileServices": {
      "value": {
        "shares": [
          {
            "enabledProtocols": "NFS",
            "name": "nfsfileshare"
          }
        ]
      }
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
    "storageAccountKind": {
      "value": "FileStorage"
    },
    "storageAccountSku": {
      "value": "Premium_LRS"
    },
    "supportsHttpsTrafficOnly": {
      "value": false
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

<h3>Example 6: V1</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module storageAccounts './Microsoft.Storage/storageAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-ssav1'
  params: {
    // Required parameters
    name: '<<namePrefix>>ssav1001'
    // Non-required parameters
    allowBlobPublicAccess: false
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    storageAccountKind: 'Storage'
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
      "value": "<<namePrefix>>ssav1001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "storageAccountKind": {
      "value": "Storage"
    }
  }
}
```

</details>
<p>
