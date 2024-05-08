# Policy Exemptions `[Microsoft.Authorization/policyExemptions]`

With this module you can create policy exemptions across the management group, subscription or resource group scope.

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
| `Microsoft.Authorization/policyExemptions` | [2022-07-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-07-01-preview/policyExemptions) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Specifies the name of the policy exemption. Maximum length is 64 characters for management group, subscription and resource group scopes. |
| `policyAssignmentId` | string | The resource ID of the policy assignment that is being exempted. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `assignmentScopeValidation` | string | `''` | `['', Default, DoNotValidate]` | The option whether validate the exemption is at or under the assignment scope. |
| `description` | string | `''` |  | The description of the policy exemption. |
| `displayName` | string | `''` |  | The display name of the policy exemption. Maximum length is 128 characters. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `exemptionCategory` | string | `'Mitigated'` | `[Mitigated, Waiver]` | The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated. |
| `expiresOn` | string | `''` |  | The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z. |
| `location` | string | `[deployment().location]` |  | Location deployment metadata. |
| `managementGroupId` | string | `[managementGroup().name]` |  | The group ID of the management group to be exempted from the policy assignment. If not provided, will use the current scope for deployment. |
| `metadata` | object | `{object}` |  | The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `policyDefinitionReferenceIds` | array | `[]` |  | The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition. |
| `resourceGroupName` | string | `''` |  | The name of the resource group to be exempted from the policy assignment. Must also use the subscription ID parameter. |
| `resourceSelectors` | array | `[]` |  | The resource selector list to filter policies by resource properties. |
| `subscriptionId` | string | `''` |  | The subscription ID of the subscription to be exempted from the policy assignment. Cannot use with management group ID parameter. |


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

### Parameter Usage: `resourceGroupName`

To deploy resource to a Resource Group, provide the `subscriptionId` and `resourceGroupName` as an input parameter to the module. **Example**:

```json
"subscriptionId": {
    "value": "12345678-b049-471c-95af-123456789012"
},
"resourceGroupName": {
    "value": "target-resourceGroup"
}
```

