# Network NetworkManagers `[Microsoft.Network/networkManagers]`

This module deploys Network NetworkManagers.
Azure Virtual Network Manager is a management service that enables you to group, configure, deploy, and manage virtual networks globally across subscriptions. With Virtual Network Manager, you can define network groups to identify and logically segment your virtual networks. Then you can determine the connectivity and security configurations you want and apply them across all the selected virtual networks in network groups at once.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Considerations](#Considerations)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Network/networkManagers` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers) |
| `Microsoft.Network/networkManagers/connectivityConfigurations` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers/connectivityConfigurations) |
| `Microsoft.Network/networkManagers/networkGroups` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers/networkGroups) |
| `Microsoft.Network/networkManagers/networkGroups/staticMembers` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers/networkGroups/staticMembers) |
| `Microsoft.Network/networkManagers/scopeConnections` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers/scopeConnections) |
| `Microsoft.Network/networkManagers/securityAdminConfigurations` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers/securityAdminConfigurations) |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers/securityAdminConfigurations/ruleCollections) |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers/securityAdminConfigurations/ruleCollections/rules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Network Manager. |
| `networkManagerScopeAccesses` | array | Scope Access. String array containing any of "Connectivity", "SecurityAdmin". The connectivity feature allows you to create network topologies at scale. The security admin feature lets you create high-priority security rules, which take precedence over NSGs. |
| `networkManagerScopes` | object | Scope of Network Manager. Contains a list of management groups or a list of subscriptions. This defines the boundary of network resources that this Network Manager instance can manage. If using Management Groups, ensure that the "Microsoft.Network" resource provider is registered for those Management Groups prior to deployment. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `networkGroups` | _[networkGroups](networkGroups/readme.md)_ array | Network Groups and static members to create for the network manager. Required if using "connectivityConfigurations" or "securityAdminConfigurations" parameters. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `connectivityConfigurations` | _[connectivityConfigurations](connectivityConfigurations/readme.md)_ array | `[]` |  | Connectivity Configurations to create for the network manager. Network manager must contain at least one network group in order to define connectivity configurations. |
| `description` | string | `''` |  | A description of the network manager. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `scopeConnections` | _[scopeConnections](scopeConnections/readme.md)_ array | `[]` |  | Scope Connections to create for the network manager. Allows network manager to manage resources from another tenant. |
| `securityAdminConfigurations` | _[securityAdminConfigurations](securityAdminConfigurations/readme.md)_ array | `[]` |  | Security Admin Configurations, Rule Collections and Rules to create for the network manager. |
| `tags` | object | `{object}` |  | Tags of the resource. |


### Parameter Usage: `<networkManagerScopeAccesses>`

Features are scope access that you allow the Azure Virtual Network Manager to manage. Azure Virtual Network Manager currently has two feature scopes, which are `Connectivity` and `SecurityAdmin`. You can enable both feature scopes on the same Virtual Network Manager instance.

<details>

<summary>Parameter JSON format</summary>

```json
"networkManagerScopeAccesses": {
    "value": [
      "Connectivity"
      "SecurityAdmin"
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
networkManagerScopeAccesses: [
  'Connectivity'
  'SecurityAdmin'
]
```

</details>
<p>

### Parameter Usage: `<networkManagerScopes>`

Contains a list of management groups or a list of subscriptions. This defines the boundary of network resources that this virtual network manager instance can manage.

**Note**: You can't create multiple Azure Virtual Network Manager instances with an overlapping scope of the same hierarchy and the same features selected.

<details>

<summary>Parameter JSON format</summary>

```json
"networkManagerScopes": {
    "value": {
      "subscriptions": [
        "/subscriptions/<subscriptionId>"
      ],
      "managementGroups": [
        "/providers/Microsoft.Management/managementGroups/<managementGroupId>"
      ]
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
networkManagerScopes: {
  subscriptions: [
    '/subscriptions/<subscriptionId>'
  ]
  managementGroups: [
    '/providers/Microsoft.Management/managementGroups/<<managementGroupId>>'
  ]
}
```

