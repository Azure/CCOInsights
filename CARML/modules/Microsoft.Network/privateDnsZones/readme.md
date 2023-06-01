# Private DNS Zones `[Microsoft.Network/privateDnsZones]`

This template deploys a private DNS zone.

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
| `Microsoft.Network/privateDnsZones` | [2020-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones) |
| `Microsoft.Network/privateDnsZones/A` | [2020-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/A) |
| `Microsoft.Network/privateDnsZones/AAAA` | [2020-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/AAAA) |
| `Microsoft.Network/privateDnsZones/CNAME` | [2020-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/CNAME) |
| `Microsoft.Network/privateDnsZones/MX` | [2020-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/MX) |
| `Microsoft.Network/privateDnsZones/PTR` | [2020-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/PTR) |
| `Microsoft.Network/privateDnsZones/SOA` | [2020-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SOA) |
| `Microsoft.Network/privateDnsZones/SRV` | [2020-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SRV) |
| `Microsoft.Network/privateDnsZones/TXT` | [2020-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/TXT) |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | [2020-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/virtualNetworkLinks) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Private DNS zone name. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `a` | _[A](A/readme.md)_ array | `[]` |  | Array of A records. |
| `aaaa` | _[AAAA](AAAA/readme.md)_ array | `[]` |  | Array of AAAA records. |
| `cname` | _[CNAME](CNAME/readme.md)_ array | `[]` |  | Array of CNAME records. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `'global'` |  | The location of the PrivateDNSZone. Should be global. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `mx` | _[MX](MX/readme.md)_ array | `[]` |  | Array of MX records. |
| `ptr` | _[PTR](PTR/readme.md)_ array | `[]` |  | Array of PTR records. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `soa` | _[SOA](SOA/readme.md)_ array | `[]` |  | Array of SOA records. |
| `srv` | _[SRV](SRV/readme.md)_ array | `[]` |  | Array of SRV records. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `txt` | _[TXT](TXT/readme.md)_ array | `[]` |  | Array of TXT records. |
| `virtualNetworkLinks` | _[virtualNetworkLinks](virtualNetworkLinks/readme.md)_ array | `[]` |  | Array of custom objects describing vNet links of the DNS zone. Each object should contain properties 'vnetResourceId' and 'registrationEnabled'. The 'vnetResourceId' is a resource ID of a vNet to link, 'registrationEnabled' (bool) enables automatic DNS registration in the zone for the linked vNet. |


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
| `name` | string | The name of the private DNS zone. |
| `resourceGroupName` | string | The resource group the private DNS zone was deployed into. |
| `resourceId` | string | The resource ID of the private DNS zone. |

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
module privateDnsZones './Microsoft.Network/privateDnsZones/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-npdzcom'
  params: {
    // Required parameters
    name: '<<namePrefix>>npdzcom001.com'
    // Non-required parameters
    a: [
      {
        aRecords: [
          {
            ipv4Address: '10.240.4.4'
          }
        ]
        name: 'A_10.240.4.4'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        ttl: 3600
      }
    ]
    aaaa: [
      {
        aaaaRecords: [
          {
            ipv6Address: '2001:0db8:85a3:0000:0000:8a2e:0370:7334'
          }
        ]
        name: 'AAAA_2001_0db8_85a3_0000_0000_8a2e_0370_7334'
        ttl: 3600
      }
    ]
    cname: [
      {
        cnameRecord: {
          cname: 'test'
        }
        name: 'CNAME_test'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        ttl: 3600
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    mx: [
      {
        mxRecords: [
          {
            exchange: 'contoso.com'
            preference: 100
          }
        ]
        name: 'MX_contoso'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        ttl: 3600
      }
    ]
    ptr: [
      {
        name: 'PTR_contoso'
        ptrRecords: [
          {
            ptrdname: 'contoso.com'
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
        ttl: 3600
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
    soa: [
      {
        name: '@'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        soaRecord: {
          email: 'azureprivatedns-host.microsoft.com'
          expireTime: 2419200
          host: 'azureprivatedns.net'
          minimumTtl: 10
          refreshTime: 3600
          retryTime: 300
          serialNumber: '1'
        }
        ttl: 3600
      }
    ]
    srv: [
      {
        name: 'SRV_contoso'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        srvRecords: [
          {
            port: 9332
            priority: 0
            target: 'test.contoso.com'
            weight: 0
          }
        ]
        ttl: 3600
      }
    ]
    txt: [
      {
        name: 'TXT_test'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        ttl: 3600
        txtRecords: [
          {
            value: [
              'test'
            ]
          }
        ]
      }
    ]
    virtualNetworkLinks: [
      {
        registrationEnabled: true
        virtualNetworkResourceId: '<virtualNetworkResourceId>'
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
      "value": "<<namePrefix>>npdzcom001.com"
    },
    // Non-required parameters
    "a": {
      "value": [
        {
          "aRecords": [
            {
              "ipv4Address": "10.240.4.4"
            }
          ],
          "name": "A_10.240.4.4",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "ttl": 3600
        }
      ]
    },
    "aaaa": {
      "value": [
        {
          "aaaaRecords": [
            {
              "ipv6Address": "2001:0db8:85a3:0000:0000:8a2e:0370:7334"
            }
          ],
          "name": "AAAA_2001_0db8_85a3_0000_0000_8a2e_0370_7334",
          "ttl": 3600
        }
      ]
    },
    "cname": {
      "value": [
        {
          "cnameRecord": {
            "cname": "test"
          },
          "name": "CNAME_test",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "ttl": 3600
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "mx": {
      "value": [
        {
          "mxRecords": [
            {
              "exchange": "contoso.com",
              "preference": 100
            }
          ],
          "name": "MX_contoso",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "ttl": 3600
        }
      ]
    },
    "ptr": {
      "value": [
        {
          "name": "PTR_contoso",
          "ptrRecords": [
            {
              "ptrdname": "contoso.com"
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
          "ttl": 3600
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
    "soa": {
      "value": [
        {
          "name": "@",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "soaRecord": {
            "email": "azureprivatedns-host.microsoft.com",
            "expireTime": 2419200,
            "host": "azureprivatedns.net",
            "minimumTtl": 10,
            "refreshTime": 3600,
            "retryTime": 300,
            "serialNumber": "1"
          },
          "ttl": 3600
        }
      ]
    },
    "srv": {
      "value": [
        {
          "name": "SRV_contoso",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "srvRecords": [
            {
              "port": 9332,
              "priority": 0,
              "target": "test.contoso.com",
              "weight": 0
            }
          ],
          "ttl": 3600
        }
      ]
    },
    "txt": {
      "value": [
        {
          "name": "TXT_test",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "ttl": 3600,
          "txtRecords": [
            {
              "value": [
                "test"
              ]
            }
          ]
        }
      ]
    },
    "virtualNetworkLinks": {
      "value": [
        {
          "registrationEnabled": true,
          "virtualNetworkResourceId": "<virtualNetworkResourceId>"
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
module privateDnsZones './Microsoft.Network/privateDnsZones/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-npdzmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>npdzmin001.com'
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
    "name": {
      "value": "<<namePrefix>>npdzmin001.com"
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
