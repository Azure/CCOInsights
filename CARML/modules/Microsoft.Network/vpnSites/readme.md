# VPN Sites `[Microsoft.Network/vpnSites]`

This module deploys a VPN Site.

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
| `Microsoft.Network/vpnSites` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/vpnSites) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the VPN Site. |
| `virtualWanId` | string | Resource ID of the virtual WAN to link to. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `addressPrefixes` | array | An array of IP address ranges that can be used by subnets of the virtual network. Required if no bgpProperties or VPNSiteLinks are configured. |
| `bgpProperties` | object | BGP settings details. Note: This is a deprecated property, please use the corresponding VpnSiteLinks property instead. Required if no addressPrefixes or VPNSiteLinks are configured. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `deviceProperties` | object | `{object}` |  | List of properties of the device. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `ipAddress` | string | `''` |  | The IP-address for the VPN-site. Note: This is a deprecated property, please use the corresponding VpnSiteLinks property instead. |
| `isSecuritySite` | bool | `False` |  | IsSecuritySite flag. |
| `location` | string | `[resourceGroup().location]` |  | Location where all resources will be created. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `o365Policy` | object | `{object}` |  | The Office365 breakout policy. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `vpnSiteLinks` | array | `[]` |  | List of all VPN site links. |


### Parameter Usage `o365Policy`

<details>

<summary>Parameter JSON format</summary>

```json
"o365Policy": {
    "value": {
        "breakOutCategories": {
            "optimize": true,
            "allow": true,
            "default": true
        }
    }
}
```

</details>


<details>

<summary>Bicep format</summary>

```bicep
o365Policy: {
    breakOutCategories: {
        optimize: true
        allow: true
        default: true
    }
}
```

</details>
<p>

### Parameter Usage `deviceProperties`

<details>

<summary>Parameter JSON format</summary>

```json
"deviceProperties": {
    "value": {
        "deviceModel": "morty",
        "deviceVendor": "contoso",
        "linkSpeedInMbps": 0
    }
}
```

</details>


<details>

<summary>Bicep format</summary>

```bicep
deviceProperties: {
    deviceModel: 'morty'
    deviceVendor: 'contoso'
    linkSpeedInMbps: 0
}
```

</details>
<p>

### Parameter Usage `bgpProperties`

The BGP properties. Note: This is a deprecated property, please use the corresponding `VpnSiteLinks` property instead.

<details>

<summary>Parameter JSON format</summary>

```json
"bgpProperties": {
    "value": {
        "asn": 65010,
        "bgpPeeringAddress": "1.1.1.1",
        "peerWeight": 0
    }
}
```

</details>


<details>

<summary>Bicep format</summary>

```bicep
bgpProperties: {
    asn: 65010
    bgpPeeringAddress: '1.1.1.1'
    peerWeight: 0
}
```

</details>
<p>

### Parameter Usage `vpnSiteLinks`

An array of links. Should be used instead of the top-level `ipAddress` & `bgpProperties` properties. If using links,  one default link with same name and properties as VpnSite itself is mandatory.

<details>

<summary>Parameter JSON format</summary>

```json
"vpnSiteLinks": {
    "value": [
        {
            "name": "<<namePrefix>>-az-vSite-x-001",
            "properties": {
                "bgpProperties": {
                    "asn": 65010,
                    "bgpPeeringAddress": "1.1.1.1"
                },
                "ipAddress": "1.2.3.4",
                "linkProperties": {
                    "linkProviderName": "contoso",
                    "linkSpeedInMbps": 5
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
vpnSiteLinks: [
    {
        name: '<<namePrefix>>-az-vSite-x-001'
        properties: {
            bgpProperties: {
                asn: 65010
                bgpPeeringAddress: '1.1.1.1'
            }
            ipAddress: '1.2.3.4'
            linkProperties: {
                linkProviderName: 'contoso'
                linkSpeedInMbps: 5
            }
        }
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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the VPN site. |
| `resourceGroupName` | string | The resource group the VPN site was deployed into. |
| `resourceId` | string | The resource ID of the VPN site. |

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
module vpnSites './Microsoft.Network/vpnSites/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nvscom'
  params: {
    // Required parameters
    name: '<<namePrefix>>-nvscom'
    virtualWanId: '<virtualWanId>'
    // Non-required parameters
    deviceProperties: {
      linkSpeedInMbps: 0
    }
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    o365Policy: {
      breakOutCategories: {
        allow: true
        default: true
        optimize: true
      }
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
    tags: {
      tagA: 'valueA'
      tagB: 'valueB'
    }
    vpnSiteLinks: [
      {
        name: '<<namePrefix>>-vSite-nvscom'
        properties: {
          bgpProperties: {
            asn: 65010
            bgpPeeringAddress: '1.1.1.1'
          }
          ipAddress: '1.2.3.4'
          linkProperties: {
            linkProviderName: 'contoso'
            linkSpeedInMbps: 5
          }
        }
      }
      {
        name: 'Link1'
        properties: {
          bgpProperties: {
            asn: 65020
            bgpPeeringAddress: '192.168.1.0'
          }
          ipAddress: '2.2.2.2'
          linkProperties: {
            linkProviderName: 'contoso'
            linkSpeedInMbps: 5
          }
        }
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
      "value": "<<namePrefix>>-nvscom"
    },
    "virtualWanId": {
      "value": "<virtualWanId>"
    },
    // Non-required parameters
    "deviceProperties": {
      "value": {
        "linkSpeedInMbps": 0
      }
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "o365Policy": {
      "value": {
        "breakOutCategories": {
          "allow": true,
          "default": true,
          "optimize": true
        }
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
    },
    "tags": {
      "value": {
        "tagA": "valueA",
        "tagB": "valueB"
      }
    },
    "vpnSiteLinks": {
      "value": [
        {
          "name": "<<namePrefix>>-vSite-nvscom",
          "properties": {
            "bgpProperties": {
              "asn": 65010,
              "bgpPeeringAddress": "1.1.1.1"
            },
            "ipAddress": "1.2.3.4",
            "linkProperties": {
              "linkProviderName": "contoso",
              "linkSpeedInMbps": 5
            }
          }
        },
        {
          "name": "Link1",
          "properties": {
            "bgpProperties": {
              "asn": 65020,
              "bgpPeeringAddress": "192.168.1.0"
            },
            "ipAddress": "2.2.2.2",
            "linkProperties": {
              "linkProviderName": "contoso",
              "linkSpeedInMbps": 5
            }
          }
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
module vpnSites './Microsoft.Network/vpnSites/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nvsmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>-nvsmin'
    virtualWanId: '<virtualWanId>'
    // Non-required parameters
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    ipAddress: '1.2.3.4'
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
      "value": "<<namePrefix>>-nvsmin"
    },
    "virtualWanId": {
      "value": "<virtualWanId>"
    },
    // Non-required parameters
    "addressPrefixes": {
      "value": [
        "10.0.0.0/16"
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "ipAddress": {
      "value": "1.2.3.4"
    }
  }
}
```

</details>
<p>
