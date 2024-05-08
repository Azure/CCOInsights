# Network PrivateLinkServices `[Microsoft.Network/privateLinkServices]`

This module deploys Network Private Link Services.

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
| `Microsoft.Network/privateLinkServices` | [2022-01-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-01-01/privateLinkServices) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the private link service to create. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `autoApproval` | object | `{object}` |  | The auto-approval list of the private link service. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enableProxyProtocol` | bool | `False` |  | Whether the private link service is enabled for proxy protocol or not. |
| `extendedLocation` | object | `{object}` |  | The extended location of the load balancer. |
| `fqdns` | array | `[]` |  | The list of Fqdn. |
| `ipConfigurations` | array | `[]` |  | An array of private link service IP configurations. |
| `loadBalancerFrontendIpConfigurations` | array | `[]` |  | An array of references to the load balancer IP configurations. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags to be applied on all resources/resource groups in this deployment. |
| `visibility` | object | `{object}` |  | The visibility list of the private link service. |


### Parameter Usage: `ipConfigurations`

This property refers to the NAT (Network Address Translation) IP configuration for the Private Link service. The NAT IP can be chosen from any subnet in a service provider's virtual network. Private Link service performs destination side NAT-ing on the Private Link traffic. This ensures that there is no IP conflict between source (consumer side) and destination (service provider) address space. On the destination side (service provider side), the NAT IP address will show up as Source IP for all packets received by your service and destination IP for all packets sent by your service.

<details>

<summary>Parameter JSON format</summary>

```json
"ipConfigurations": {
  "value": [
    // Example showing only mandatory fields
    {
      "name": "minpls01", // Name of the IP configuration
      "properties": {
        "subnet": {
          "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001" // The subnet selected here will be used by the Private Link Service to pick up the NAT IP
        }
      }
    },
    // Example showing commonly used fields
    {
      "name": "pls01", // Name of the IP configuration
      "properties": {
        "primary": false, // Whether the ip configuration is primary or not
        "privateIPAddressVersion": "IPv4", // Whether the specific IP configuration is IPv4 or IPv6. Default is IPv4
        "privateIPAllocationMethod": "Static", // The private IP address allocation method
        "privateIPAddress": "10.0.1.10", // If "privateIPAllocationMethod" is set to "Static" then this needs to be supplied
        "subnet": {
          "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001" // The subnet selected here will be used by the Private Link Service to pick up the NAT IP
        }
      }
    }
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
ipConfigurations: [
  // Example showing only mandatory fields
  {
    name: 'minpls01' // Name of the IP configuration
    properties: {
      subnet: {
        id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001' // The subnet selected here will be used by the Private Link Service to pick up the NAT IP
      }
    }
  }
  // Example showing commonly used fields
  {
    name: 'pls01' // Name of the IP configuration
    properties: {
      primary: false // Whether the ip configuration is primary or not
      privateIPAddressVersion: 'IPv4' // Whether the specific IP configuration is IPv4 or IPv6. Default is IPv4
      privateIPAllocationMethod: 'Static' // Whether the specific IP configuration is IPv4 or IPv6. Default is IPv4
      privateIPAddress: '10.0.1.10' // If "privateIPAllocationMethod" is set to "Static" then this needs to be supplied
      subnet: {
        id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001' // The subnet selected here will be used by the Private Link Service to pick up the NAT IP
      }
    }
  }
]
```

</details>
<p>

### Parameter Usage: `loadBalancerFrontendIpConfigurations`

Private Link service is tied to the frontend IP address of a Standard Load Balancer. All traffic destined for the service will reach the frontend of the SLB. You can configure SLB rules to direct this traffic to appropriate backend pools where your applications are running. Load balancer frontend IP configurations are different than NAT IP configurations.

<details>

<summary>Parameter JSON format</summary>

```json
"loadBalancerFrontendIpConfigurations": {
  "value": [
    // Example showing reference to the font end IP configuration of the load balancer
    {
      "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/loadBalancers/adp-<<namePrefix>>-az-lb-internal-001/frontendIPConfigurations/privateIPConfig1"
    }
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
loadBalancerFrontendIpConfigurations: [
  // Example showing reference to the font end IP configuration of the load balancer
  {
    id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/loadBalancers/adp-<<namePrefix>>-az-lb-internal-001/frontendIPConfigurations/privateIPConfig1'
  }
]
```

</details>
<p>

### Parameter Usage: `extendedLocation`

This is the Edge Zone ID of the Edge Zone corresponding to the region in which the resource is deployed. More information is available here: [Azure Edge Zone ID](https://docs.microsoft.com/en-us/azure/public-multi-access-edge-compute-mec/key-concepts#azure-edge-zone-id).

<details>

<summary>Parameter JSON format</summary>

```json
"extendedLocation": {
  // Example showing usage of the extendedLocation param
  "value": {
    "name": "attatlanta1", // Edge Zone ID for the parent East US 2 region is "attatlanta1"
    "type": "EdgeZone" // Fixed value
  }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
extendedLocation: {
  // Example showing usage of the extendedLocation param
  name: 'attdallas1' // Edge Zone ID for the parent South Central US region is "attdallas1".
  type: 'EdgeZone' // Fixed value
}
```

</details>
<p>

### Parameter Usage: `autoApproval`

Auto-approval controls the automated access to the Private Link service. The subscriptions specified in the auto-approval list are approved automatically when a connection is requested from private endpoints in those subscriptions.

<details>

<summary>Parameter JSON format</summary>

```json
// Example to auto-approve for all the subscriptions present under the "visibility" param
"autoApproval": {
  "value": [
    "*"
  ]
}

// Example to auto-approve a specific set of subscriptions. This should always be a subset of the subscriptions provided under the "visibility" param
"autoApproval": {
  "value": [
    "12345678-1234-1234-1234-123456781234", // Subscription 1
    "87654321-1234-1234-1234-123456781234" // Subscription 2
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
// Example to auto-approve for all the subscriptions present under the "visibility" param
autoApproval: [
  "*"
]

// Example to auto-approve a specific set of subscriptions. This should always be a subset of the subscriptions provided under "visibility"
autoApproval: [
  '12345678-1234-1234-1234-123456781234' // Subscription 1
  '87654321-1234-1234-1234-123456781234' // Subscription 2
]
```

</details>
<p>

### Parameter Usage: `visibility`

Visibility is the property that controls the exposure settings for your Private Link service. Service providers can choose to limit the exposure to their service to subscriptions with Azure role-based access control (Azure RBAC) permissions, a restricted set of subscriptions, or all Azure subscriptions.

<details>

<summary>Parameter JSON format</summary>

```json
"visibility": {
  "value"
  // Example showing usage of visibility param
  "subscriptions": [
    "12345678-1234-1234-1234-123456781234", // Subscription 1
    "87654321-1234-1234-1234-123456781234", // Subscription 2
    "12341234-1234-1234-1234-123456781234" // Subscription 3
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
visibility: {
  subscriptions: [
    '12345678-1234-1234-1234-123456781234' // Subscription 1
    '87654321-1234-1234-1234-123456781234' // Subscription 2
    '12341234-1234-1234-1234-123456781234' // Subscription 3
  ]
}
```

</details>
<p>

### Parameter Usage: `enableProxyProtocol`

This property lets the service provider use tcp proxy v2 to retrieve connection information about the service consumer. Service Provider is responsible for setting up receiver configs to be able to parse the proxy protocol v2 header.

### Parameter Usage: `fqdns`

This property lets you set the fqdn(s) to access the Private Link service.
<details>

<summary>Parameter JSON format</summary>

```json
"fqdns": {
  // Example to set FQDNs for the Private Link service
  "value": [
    "pls01.azure.privatelinkservice", // FQDN 1
    "pls01-duplicate.azure.privatelinkserivce" // FQDN 2
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
fqdns: [
  // Example to set FQDNs for the Private Link service
  'pls01.azure.privatelinkservice'
  'pls01-duplicate.azure.privatelinkservice'
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
| `name` | string | The name of the private link service. |
| `resourceGroupName` | string | The resource group the private link service was deployed into. |
| `resourceId` | string | The resource ID of the private link service. |

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
module privateLinkServices './Microsoft.Network/privateLinkServices/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nplscom'
  params: {
    // Required parameters
    name: '<<namePrefix>>nplscom001'
    // Non-required parameters
    autoApproval: {
      subscriptions: [
        '*'
      ]
    }
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enableProxyProtocol: true
    fqdns: [
      'nplscom.plsfqdn01.azure.privatelinkservice'
      'nplscom.plsfqdn02.azure.privatelinkservice'
    ]
    ipConfigurations: [
      {
        name: 'nplscom01'
        properties: {
          primary: true
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    loadBalancerFrontendIpConfigurations: [
      {
        id: '<id>'
      }
    ]
    lock: 'CanNotDelete'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    visibility: {
      subscriptions: [
        '<subscriptionId>'
      ]
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
      "value": "<<namePrefix>>nplscom001"
    },
    // Non-required parameters
    "autoApproval": {
      "value": {
        "subscriptions": [
          "*"
        ]
      }
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enableProxyProtocol": {
      "value": true
    },
    "fqdns": {
      "value": [
        "nplscom.plsfqdn01.azure.privatelinkservice",
        "nplscom.plsfqdn02.azure.privatelinkservice"
      ]
    },
    "ipConfigurations": {
      "value": [
        {
          "name": "nplscom01",
          "properties": {
            "primary": true,
            "privateIPAllocationMethod": "Dynamic",
            "subnet": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "loadBalancerFrontendIpConfigurations": {
      "value": [
        {
          "id": "<id>"
        }
      ]
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
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "visibility": {
      "value": {
        "subscriptions": [
          "<subscriptionId>"
        ]
      }
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
module privateLinkServices './Microsoft.Network/privateLinkServices/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nplsmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>nplsmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    ipConfigurations: [
      {
        name: 'nplsmin01'
        properties: {
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    loadBalancerFrontendIpConfigurations: [
      {
        id: '<id>'
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
      "value": "<<namePrefix>>nplsmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "ipConfigurations": {
      "value": [
        {
          "name": "nplsmin01",
          "properties": {
            "subnet": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "loadBalancerFrontendIpConfigurations": {
      "value": [
        {
          "id": "<id>"
        }
      ]
    }
  }
}
```

</details>
<p>
