# Virtual Hubs `[Microsoft.Network/virtualHubs]`

This module deploys a Virtual Hub.
If you are planning to deploy a Secure Virtual Hub (with an Azure Firewall integrated), please refer to the Azure Firewall module.

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
| `Microsoft.Network/virtualHubs` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-05-01/virtualHubs) |
| `Microsoft.Network/virtualHubs/hubRouteTables` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-05-01/virtualHubs/hubRouteTables) |
| `Microsoft.Network/virtualHubs/hubVirtualNetworkConnections` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-05-01/virtualHubs/hubVirtualNetworkConnections) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `addressPrefix` | string | Address-prefix for this VirtualHub. |
| `name` | string | The virtual hub name. |
| `virtualWanId` | string | Resource ID of the virtual WAN to link to. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowBranchToBranchTraffic` | bool | `True` |  | Flag to control transit for VirtualRouter hub. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `expressRouteGatewayId` | string | `''` |  | Resource ID of the Express Route Gateway to link to. |
| `hubRouteTables` | _[hubRouteTables](hubRouteTables/readme.md)_ array | `[]` |  | Route tables to create for the virtual hub. |
| `hubVirtualNetworkConnections` | _[hubVirtualNetworkConnections](hubVirtualNetworkConnections/readme.md)_ array | `[]` |  | Virtual network connections to create for the virtual hub. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `p2SVpnGatewayId` | string | `''` |  | Resource ID of the Point-to-Site VPN Gateway to link to. |
| `preferredRoutingGateway` | string | `''` | `['', ExpressRoute, None, VpnGateway]` | The preferred routing gateway types. |
| `routeTableRoutes` | array | `[]` |  | VirtualHub route tables. |
| `securityPartnerProviderId` | string | `''` |  | ID of the Security Partner Provider to link to. |
| `securityProviderName` | string | `''` |  | The Security Provider name. |
| `sku` | string | `'Standard'` | `[Basic, Standard]` | The sku of this VirtualHub. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `virtualHubRouteTableV2s` | array | `[]` |  | List of all virtual hub route table v2s associated with this VirtualHub. |
| `virtualRouterAsn` | int | `-1` |  | VirtualRouter ASN. |
| `virtualRouterIps` | array | `[]` |  | VirtualRouter IPs. |
| `vpnGatewayId` | string | `''` |  | Resource ID of the VPN Gateway to link to. |


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
| `name` | string | The name of the virtual hub. |
| `resourceGroupName` | string | The resource group the virtual hub was deployed into. |
| `resourceId` | string | The resource ID of the virtual hub. |

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
module virtualHubs './Microsoft.Network/virtualHubs/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nvhcom'
  params: {
    // Required parameters
    addressPrefix: '10.1.0.0/16'
    name: '<<namePrefix>>-nvhcom'
    virtualWanId: '<virtualWanId>'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    hubRouteTables: [
      {
        name: 'routeTable1'
      }
    ]
    hubVirtualNetworkConnections: [
      {
        name: 'connection1'
        remoteVirtualNetworkId: '<remoteVirtualNetworkId>'
        routingConfiguration: {
          associatedRouteTable: {
            id: '<id>'
          }
          propagatedRouteTables: {
            ids: [
              {
                id: '<id>'
              }
            ]
            labels: [
              'none'
            ]
          }
        }
      }
    ]
    lock: 'CanNotDelete'
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
    "addressPrefix": {
      "value": "10.1.0.0/16"
    },
    "name": {
      "value": "<<namePrefix>>-nvhcom"
    },
    "virtualWanId": {
      "value": "<virtualWanId>"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "hubRouteTables": {
      "value": [
        {
          "name": "routeTable1"
        }
      ]
    },
    "hubVirtualNetworkConnections": {
      "value": [
        {
          "name": "connection1",
          "remoteVirtualNetworkId": "<remoteVirtualNetworkId>",
          "routingConfiguration": {
            "associatedRouteTable": {
              "id": "<id>"
            },
            "propagatedRouteTables": {
              "ids": [
                {
                  "id": "<id>"
                }
              ],
              "labels": [
                "none"
              ]
            }
          }
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
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
module virtualHubs './Microsoft.Network/virtualHubs/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nvhmin'
  params: {
    // Required parameters
    addressPrefix: '10.0.0.0/16'
    name: '<<namePrefix>>-nvhmin'
    virtualWanId: '<virtualWanId>'
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
    "addressPrefix": {
      "value": "10.0.0.0/16"
    },
    "name": {
      "value": "<<namePrefix>>-nvhmin"
    },
    "virtualWanId": {
      "value": "<virtualWanId>"
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