> The `subscriptionId` is used to enable deployment to a Resource Group Scope, allowing the use of the `resourceGroup()` function from a Management Group Scope. [Additional Details](https://github.com/Azure/bicep/pull/1420).

### Parameter Usage: `resourceSelectors`

To deploy Resource Selectors, you can apply the following syntax


<details>

<summary>Parameter JSON format</summary>

```json
"resourceSelectors": [
  {
    "name": "TemporaryMitigation",
    "selectors": [
      {
        "kind": "resourceLocation",
        "in": [
          "westcentralus"
        ]
      }
    ]
  }
]
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
resourceSelectors: [
  {
    name: 'TemporaryMitigation'
    selectors: [
      {
        kind: 'resourceLocation'
        in: [
          'westcentralus'
        ]
      }
    ]
  }
]
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
module policyexemption 'br:bicepregistry.azurecr.io/bicep/modules/microsoft.authorization.policyexemptions.subscription:version' = {}
```
**Local Path Reference**
```bicep
module policyexemption 'yourpath/modules/Microsoft.Authorization.policyExemptions/subscription/deploy.bicep' = {}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Exemption Name. |
| `resourceId` | string | Policy Exemption resource ID. |
| `scope` | string | Policy Exemption Scope. |

## Considerations

- Policy Exemptions have a dependency on Policy Assignments being applied before creating an exemption. You can use the Policy Assignment [Module](../policyAssignments/deploy.bicep) to deploy a Policy Assignment and then create the exemption for it on the required scope.

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
module policyExemptions './Microsoft.Authorization/policyExemptions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-apemgcom'
  params: {
    // Required parameters
    name: '<<namePrefix>>apemgcom001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    assignmentScopeValidation: 'Default'
    description: 'My description'
    displayName: '[Display Name] policy exempt (management group scope)'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    exemptionCategory: 'Waiver'
    expiresOn: '2025-10-02T03:57:00Z'
    metadata: {
      category: 'Security'
    }
    policyDefinitionReferenceIds: [
      '<policyDefinitionReferenceId>'
    ]
    resourceSelectors: [
      {
        name: 'TemporaryMitigation'
        selectors: [
          {
            in: [
              'westcentralus'
            ]
            kind: 'resourceLocation'
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
      "value": "<<namePrefix>>apemgcom001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "assignmentScopeValidation": {
      "value": "Default"
    },
    "description": {
      "value": "My description"
    },
    "displayName": {
      "value": "[Display Name] policy exempt (management group scope)"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "exemptionCategory": {
      "value": "Waiver"
    },
    "expiresOn": {
      "value": "2025-10-02T03:57:00Z"
    },
    "metadata": {
      "value": {
        "category": "Security"
      }
    },
    "policyDefinitionReferenceIds": {
      "value": [
        "<policyDefinitionReferenceId>"
      ]
    },
    "resourceSelectors": {
      "value": [
        {
          "name": "TemporaryMitigation",
          "selectors": [
            {
              "in": [
                "westcentralus"
              ],
              "kind": "resourceLocation"
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

<h3>Example 2: Mg.Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policyExemptions './Microsoft.Authorization/policyExemptions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-apemgmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>apemgmin001'
    policyAssignmentId: '<policyAssignmentId>'
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
      "value": "<<namePrefix>>apemgmin001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
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

<h3>Example 3: Rg.Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policyExemptions './Microsoft.Authorization/policyExemptions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-apergcom'
  params: {
    // Required parameters
    name: '<<namePrefix>>apergcom001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    assignmentScopeValidation: 'Default'
    description: 'My description'
    displayName: '[Display Name] policy exempt (resource group scope)'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    exemptionCategory: 'Waiver'
    expiresOn: '2025-10-02T03:57:00Z'
    metadata: {
      category: 'Security'
    }
    policyDefinitionReferenceIds: [
      '<policyDefinitionReferenceId>'
    ]
    resourceSelectors: [
      {
        name: 'TemporaryMitigation'
        selectors: [
          {
            in: [
              'westcentralus'
            ]
            kind: 'resourceLocation'
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
      "value": "<<namePrefix>>apergcom001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "assignmentScopeValidation": {
      "value": "Default"
    },
    "description": {
      "value": "My description"
    },
    "displayName": {
      "value": "[Display Name] policy exempt (resource group scope)"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "exemptionCategory": {
      "value": "Waiver"
    },
    "expiresOn": {
      "value": "2025-10-02T03:57:00Z"
    },
    "metadata": {
      "value": {
        "category": "Security"
      }
    },
    "policyDefinitionReferenceIds": {
      "value": [
        "<policyDefinitionReferenceId>"
      ]
    },
    "resourceSelectors": {
      "value": [
        {
          "name": "TemporaryMitigation",
          "selectors": [
            {
              "in": [
                "westcentralus"
              ],
              "kind": "resourceLocation"
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

<h3>Example 4: Rg.Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policyExemptions './Microsoft.Authorization/policyExemptions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-apergmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>apergmin001'
    policyAssignmentId: '<policyAssignmentId>'
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
      "value": "<<namePrefix>>apergmin001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
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

<h3>Example 5: Sub.Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policyExemptions './Microsoft.Authorization/policyExemptions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-apesubcom'
  params: {
    // Required parameters
    name: '<<namePrefix>>apesubcom001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    assignmentScopeValidation: 'Default'
    description: 'My description'
    displayName: '[Display Name] policy exempt (subscription scope)'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    exemptionCategory: 'Waiver'
    expiresOn: '2025-10-02T03:57:00Z'
    metadata: {
      category: 'Security'
    }
    policyDefinitionReferenceIds: [
      '<policyDefinitionReferenceId>'
    ]
    resourceSelectors: [
      {
        name: 'TemporaryMitigation'
        selectors: [
          {
            in: [
              'westcentralus'
            ]
            kind: 'resourceLocation'
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
      "value": "<<namePrefix>>apesubcom001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "assignmentScopeValidation": {
      "value": "Default"
    },
    "description": {
      "value": "My description"
    },
    "displayName": {
      "value": "[Display Name] policy exempt (subscription scope)"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "exemptionCategory": {
      "value": "Waiver"
    },
    "expiresOn": {
      "value": "2025-10-02T03:57:00Z"
    },
    "metadata": {
      "value": {
        "category": "Security"
      }
    },
    "policyDefinitionReferenceIds": {
      "value": [
        "<policyDefinitionReferenceId>"
      ]
    },
    "resourceSelectors": {
      "value": [
        {
          "name": "TemporaryMitigation",
          "selectors": [
            {
              "in": [
                "westcentralus"
              ],
              "kind": "resourceLocation"
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

<h3>Example 6: Sub.Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module policyExemptions './Microsoft.Authorization/policyExemptions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-apesubmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>apesubmin001'
    policyAssignmentId: '<policyAssignmentId>'
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
      "value": "<<namePrefix>>apesubmin001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
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
