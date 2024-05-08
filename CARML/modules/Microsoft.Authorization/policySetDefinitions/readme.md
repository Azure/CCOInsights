# Policy Set Definitions `[Microsoft.Authorization/policySetDefinitions]`

With this module you can create policy set definitions across the management group or subscription scope.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Module Usage Guidance](#Module-Usage-Guidance)
- [Outputs](#Outputs)
- [Considerations](#Considerations)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policySetDefinitions` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-06-01/policySetDefinitions) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Specifies the name of the policy Set Definition (Initiative). |
| `policyDefinitions` | array | The array of Policy definitions object to include for this policy set. Each object must include the Policy definition ID, and optionally other properties like parameters. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `description` | string | `''` | The description name of the Set Definition (Initiative). |
| `displayName` | string | `''` | The display name of the Set Definition (Initiative). Maximum length is 128 characters. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[deployment().location]` | Location deployment metadata. |
| `managementGroupId` | string | `[managementGroup().name]` | The group ID of the Management Group (Scope). If not provided, will use the current scope for deployment. |
| `metadata` | object | `{object}` | The Set Definition (Initiative) metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `parameters` | object | `{object}` | The Set Definition (Initiative) parameters that can be used in policy definition references. |
| `policyDefinitionGroups` | array | `[]` | The metadata describing groups of policy definition references within the Policy Set Definition (Initiative). |
| `subscriptionId` | string | `''` | The subscription ID of the subscription (Scope). Cannot be used with managementGroupId. |


### Parameter Usage: `managementGroupId`

To deploy resource to a Management Group, provide the `managementGroupId` as an input parameter to the module.


<details>

<summary>Parameter JSON format</summary>

```json
"managementGroupId": {
    "value": "contoso-group"
}
```

</details>


<details>

<summary>Bicep format</summary>

```bicep
managementGroupId: 'contoso-group'
```

</details>
<p>

> `managementGroupId` is an optional parameter. If not provided, the deployment will use the management group defined in the current deployment scope (i.e. `managementGroup().name`).

### Parameter Usage: `subscriptionId`

To deploy resource to an Azure Subscription, provide the `subscriptionId` as an input parameter to the module. **Example**:

<details>

<summary>Parameter JSON format</summary>

```json
"subscriptionId": {
    "value": "12345678-b049-471c-95af-123456789012"
}
```

</details>


<details>

<summary>Bicep format</summary>

```bicep
subscriptionId: '12345678-b049-471c-95af-123456789012'
```

</details>
<p>

## Module Usage Guidance

In general, most of the resources under the `Microsoft.Authorization` namespace allows deploying resources at multiple scopes (management groups, subscriptions, resource groups). The `deploy.bicep` root module is simply an orchestrator module that targets sub-modules for different scopes as seen in the parameter usage section. All sub-modules for this namespace have folders that represent the target scope. For example, if the orchestrator module in the [root](deploy.bicep) needs to target 'subscription' level scopes. It will look at the relative path ['/subscription/deploy.bicep'](./subscription/deploy.bicep) and use this sub-module for the actual deployment, while still passing the same parameters from the root module.

The above method is useful when you want to use a single point to interact with the module but rely on parameter combinations to achieve the target scope. But what if you want to incorporate this module in other modules with lower scopes? This would force you to deploy the module in scope `managementGroup` regardless and further require you to provide its ID with it. If you do not set the scope to management group, this would be the error that you can expect to face:

```bicep
Error BCP134: Scope "subscription" is not valid for this module. Permitted scopes: "managementGroup"
```

The solution is to have the option of directly targeting the sub-module that achieves the required scope. For example, if you have your own Bicep file wanting to create resources at the subscription level, and also use some of the modules from the `Microsoft.Authorization` namespace, then you can directly use the sub-module ['/subscription/deploy.bicep'](./subscription/deploy.bicep) as a path within your repository, or reference that same published module from the bicep registry. CARML also published the sub-modules so you would be able to reference it like the following:

**Bicep Registry Reference**
```bicep
module policysetdefinition 'br:bicepregistry.azurecr.io/bicep/modules/microsoft.authorization.policysetdefinitions.subscription:version' = {}
```
**Local Path Reference**
```bicep
module policysetdefinition 'yourpath/modules/Microsoft.Authorization.policySetDefinitions/subscription/deploy.bicep' = {}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Set Definition Name. |
| `resourceId` | string | Policy Set Definition resource ID. |

## Considerations

- Policy Set Definitions (Initiatives) have a dependency on Policy Assignments being applied before creating an initiative. You can use the Policy Assignment [Module](../policyDefinitions/deploy.bicep) to deploy a Policy Definition and then create an initiative for it on the required scope.

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Mg.Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policySetDefinitions './Microsoft.Authorization/policySetDefinitions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-apsdmgcom'
  params: {
    // Required parameters
    name: '<<namePrefix>>apsdmgcom001'
    policyDefinitions: [
      {
        groupNames: [
          'ARM'
        ]
        parameters: {
          listOfAllowedLocations: {
            value: [
              'australiaeast'
            ]
          }
        }
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
        policyDefinitionReferenceId: 'Allowed locations_1'
      }
      {
        groupNames: [
          'ARM'
        ]
        parameters: {
          listOfAllowedLocations: {
            value: [
              'australiaeast'
            ]
          }
        }
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988'
        policyDefinitionReferenceId: 'Allowed locations for resource groups_1'
      }
    ]
    // Non-required parameters
    description: '[Description] This policy set definition is deployed at management group scope'
    displayName: '[DisplayName] This policy set definition is deployed at management group scope'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    metadata: {
      category: 'Security'
      version: '1'
    }
    policyDefinitionGroups: [
      {
        name: 'Network'
      }
      {
        name: 'ARM'
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
      "value": "<<namePrefix>>apsdmgcom001"
    },
    "policyDefinitions": {
      "value": [
        {
          "groupNames": [
            "ARM"
          ],
          "parameters": {
            "listOfAllowedLocations": {
              "value": [
                "australiaeast"
              ]
            }
          },
          "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c",
          "policyDefinitionReferenceId": "Allowed locations_1"
        },
        {
          "groupNames": [
            "ARM"
          ],
          "parameters": {
            "listOfAllowedLocations": {
              "value": [
                "australiaeast"
              ]
            }
          },
          "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988",
          "policyDefinitionReferenceId": "Allowed locations for resource groups_1"
        }
      ]
    },
    // Non-required parameters
    "description": {
      "value": "[Description] This policy set definition is deployed at management group scope"
    },
    "displayName": {
      "value": "[DisplayName] This policy set definition is deployed at management group scope"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "metadata": {
      "value": {
        "category": "Security",
        "version": "1"
      }
    },
    "policyDefinitionGroups": {
      "value": [
        {
          "name": "Network"
        },
        {
          "name": "ARM"
        }
      ]
    }
  }
}
```

</details>
<p>

<h3>Example 2: Mg.Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policySetDefinitions './Microsoft.Authorization/policySetDefinitions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-apsdmgmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>apsdmgmin001'
    policyDefinitions: [
      {
        parameters: {
          listOfAllowedLocations: {
            value: [
              'australiaeast'
            ]
          }
        }
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
      }
    ]
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
      "value": "<<namePrefix>>apsdmgmin001"
    },
    "policyDefinitions": {
      "value": [
        {
          "parameters": {
            "listOfAllowedLocations": {
              "value": [
                "australiaeast"
              ]
            }
          },
          "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
        }
      ]
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

<h3>Example 3: Sub.Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policySetDefinitions './Microsoft.Authorization/policySetDefinitions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-apsdsubcom'
  params: {
    // Required parameters
    name: '<<namePrefix>>apsdsubcom001'
    policyDefinitions: [
      {
        groupNames: [
          'ARM'
        ]
        parameters: {
          listOfAllowedLocations: {
            value: [
              'australiaeast'
            ]
          }
        }
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
        policyDefinitionReferenceId: 'Allowed locations_1'
      }
      {
        groupNames: [
          'ARM'
        ]
        parameters: {
          listOfAllowedLocations: {
            value: [
              'australiaeast'
            ]
          }
        }
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988'
        policyDefinitionReferenceId: 'Allowed locations for resource groups_1'
      }
    ]
    // Non-required parameters
    description: '[Description] This policy set definition is deployed at subscription scope'
    displayName: '[DisplayName] This policy set definition is deployed at subscription scope'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    metadata: {
      category: 'Security'
      version: '1'
    }
    policyDefinitionGroups: [
      {
        name: 'Network'
      }
      {
        name: 'ARM'
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
      "value": "<<namePrefix>>apsdsubcom001"
    },
    "policyDefinitions": {
      "value": [
        {
          "groupNames": [
            "ARM"
          ],
          "parameters": {
            "listOfAllowedLocations": {
              "value": [
                "australiaeast"
              ]
            }
          },
          "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c",
          "policyDefinitionReferenceId": "Allowed locations_1"
        },
        {
          "groupNames": [
            "ARM"
          ],
          "parameters": {
            "listOfAllowedLocations": {
              "value": [
                "australiaeast"
              ]
            }
          },
          "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988",
          "policyDefinitionReferenceId": "Allowed locations for resource groups_1"
        }
      ]
    },
    // Non-required parameters
    "description": {
      "value": "[Description] This policy set definition is deployed at subscription scope"
    },
    "displayName": {
      "value": "[DisplayName] This policy set definition is deployed at subscription scope"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "metadata": {
      "value": {
        "category": "Security",
        "version": "1"
      }
    },
    "policyDefinitionGroups": {
      "value": [
        {
          "name": "Network"
        },
        {
          "name": "ARM"
        }
      ]
    }
  }
}
```

</details>
<p>

<h3>Example 4: Sub.Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policySetDefinitions './Microsoft.Authorization/policySetDefinitions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-apsdsubmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>apsdsubmin001'
    policyDefinitions: [
      {
        parameters: {
          listOfAllowedLocations: {
            value: [
              'australiaeast'
            ]
          }
        }
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
      }
    ]
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
      "value": "<<namePrefix>>apsdsubmin001"
    },
    "policyDefinitions": {
      "value": [
        {
          "parameters": {
            "listOfAllowedLocations": {
              "value": [
                "australiaeast"
              ]
            }
          },
          "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
        }
      ]
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
