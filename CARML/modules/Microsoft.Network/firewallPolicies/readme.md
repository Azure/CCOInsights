# Firewall Policies `[Microsoft.Network/firewallPolicies]`

This module deploys Firewall Policies.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/firewallPolicies` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/firewallPolicies) |
| `Microsoft.Network/firewallPolicies/ruleCollectionGroups` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/firewallPolicies/ruleCollectionGroups) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Firewall Policy. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `basePolicyResourceId` | string | `''` |  | Resource ID of the base policy. |
| `bypassTrafficSettings` | array | `[]` |  | List of rules for traffic to bypass. |
| `certificateName` | string | `''` |  | Name of the CA certificate. |
| `defaultWorkspaceId` | string | `''` |  | Default Log Analytics Resource ID for Firewall Policy Insights. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enableProxy` | bool | `False` |  | Enable DNS Proxy on Firewalls attached to the Firewall Policy. |
| `fqdns` | array | `[]` |  | List of FQDNs for the ThreatIntel Allowlist. |
| `insightsIsEnabled` | bool | `False` |  | A flag to indicate if the insights are enabled on the policy. |
| `ipAddresses` | array | `[]` |  | List of IP addresses for the ThreatIntel Allowlist. |
| `keyVaultSecretId` | string | `''` |  | Secret ID of (base-64 encoded unencrypted PFX) Secret or Certificate object stored in KeyVault. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `mode` | string | `'Off'` | `[Alert, Deny, Off]` | The configuring of intrusion detection. |
| `privateRanges` | array | `[]` |  | List of private IP addresses/IP address ranges to not be SNAT. |
| `retentionDays` | int | `365` |  | Number of days the insights should be enabled on the policy. |
| `ruleCollectionGroups` | _[ruleCollectionGroups](ruleCollectionGroups/readme.md)_ array | `[]` |  | Rule collection groups. |
| `servers` | array | `[]` |  | List of Custom DNS Servers. |
| `signatureOverrides` | array | `[]` |  | List of specific signatures states. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the Firewall policy resource. |
| `threatIntelMode` | string | `'Off'` | `[Alert, Deny, Off]` | The operation mode for Threat Intel. |
| `tier` | string | `'Standard'` | `[Premium, Standard]` | Tier of Firewall Policy. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `workspaces` | array | `[]` |  | List of workspaces for Firewall Policy Insights. |


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

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed firewall policy. |
| `resourceGroupName` | string | The resource group of the deployed firewall policy. |
| `resourceId` | string | The resource ID of the deployed firewall policy. |

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
module firewallPolicies './Microsoft.Network/firewallPolicies/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nfpcom'
  params: {
    // Required parameters
    name: '<<namePrefix>>nfpcom001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    ruleCollectionGroups: [
      {
        name: '<<namePrefix>>-rule-001'
        priority: 5000
        ruleCollections: [
          {
            action: {
              type: 'Allow'
            }
            name: 'collection002'
            priority: 5555
            ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
            rules: [
              {
                destinationAddresses: [
                  '*'
                ]
                destinationFqdns: []
                destinationIpGroups: []
                destinationPorts: [
                  '80'
                ]
                ipProtocols: [
                  'TCP'
                  'UDP'
                ]
                name: 'rule002'
                ruleType: 'NetworkRule'
                sourceAddresses: [
                  '*'
                ]
                sourceIpGroups: []
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
      "value": "<<namePrefix>>nfpcom001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "ruleCollectionGroups": {
      "value": [
        {
          "name": "<<namePrefix>>-rule-001",
          "priority": 5000,
          "ruleCollections": [
            {
              "action": {
                "type": "Allow"
              },
              "name": "collection002",
              "priority": 5555,
              "ruleCollectionType": "FirewallPolicyFilterRuleCollection",
              "rules": [
                {
                  "destinationAddresses": [
                    "*"
                  ],
                  "destinationFqdns": [],
                  "destinationIpGroups": [],
                  "destinationPorts": [
                    "80"
                  ],
                  "ipProtocols": [
                    "TCP",
                    "UDP"
                  ],
                  "name": "rule002",
                  "ruleType": "NetworkRule",
                  "sourceAddresses": [
                    "*"
                  ],
                  "sourceIpGroups": []
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

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module firewallPolicies './Microsoft.Network/firewallPolicies/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nfpmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>nfpmin001'
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
      "value": "<<namePrefix>>nfpmin001"
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
