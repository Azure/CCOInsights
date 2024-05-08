# Private Endpoints `[Microsoft.Network/privateEndpoints]`

This template deploys a private endpoint for a generic service.

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
| `Microsoft.Network/privateEndpoints` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-05-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-05-01/privateEndpoints/privateDnsZoneGroups) |

### Resource dependency

The following resources are required to be able to deploy this resource:

- `PrivateDNSZone`
- `VirtualNetwork/subnet`
- The service that needs to be connected through private endpoint

**Important**: Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`. Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon).

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `groupIds` | array | Subtype(s) of the connection to be created. The allowed values depend on the type serviceResourceId refers to. |
| `name` | string | Name of the private endpoint resource to create. |
| `serviceResourceId` | string | Resource ID of the resource that needs to be connected to the network. |
| `subnetResourceId` | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `applicationSecurityGroups` | array | `[]` |  | Application security groups in which the private endpoint IP configuration is included. |
| `customDnsConfigs` | array | `[]` |  | Custom DNS configurations. |
| `customNetworkInterfaceName` | string | `''` |  | The custom name of the network interface attached to the private endpoint. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `ipConfigurations` | array | `[]` |  | A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `manualPrivateLinkServiceConnections` | array | `[]` |  | Manual PrivateLink Service Connections. |
| `privateDnsZoneGroup` | object | `{object}` |  | The private DNS zone group configuration used to associate the private endpoint with one or multiple private DNS zones. A DNS zone group can support up to 5 DNS zones. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags to be applied on all resources/resource groups in this deployment. |


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

### Parameter Usage: `applicationSecurityGroups`

You can attach multiple Application Security Groups to a private endpoint resource.

<details>

<summary>Parameter JSON format</summary>

```json
"applicationSecurityGroups": {
    "value": [
        {
            "id": "<applicationSecurityGroupResourceId>"
        },
        {
            "id": "<applicationSecurityGroupResourceId>"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
applicationSecurityGroups: [
    {
        id: '<applicationSecurityGroupResourceId>'
    }
    {
        id: '<applicationSecurityGroupResourceId>'
    }
]
```

</details>
<p>

### Parameter Usage: `customNetworkInterfaceName`

You can customize the name of the private endpoint network interface instead of the default one that contains the string 'nic.GUID'. This helps with having consistent naming standards across all resources. Existing private endpoints cannot be renamed. See [documentation](https://learn.microsoft.com/en-us/azure/private-link/manage-private-endpoint?tabs=manage-private-link-powershell#network-interface-rename) for more details.

<details>

<summary>Parameter JSON format</summary>

```json
"customNetworkInterfaceName": {
    "value": "myPrivateEndpointName-Nic"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
customNetworkInterfaceName: 'myPrivateEndpointName-Nic'
```

</details>
<p>

### Parameter Usage: `ipConfigurations`

You can use this property to define a static IP address for the private endpoint instead of the default dynamic one. To do that, first extract the `memberName` and `groupId` for the resource type you are creating the private endpoint for. See [documentation](https://learn.microsoft.com/en-us/azure/private-link/manage-private-endpoint?tabs=manage-private-link-powershell#determine-groupid-and-membername) for guidance on how to do that. Also provide the `privateIPAddress` for the private endpoint from the subnet range you are creating the private endpoint in. Note that static IP addresses [can be applied](https://learn.microsoft.com/en-us/azure/private-link/manage-private-endpoint?tabs=manage-private-link-powershell#custom-properties) when the private endpoint is created.

<details>

<summary>Parameter JSON format</summary>

```json
"customNetworkInterfaceName": {
    "value": [
      {
          "name": "myIPconfig",
          "properties": {
              "memberName": "<memberName>", // e.g. default, sites, blob
              "groupId": "<groupId>", // e.g. vault, registry, blob
              "privateIPAddress": "10.10.10.10"
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
    {
        name: 'myIPconfig'
        properties: {
            memberName: '<memberName>' // e.g. default, sites, blob
            groupId: '<groupId>' // e.g. vault, registry, blob
            privateIPAddress: '10.10.10.10'
        }
    }
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the private endpoint. |
| `resourceGroupName` | string | The resource group the private endpoint was deployed into. |
| `resourceId` | string | The resource ID of the private endpoint. |

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
module privateEndpoints './Microsoft.Network/privateEndpoints/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-npecom'
  params: {
    // Required parameters
    groupIds: [
      'vault'
    ]
    name: '<<namePrefix>>npecom001'
    serviceResourceId: '<serviceResourceId>'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    applicationSecurityGroups: [
      {
        id: '<id>'
      }
    ]
    customNetworkInterfaceName: '<<namePrefix>>npecom001nic'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    ipConfigurations: [
      {
        name: 'myIPconfig'
        properties: {
          groupId: 'vault'
          memberName: 'default'
          privateIPAddress: '10.0.0.10'
        }
      }
    ]
    lock: 'CanNotDelete'
    privateDnsZoneGroup: {
      privateDNSResourceIds: [
        '<privateDNSZoneResourceId>'
      ]
    }
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
    "groupIds": {
      "value": [
        "vault"
      ]
    },
    "name": {
      "value": "<<namePrefix>>npecom001"
    },
    "serviceResourceId": {
      "value": "<serviceResourceId>"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    // Non-required parameters
    "applicationSecurityGroups": {
      "value": [
        {
          "id": "<id>"
        }
      ]
    },
    "customNetworkInterfaceName": {
      "value": "<<namePrefix>>npecom001nic"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "ipConfigurations": {
      "value": [
        {
          "name": "myIPconfig",
          "properties": {
            "groupId": "vault",
            "memberName": "default",
            "privateIPAddress": "10.0.0.10"
          }
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "privateDnsZoneGroup": {
      "value": {
        "privateDNSResourceIds": [
          "<privateDNSZoneResourceId>"
        ]
      }
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
module privateEndpoints './Microsoft.Network/privateEndpoints/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-npemin'
  params: {
    // Required parameters
    groupIds: [
      'vault'
    ]
    name: '<<namePrefix>>npemin001'
    serviceResourceId: '<serviceResourceId>'
    subnetResourceId: '<subnetResourceId>'
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
    "groupIds": {
      "value": [
        "vault"
      ]
    },
    "name": {
      "value": "<<namePrefix>>npemin001"
    },
    "serviceResourceId": {
      "value": "<serviceResourceId>"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
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
