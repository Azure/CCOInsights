# Policy Definitions `[Microsoft.Authorization/policyDefinitions]`

With this module you can create policy definitions across the management group or subscription scope.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Module Usage Guidance](#Module-Usage-Guidance)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyDefinitions` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-06-01/policyDefinitions) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Specifies the name of the policy definition. Maximum length is 64 characters for management group scope and subscription scope. |
| `policyRule` | object | The Policy Rule details for the Policy Definition. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `description` | string | `''` |  | The policy definition description. |
| `displayName` | string | `''` |  | The display name of the policy definition. Maximum length is 128 characters. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[deployment().location]` |  | Location deployment metadata. |
| `managementGroupId` | string | `[managementGroup().name]` |  | The group ID of the Management Group (Scope). If not provided, will use the current scope for deployment. |
| `metadata` | object | `{object}` |  | The policy Definition metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `mode` | string | `'All'` | `[All, Indexed, Microsoft.ContainerService.Data, Microsoft.KeyVault.Data, Microsoft.Kubernetes.Data, Microsoft.Network.Data]` | The policy definition mode. Default is All, Some examples are All, Indexed, Microsoft.KeyVault.Data. |
| `parameters` | object | `{object}` |  | The policy definition parameters that can be used in policy definition references. |
| `subscriptionId` | string | `''` |  | The subscription ID of the subscription (Scope). Cannot be used with managementGroupId. |


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
module policydefinition 'br:bicepregistry.azurecr.io/bicep/modules/microsoft.authorization.policydefinitions.subscription:version' = {}
```
**Local Path Reference**
```bicep
module policydefinition 'yourpath/modules/Microsoft.Authorization.policyDefinitions/subscription/deploy.bicep' = {}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Definition Name. |
| `resourceId` | string | Policy Definition resource ID. |
| `roleDefinitionIds` | array | Policy Definition Role Definition IDs. |

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
module policyDefinitions './Microsoft.Authorization/policyDefinitions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-apdmgcom'
  params: {
    // Required parameters
    name: '<<namePrefix>>apdmgcom001'
    policyRule: {
      if: {
        allOf: [
          {
            equals: 'Microsoft.Resources/subscriptions'
            field: 'type'
          }
          {
            exists: 'false'
            field: '[concat(\'tags[\' parameters(\'tagName\') \']\')]'
          }
        ]
      }
      then: {
        details: {
          operations: [
            {
              field: '[concat(\'tags[\' parameters(\'tagName\') \']\')]'
              operation: 'add'
              value: '[parameters(\'tagValue\')]'
            }
          ]
          roleDefinitionIds: [
            '/providers/microsoft.authorization/roleDefinitions/4a9ae827-6dc8-4573-8ac7-8239d42aa03f'
          ]
        }
        effect: 'modify'
      }
    }
    // Non-required parameters
    description: '[Description] This policy definition is deployed at the management group scope'
    displayName: '[DisplayName] This policy definition is deployed at the management group scope'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    metadata: {
      category: 'Security'
    }
    parameters: {
      tagName: {
        metadata: {
          description: 'Name of the tag such as \'environment\''
          displayName: 'Tag Name'
        }
        type: 'String'
      }
      tagValue: {
        metadata: {
          description: 'Value of the tag such as \'environment\''
          displayName: 'Tag Value'
        }
        type: 'String'
      }
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
      "value": "<<namePrefix>>apdmgcom001"
    },
    "policyRule": {
      "value": {
        "if": {
          "allOf": [
            {
              "equals": "Microsoft.Resources/subscriptions",
              "field": "type"
            },
            {
              "exists": "false",
              "field": "[concat(\"tags[\", parameters(\"tagName\"), \"]\")]"
            }
          ]
        },
        "then": {
          "details": {
            "operations": [
              {
                "field": "[concat(\"tags[\", parameters(\"tagName\"), \"]\")]",
                "operation": "add",
                "value": "[parameters(\"tagValue\")]"
              }
            ],
            "roleDefinitionIds": [
              "/providers/microsoft.authorization/roleDefinitions/4a9ae827-6dc8-4573-8ac7-8239d42aa03f"
            ]
          },
          "effect": "modify"
        }
      }
    },
    // Non-required parameters
    "description": {
      "value": "[Description] This policy definition is deployed at the management group scope"
    },
    "displayName": {
      "value": "[DisplayName] This policy definition is deployed at the management group scope"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "metadata": {
      "value": {
        "category": "Security"
      }
    },
    "parameters": {
      "value": {
        "tagName": {
          "metadata": {
            "description": "Name of the tag such as \"environment\"",
            "displayName": "Tag Name"
          },
          "type": "String"
        },
        "tagValue": {
          "metadata": {
            "description": "Value of the tag such as \"environment\"",
            "displayName": "Tag Value"
          },
          "type": "String"
        }
      }
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
module policyDefinitions './Microsoft.Authorization/policyDefinitions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-apdmgmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>apdmgmin001'
    policyRule: {
      if: {
        allOf: [
          {
            equals: 'Microsoft.KeyVault/vaults'
            field: 'type'
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    parameters: {
      effect: {
        allowedValues: [
          'Audit'
        ]
        defaultValue: 'Audit'
        type: 'String'
      }
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
      "value": "<<namePrefix>>apdmgmin001"
    },
    "policyRule": {
      "value": {
        "if": {
          "allOf": [
            {
              "equals": "Microsoft.KeyVault/vaults",
              "field": "type"
            }
          ]
        },
        "then": {
          "effect": "[parameters(\"effect\")]"
        }
      }
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "parameters": {
      "value": {
        "effect": {
          "allowedValues": [
            "Audit"
          ],
          "defaultValue": "Audit",
          "type": "String"
        }
      }
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
module policyDefinitions './Microsoft.Authorization/policyDefinitions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-apdsubcom'
  params: {
    // Required parameters
    name: '<<namePrefix>>apdsubcom001'
    policyRule: {
      if: {
        allOf: [
          {
            equals: 'Microsoft.Resources/subscriptions'
            field: 'type'
          }
          {
            exists: 'false'
            field: '[concat(\'tags[\' parameters(\'tagName\') \']\')]'
          }
        ]
      }
      then: {
        details: {
          operations: [
            {
              field: '[concat(\'tags[\' parameters(\'tagName\') \']\')]'
              operation: 'add'
              value: '[parameters(\'tagValue\')]'
            }
          ]
          roleDefinitionIds: [
            '/providers/microsoft.authorization/roleDefinitions/4a9ae827-6dc8-4573-8ac7-8239d42aa03f'
          ]
        }
        effect: 'modify'
      }
    }
    // Non-required parameters
    description: '[Description] This policy definition is deployed at subscription scope'
    displayName: '[DisplayName] This policy definition is deployed at subscription scope'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    metadata: {
      category: 'Security'
    }
    parameters: {
      tagName: {
        metadata: {
          description: 'Name of the tag such as \'environment\''
          displayName: 'Tag Name'
        }
        type: 'String'
      }
      tagValue: {
        metadata: {
          description: 'Value of the tag such as \'production\''
          displayName: 'Tag Value'
        }
        type: 'String'
      }
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
      "value": "<<namePrefix>>apdsubcom001"
    },
    "policyRule": {
      "value": {
        "if": {
          "allOf": [
            {
              "equals": "Microsoft.Resources/subscriptions",
              "field": "type"
            },
            {
              "exists": "false",
              "field": "[concat(\"tags[\", parameters(\"tagName\"), \"]\")]"
            }
          ]
        },
        "then": {
          "details": {
            "operations": [
              {
                "field": "[concat(\"tags[\", parameters(\"tagName\"), \"]\")]",
                "operation": "add",
                "value": "[parameters(\"tagValue\")]"
              }
            ],
            "roleDefinitionIds": [
              "/providers/microsoft.authorization/roleDefinitions/4a9ae827-6dc8-4573-8ac7-8239d42aa03f"
            ]
          },
          "effect": "modify"
        }
      }
    },
    // Non-required parameters
    "description": {
      "value": "[Description] This policy definition is deployed at subscription scope"
    },
    "displayName": {
      "value": "[DisplayName] This policy definition is deployed at subscription scope"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "metadata": {
      "value": {
        "category": "Security"
      }
    },
    "parameters": {
      "value": {
        "tagName": {
          "metadata": {
            "description": "Name of the tag such as \"environment\"",
            "displayName": "Tag Name"
          },
          "type": "String"
        },
        "tagValue": {
          "metadata": {
            "description": "Value of the tag such as \"production\"",
            "displayName": "Tag Value"
          },
          "type": "String"
        }
      }
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
module policyDefinitions './Microsoft.Authorization/policyDefinitions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-apdsubmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>apdsubmin001'
    policyRule: {
      if: {
        allOf: [
          {
            equals: 'Microsoft.KeyVault/vaults'
            field: 'type'
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    parameters: {
      effect: {
        allowedValues: [
          'Audit'
        ]
        defaultValue: 'Audit'
        type: 'String'
      }
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
      "value": "<<namePrefix>>apdsubmin001"
    },
    "policyRule": {
      "value": {
        "if": {
          "allOf": [
            {
              "equals": "Microsoft.KeyVault/vaults",
              "field": "type"
            }
          ]
        },
        "then": {
          "effect": "[parameters(\"effect\")]"
        }
      }
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "parameters": {
      "value": {
        "effect": {
          "allowedValues": [
            "Audit"
          ],
          "defaultValue": "Audit",
          "type": "String"
        }
      }
    }
  }
}
```

</details>
<p>
