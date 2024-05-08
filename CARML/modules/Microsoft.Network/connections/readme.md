# Virtual Network Gateway Connections `[Microsoft.Network/connections]`

This template deploys a virtual network gateway connection.

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
| `Microsoft.Network/connections` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/connections) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Remote connection name. |
| `virtualNetworkGateway1` | object | The primary Virtual Network Gateway. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `customIPSecPolicy` | object | `{object}` |  | The IPSec Policies to be considered by this connection. |
| `enableBgp` | bool | `False` |  | Value to specify if BGP is enabled or not. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `localNetworkGateway2` | object | `{object}` |  | The local network gateway. Used for connection type [IPsec]. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `peer` | object | `{object}` |  | The remote peer. Used for connection type [ExpressRoute]. |
| `routingWeight` | int | `-1` |  | The weight added to routes learned from this BGP speaker. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `usePolicyBasedTrafficSelectors` | bool | `False` |  | Enable policy-based traffic selectors. |
| `virtualNetworkGateway2` | object | `{object}` |  | The remote Virtual Network Gateway. Used for connection type [Vnet2Vnet]. |
| `virtualNetworkGatewayConnectionType` | string | `'IPsec'` | `[ExpressRoute, IPsec, Vnet2Vnet, VPNClient]` | Gateway connection type. |
| `vpnSharedKey` | string | `''` |  | Specifies a VPN shared key. The same value has to be specified on both Virtual Network Gateways. |


### Parameter Usage: `virtualNetworkGateway1`

The primary virtual network gateway object.

<details>

<summary>Parameter JSON format</summary>

```json
"virtualNetworkGateway1": {
    "value": {
        "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/virtualNetworkGateways/myGateway01"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
virtualNetworkGateway1: {
    id: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/virtualNetworkGateways/myGateway01'
}
```

</details>
<p>

### Parameter Usage: `virtualNetworkGateway2`

The secondary virtual network gateway used for VNET to VNET connections.

<details>

<summary>Parameter JSON format</summary>

```json
"virtualNetworkGateway2" : {
    "value": {
        "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/virtualNetworkGateways/myGateway02"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
virtualNetworkGateway2 : {
    id: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/virtualNetworkGateways/myGateway02'
}
```

</details>
<p>

### Parameter Usage: `localNetworkGateway2`

The local virtual network gateway object.

<details>

<summary>Parameter JSON format</summary>

```json
"localNetworkGateway2": {
    "value": {
        "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/localNetworkGateways/myGateway"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
localNetworkGateway2: {
    id: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/localNetworkGateways/myGateway'
}
```

</details>
<p>

### Parameter Usage: `peer`

The remote peer object used for ExpressRoute connections

<details>

<summary>Parameter JSON format</summary>

```json
"peer": {
    "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/expressRouteCircuits/expressRoute"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
'peer': {
    id: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/expressRouteCircuits/expressRoute'
}
```

</details>
<p>

### Parameter Usage: `customIPSecPolicy`

If ipsecEncryption parameter is empty, customIPSecPolicy will not be deployed. The parameter file should look like below.

<details>

<summary>Parameter JSON format</summary>

```json
"customIPSecPolicy": {
    "value": {
        "saLifeTimeSeconds": 0,
        "saDataSizeKilobytes": 0,
        "ipsecEncryption": "",
        "ipsecIntegrity": "",
        "ikeEncryption": "",
        "ikeIntegrity": "",
        "dhGroup": "",
        "pfsGroup": ""
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
customIPSecPolicy: {
    saLifeTimeSeconds: 0
    saDataSizeKilobytes: 0
    ipsecEncryption: ''
    ipsecIntegrity: ''
    ikeEncryption: ''
    ikeIntegrity: ''
    dhGroup: ''
    pfsGroup: ''
}
```

</details>
<p>

Format of the full customIPSecPolicy parameter in parameter file.

<details>

<summary>Parameter JSON format</summary>

```json
"customIPSecPolicy": {
    "value": {
        "saLifeTimeSeconds": 28800,
        "saDataSizeKilobytes": 102400000,
        "ipsecEncryption": "AES256",
        "ipsecIntegrity": "SHA256",
        "ikeEncryption": "AES256",
        "ikeIntegrity": "SHA256",
        "dhGroup": "DHGroup14",
        "pfsGroup": "None"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
customIPSecPolicy: {
    saLifeTimeSeconds: 28800
    saDataSizeKilobytes: 102400000
    ipsecEncryption: 'AES256'
    ipsecIntegrity: 'SHA256'
    ikeEncryption: 'AES256'
    ikeIntegrity: 'SHA256'
    dhGroup: 'DHGroup14'
    pfsGroup: 'None'
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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the remote connection. |
| `resourceGroupName` | string | The resource group the remote connection was deployed into. |
| `resourceId` | string | The resource ID of the remote connection. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Vnet2vnet</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module connections './Microsoft.Network/connections/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-ncvtv'
  params: {
    // Required parameters
    name: '<<namePrefix>>ncvtv001'
    virtualNetworkGateway1: {
      id: '<id>'
    }
    // Non-required parameters
    enableBgp: false
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    virtualNetworkGateway2: {
      id: '<id>'
    }
    virtualNetworkGatewayConnectionType: 'Vnet2Vnet'
    vpnSharedKey: '<vpnSharedKey>'
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
      "value": "<<namePrefix>>ncvtv001"
    },
    "virtualNetworkGateway1": {
      "value": {
        "id": "<id>"
      }
    },
    // Non-required parameters
    "enableBgp": {
      "value": false
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "virtualNetworkGateway2": {
      "value": {
        "id": "<id>"
      }
    },
    "virtualNetworkGatewayConnectionType": {
      "value": "Vnet2Vnet"
    },
    "vpnSharedKey": {
      "value": "<vpnSharedKey>"
    }
  }
}
```

</details>
<p>