</details>
<p>

### Parameter Usage: `<networkGroups>`

A network group is global container that includes a set of virtual network resources from any region. Then, configurations are applied to target the network group, which applies the configuration to all members of the group. The two types are group memberships are static and dynamic memberships. Static membership allows you to explicitly add virtual networks to a group by manually selecting individual virtual networks, and is available as a child module, while dynamic membership is defined through Azure policy. See [How Azure Policy works with Network Groups](https://learn.microsoft.com/en-us/azure/virtual-network-manager/concept-azure-policy-integration) for more details.

<details>

<summary>Parameter JSON format</summary>

```json
"networkGroups": {
  "value": [
    {
      "name": "network-group-test",
      "description": "network-group-test description",
      "staticMembers": [
        {
          "name": "vnet1",
          "resourceId": "<vnet1ResourceId>"
        },
        {
          "name": "vnet2",
          "resourceId": "<vnet1ResourceId>"
        }
      ]
    }
  ]
},
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
networkGroups: [
  {
    name: 'network-group-test'
    description: 'network-group-test description'
    staticMembers: [
      {
        name: 'vnet1'
        resourceId: '<vnet1ResourceId>'
      }
      {
        name: 'vnet2'
        resourceId: '<vnet2ResourceId>'
      }
    ]
  }
]
```

</details>
<p>

### Parameter Usage: `<connectivityConfigurations>`

Connectivity configurations allow you to create different network topologies based on your network needs. You have two topologies to choose from, a mesh network and a hub and spoke. Connectivities between virtual networks are defined within the configuration settings.

<details>

<summary>Parameter JSON format</summary>

```json
"connectivityConfigurations": {
  "value": [
    {
      "name": "hubSpokeConnectivity",
      "description": "hubSpokeConnectivity description",
      "connectivityTopology": "HubAndSpoke",
      "hubs": [
        {
          "resourceId": "<hubVnetResourceId>",
          "resourceType": "Microsoft.Network/virtualNetworks"
        }
      ],
      "deleteExistingPeering": "True",
      "isGlobal": "True",
      "appliesToGroups": [
        {
          "networkGroupId": "<networkGroupResourceId>",
          "useHubGateway": "False",
          "groupConnectivity": "None",
          "isGlobal": "False"
        }
      ]
    },
    {
      "name": "MeshConnectivity",
      "description": "MeshConnectivity description",
      "connectivityTopology": "Mesh",
      "deleteExistingPeering": "True",
      "isGlobal": "True",
      "appliesToGroups": [
        {
          "networkGroupId": "<networkGroupResourceId>",
          "useHubGateway": "False",
          "groupConnectivity": "None",
          "isGlobal": "False"
        }
      ]
    }
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
connectivityConfigurations: [
  {
    name: 'hubSpokeConnectivity'
    description: 'hubSpokeConnectivity description'
    connectivityTopology: 'HubAndSpoke'
    hubs: [
      {
        resourceId: '<hubVnetResourceId>'
        resourceType: 'Microsoft.Network/virtualNetworks'
      }
    ]
    deleteExistingPeering: 'True'
    isGlobal: 'True'
    appliesToGroups: [
      {
        networkGroupId: '<networkGroupResourceId>'
        useHubGateway: 'False'
        groupConnectivity: 'None'
        isGlobal: 'False'
      }
    ]
  }
  {
    name: 'MeshConnectivity'
    description: 'MeshConnectivity description'
    connectivityTopology: 'Mesh'
    deleteExistingPeering: 'True'
    isGlobal: 'True'
    appliesToGroups: [
      {
        networkGroupId: '<networkGroupResourceId>'
        useHubGateway: 'False'
        groupConnectivity: 'None'
        isGlobal: 'False'
      }
    ]
  }
]
```

</details>
<p>

### Parameter Usage: `<scopeConnections>`

Scope Connections to create for the network manager. Allows network manager to manage resources from another tenant. Supports management groups or subscriptions from another tenant.

<details>

<summary>Parameter JSON format</summary>

```json
"scopeConnections": {
  "value": [
    {
      "name": "scope-connection-test",
      "description": "description of the scope connection",
      "resourceId": "/subscriptions/<subscriptionId>", // or "/providers/Microsoft.Management/managementGroups/<managementGroupId>"
      "tenantid": "<tenantId>"
    }
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
scopeConnections: [
  {
    name: 'scope-connection-test'
    description: 'description of the scope connection'
    resourceId: '/subscriptions/<subscriptionId>', // or '/providers/Microsoft.Management/managementGroups/<managementGroupId>'
    tenantid: t'<tenantId>'
  }
]
```

</details>
<p>

### Parameter Usage: `<securityAdminConfigurations>`

Azure Virtual Network Manager provides two different types of configurations you can deploy across your virtual networks, one of them being a SecurityAdmin configuration. A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules. You then associate the rule collection with the network groups that you want to apply the security admin rules to.

<details>

<summary>Parameter JSON format</summary>

```json
"securityAdminConfigurations": {
  "value": [
    {
      "name": "test-security-admin-config",
      "description": "description of the security admin config",
      "applyOnNetworkIntentPolicyBasedServices": [
        "AllowRulesOnly"
      ],
      "ruleCollections": [
        {
          "name": "test-rule-collection-1",
          "description": "test-rule-collection-description",
          "appliesToGroups": [
            {
              "networkGroupId": "<networkGroupResourceId>"
            }
          ],
          "rules": [
            {
              "name": "test-inbound-allow-rule-1",
              "description": "test-inbound-allow-rule-1-description",
              "access": "Allow",
              "direction": "Inbound",
              "priority": 150,
              "protocol": "Tcp"
            }
          ]
        }
      ]
    }
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
securityAdminConfigurations: [
  {
    name: 'test-security-admin-config'
    description: 'description of the security admin config'
    applyOnNetworkIntentPolicyBasedServices: [
      'AllowRulesOnly'
    ]
    ruleCollections: [
      {
        name: 'test-rule-collection-1'
        description: 'test-rule-collection-description'
        appliesToGroups: [
          {
            networkGroupId: '<networkGroupResourceId>'
          }
        ]
        rules: [
          {
            name: 'test-inbound-allow-rule-1'
            description: 'test-inbound-allow-rule-1-description'
            access: 'Allow'
            direction: 'Inbound'
            priority: 150
            protocol: 'Tcp'
          }
        ]
      }
    ]
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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the network manager. |
| `resourceGroupName` | string | The resource group the network manager was deployed into. |
| `resourceId` | string | The resource ID of the network manager. |

## Cross-referenced modules

_None_

## Considerations

In order to deploy a Network Manager with the `networkManagerScopes` property set to `managementGroups`, you need to register the `Microsoft.Network` resource provider at the Management Group first ([ref](https://learn.microsoft.com/en-us/rest/api/resources/providers/register-at-management-group-scope)).

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module networkManagers './Microsoft.Network/networkManagers/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nnmcom'
  params: {
    // Required parameters
    name: '<name>'
    networkManagerScopeAccesses: [
      'Connectivity'
      'SecurityAdmin'
    ]
    networkManagerScopes: {
      subscriptions: [
        '<id>'
      ]
    }
    // Non-required parameters
    connectivityConfigurations: [
      {
        appliesToGroups: [
          {
            groupConnectivity: 'None'
            isGlobal: 'False'
            networkGroupId: '<networkGroupId>'
            useHubGateway: 'False'
          }
        ]
        connectivityTopology: 'HubAndSpoke'
        deleteExistingPeering: 'True'
        description: 'hubSpokeConnectivity description'
        hubs: [
          {
            resourceId: '<resourceId>'
            resourceType: 'Microsoft.Network/virtualNetworks'
          }
        ]
        isGlobal: 'True'
        name: 'hubSpokeConnectivity'
      }
      {
        appliesToGroups: [
          {
            groupConnectivity: 'None'
            isGlobal: 'False'
            networkGroupId: '<networkGroupId>'
            useHubGateway: 'False'
          }
        ]
        connectivityTopology: 'Mesh'
        deleteExistingPeering: 'True'
        description: 'MeshConnectivity description'
        isGlobal: 'True'
        name: 'MeshConnectivity'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    networkGroups: [
      {
        description: 'network-group-spokes description'
        name: 'network-group-spokes'
        staticMembers: [
          {
            name: 'virtualNetworkSpoke1'
            resourceId: '<resourceId>'
          }
          {
            name: 'virtualNetworkSpoke2'
            resourceId: '<resourceId>'
          }
        ]
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
    scopeConnections: [
      {
        description: 'description of the scope connection'
        name: 'scope-connection-test'
        resourceId: '<resourceId>'
        tenantid: '<tenantid>'
      }
    ]
    securityAdminConfigurations: [
      {
        applyOnNetworkIntentPolicyBasedServices: [
          'AllowRulesOnly'
        ]
        description: 'description of the security admin config'
        name: 'test-security-admin-config'
        ruleCollections: [
          {
            appliesToGroups: [
              {
                networkGroupId: '<networkGroupId>'
              }
            ]
            description: 'test-rule-collection-description'
            name: 'test-rule-collection-1'
            rules: [
              {
                access: 'Allow'
                description: 'test-inbound-allow-rule-1-description'
                direction: 'Inbound'
                name: 'test-inbound-allow-rule-1'
                priority: 150
                protocol: 'Tcp'
              }
              {
                access: 'Deny'
                description: 'test-outbound-deny-rule-2-description'
                direction: 'Outbound'
                name: 'test-outbound-deny-rule-2'
                priority: 200
                protocol: 'Tcp'
                sourcePortRanges: [
                  '442-445'
                  '80'
                ]
                sources: [
                  {
                    addressPrefix: 'AppService.WestEurope'
                    addressPrefixType: 'ServiceTag'
                  }
                ]
              }
            ]
          }
          {
            appliesToGroups: [
              {
                networkGroupId: '<networkGroupId>'
              }
            ]
            description: 'test-rule-collection-description'
            name: 'test-rule-collection-2'
            rules: [
              {
                access: 'Allow'
                description: 'test-inbound-allow-rule-3-description'
                destinationPortRanges: [
                  '442-445'
                  '80'
                ]
                destinations: [
                  {
                    addressPrefix: '192.168.20.20'
                    addressPrefixType: 'IPPrefix'
                  }
                ]
                direction: 'Inbound'
                name: 'test-inbound-allow-rule-3'
                priority: 250
                protocol: 'Tcp'
              }
              {
                access: 'Allow'
                description: 'test-inbound-allow-rule-4-description'
                destinations: [
                  {
                    addressPrefix: '172.16.0.0/24'
                    addressPrefixType: 'IPPrefix'
                  }
                  {
                    addressPrefix: '172.16.1.0/24'
                    addressPrefixType: 'IPPrefix'
                  }
                ]
                direction: 'Inbound'
                name: 'test-inbound-allow-rule-4'
                priority: 260
                protocol: 'Tcp'
                sources: [
                  {
                    addressPrefix: '10.0.0.0/24'
                    addressPrefixType: 'IPPrefix'
                  }
                  {
                    addressPrefix: '100.100.100.100'
                    addressPrefixType: 'IPPrefix'
                  }
                ]
              }
            ]
          }
        ]
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
      "value": "<name>"
    },
    "networkManagerScopeAccesses": {
      "value": [
        "Connectivity",
        "SecurityAdmin"
      ]
    },
    "networkManagerScopes": {
      "value": {
        "subscriptions": [
          "<id>"
        ]
      }
    },
    // Non-required parameters
    "connectivityConfigurations": {
      "value": [
        {
          "appliesToGroups": [
            {
              "groupConnectivity": "None",
              "isGlobal": "False",
              "networkGroupId": "<networkGroupId>",
              "useHubGateway": "False"
            }
          ],
          "connectivityTopology": "HubAndSpoke",
          "deleteExistingPeering": "True",
          "description": "hubSpokeConnectivity description",
          "hubs": [
            {
              "resourceId": "<resourceId>",
              "resourceType": "Microsoft.Network/virtualNetworks"
            }
          ],
          "isGlobal": "True",
          "name": "hubSpokeConnectivity"
        },
        {
          "appliesToGroups": [
            {
              "groupConnectivity": "None",
              "isGlobal": "False",
              "networkGroupId": "<networkGroupId>",
              "useHubGateway": "False"
            }
          ],
          "connectivityTopology": "Mesh",
          "deleteExistingPeering": "True",
          "description": "MeshConnectivity description",
          "isGlobal": "True",
          "name": "MeshConnectivity"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "networkGroups": {
      "value": [
        {
          "description": "network-group-spokes description",
          "name": "network-group-spokes",
          "staticMembers": [
            {
              "name": "virtualNetworkSpoke1",
              "resourceId": "<resourceId>"
            },
            {
              "name": "virtualNetworkSpoke2",
              "resourceId": "<resourceId>"
            }
          ]
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
    "scopeConnections": {
      "value": [
        {
          "description": "description of the scope connection",
          "name": "scope-connection-test",
          "resourceId": "<resourceId>",
          "tenantid": "<tenantid>"
        }
      ]
    },
    "securityAdminConfigurations": {
      "value": [
        {
          "applyOnNetworkIntentPolicyBasedServices": [
            "AllowRulesOnly"
          ],
          "description": "description of the security admin config",
          "name": "test-security-admin-config",
          "ruleCollections": [
            {
              "appliesToGroups": [
                {
                  "networkGroupId": "<networkGroupId>"
                }
              ],
              "description": "test-rule-collection-description",
              "name": "test-rule-collection-1",
              "rules": [
                {
                  "access": "Allow",
                  "description": "test-inbound-allow-rule-1-description",
                  "direction": "Inbound",
                  "name": "test-inbound-allow-rule-1",
                  "priority": 150,
                  "protocol": "Tcp"
                },
                {
                  "access": "Deny",
                  "description": "test-outbound-deny-rule-2-description",
                  "direction": "Outbound",
                  "name": "test-outbound-deny-rule-2",
                  "priority": 200,
                  "protocol": "Tcp",
                  "sourcePortRanges": [
                    "442-445",
                    "80"
                  ],
                  "sources": [
                    {
                      "addressPrefix": "AppService.WestEurope",
                      "addressPrefixType": "ServiceTag"
                    }
                  ]
                }
              ]
            },
            {
              "appliesToGroups": [
                {
                  "networkGroupId": "<networkGroupId>"
                }
              ],
              "description": "test-rule-collection-description",
              "name": "test-rule-collection-2",
              "rules": [
                {
                  "access": "Allow",
                  "description": "test-inbound-allow-rule-3-description",
                  "destinationPortRanges": [
                    "442-445",
                    "80"
                  ],
                  "destinations": [
                    {
                      "addressPrefix": "192.168.20.20",
                      "addressPrefixType": "IPPrefix"
                    }
                  ],
                  "direction": "Inbound",
                  "name": "test-inbound-allow-rule-3",
                  "priority": 250,
                  "protocol": "Tcp"
                },
                {
                  "access": "Allow",
                  "description": "test-inbound-allow-rule-4-description",
                  "destinations": [
                    {
                      "addressPrefix": "172.16.0.0/24",
                      "addressPrefixType": "IPPrefix"
                    },
                    {
                      "addressPrefix": "172.16.1.0/24",
                      "addressPrefixType": "IPPrefix"
                    }
                  ],
                  "direction": "Inbound",
                  "name": "test-inbound-allow-rule-4",
                  "priority": 260,
                  "protocol": "Tcp",
                  "sources": [
                    {
                      "addressPrefix": "10.0.0.0/24",
                      "addressPrefixType": "IPPrefix"
                    },
                    {
                      "addressPrefix": "100.100.100.100",
                      "addressPrefixType": "IPPrefix"
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    }
  }
}
```

</details>
<p>
