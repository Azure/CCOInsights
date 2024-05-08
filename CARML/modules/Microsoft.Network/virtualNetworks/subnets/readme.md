# Virtual Network Subnets `[Microsoft.Network/virtualNetworks/subnets]`

This module deploys a virtual network subnet.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Considerations](#Considerations)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Network/virtualNetworks/subnets` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/virtualNetworks/subnets) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `addressPrefix` | string | The address prefix for the subnet. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `virtualNetworkName` | string | The name of the parent virtual network. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `addressPrefixes` | array | `[]` |  | List of address prefixes for the subnet. |
| `applicationGatewayIpConfigurations` | array | `[]` |  | Application gateway IP configurations of virtual network resource. |
| `delegations` | array | `[]` |  | The delegations to enable on the subnet. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `ipAllocations` | array | `[]` |  | Array of IpAllocation which reference this subnet. |
| `name` | string |  |  | The Name of the subnet resource. |
| `natGatewayId` | string | `''` |  | The resource ID of the NAT Gateway to use for the subnet. |
| `networkSecurityGroupId` | string | `''` |  | The resource ID of the network security group to assign to the subnet. |
| `privateEndpointNetworkPolicies` | string | `''` | `['', Disabled, Enabled]` | enable or disable apply network policies on private endpoint in the subnet. |
| `privateLinkServiceNetworkPolicies` | string | `''` | `['', Disabled, Enabled]` | enable or disable apply network policies on private link service in the subnet. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `routeTableId` | string | `''` |  | The resource ID of the route table to assign to the subnet. |
| `serviceEndpointPolicies` | array | `[]` |  | An array of service endpoint policies. |
| `serviceEndpoints` | array | `[]` |  | The service endpoints to enable on the subnet. |


### Parameter Usage: `delegations`

<details>

<summary>Parameter JSON format</summary>

```json
"delegations": [
    {
        "name": "sqlMiDel",
        "properties": {
            "serviceName": "Microsoft.Sql/managedInstances"
        }
    }
]
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
delegations: [
    {
        name: 'sqlMiDel'
        properties: {
            serviceName: 'Microsoft.Sql/managedInstances'
        }
    }
]
```

</details>
<p>

### Parameter Usage: `serviceEndpoints`

<details>

<summary>Parameter JSON format</summary>

```json
"serviceEndpoints": [
    "Microsoft.EventHub",
    "Microsoft.Sql",
    "Microsoft.Storage",
    "Microsoft.KeyVault"
]
```

</details>


<details>

<summary>Bicep format</summary>

```bicep
serviceEndpoints: [
    'Microsoft.EventHub'
    'Microsoft.Sql'
    'Microsoft.Storage'
    'Microsoft.KeyVault'
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

## Considerations

The `privateEndpointNetworkPolicies` property must be set to disabled for subnets that contain private endpoints. It confirms that NSGs rules will not apply to private endpoints (currently not supported, [reference](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#limitations)). Default Value when not specified is "Enabled".

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the virtual network peering. |
| `resourceGroupName` | string | The resource group the virtual network peering was deployed into. |
| `resourceId` | string | The resource ID of the virtual network peering. |
| `subnetAddressPrefix` | string | The address prefix for the subnet. |
| `subnetAddressPrefixes` | array | List of address prefixes for the subnet. |

## Cross-referenced modules

_None_
