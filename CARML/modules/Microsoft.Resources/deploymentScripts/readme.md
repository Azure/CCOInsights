# Deployment Scripts `[Microsoft.Resources/deploymentScripts]`

This module deploys a deployment script.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Considerations](#Considerations)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Resources/deploymentScripts` | [2020-10-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-10-01/deploymentScripts) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Display name of the script to be run. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `arguments` | string | `''` |  | Command-line arguments to pass to the script. Arguments are separated by spaces. |
| `azCliVersion` | string | `''` |  | Azure CLI module version to be used. |
| `azPowerShellVersion` | string | `'3.0'` |  | Azure PowerShell module version to be used. |
| `cleanupPreference` | string | `'Always'` | `[Always, OnExpiration, OnSuccess]` | The clean up preference when the script execution gets in a terminal state. Specify the preference on when to delete the deployment script resources. The default value is Always, which means the deployment script resources are deleted despite the terminal state (Succeeded, Failed, canceled). |
| `containerGroupName` | string | `''` |  | Container group name, if not specified then the name will get auto-generated. Not specifying a 'containerGroupName' indicates the system to generate a unique name which might end up flagging an Azure Policy as non-compliant. Use 'containerGroupName' when you have an Azure Policy that expects a specific naming convention or when you want to fully control the name. 'containerGroupName' property must be between 1 and 63 characters long, must contain only lowercase letters, numbers, and dashes and it cannot start or end with a dash and consecutive dashes are not allowed. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `environmentVariables` | array | `[]` |  | The environment variables to pass over to the script. Must have a 'name' and a 'value' or a 'secretValue' property. |
| `kind` | string | `'AzurePowerShell'` | `[AzureCLI, AzurePowerShell]` | Type of the script. AzurePowerShell, AzureCLI. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `primaryScriptUri` | string | `''` |  | Uri for the external script. This is the entry point for the external script. To run an internal script, use the scriptContent instead. |
| `retentionInterval` | string | `'P1D'` |  | Interval for which the service retains the script resource after it reaches a terminal state. Resource will be deleted when this duration expires. Duration is based on ISO 8601 pattern (for example P7D means one week). |
| `runOnce` | bool | `False` |  | When set to false, script will run every time the template is deployed. When set to true, the script will only run once. |
| `scriptContent` | string | `''` |  | Script body. Max length: 32000 characters. To run an external script, use primaryScriptURI instead. |
| `supportingScriptUris` | array | `[]` |  | List of supporting files for the external script (defined in primaryScriptUri). Does not work with internal scripts (code defined in scriptContent). |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `timeout` | string | `'PT1H'` |  | Maximum allowed script execution time specified in ISO 8601 format. Default value is PT1H - 1 hour; 'PT30M' - 30 minutes; 'P5D' - 5 days; 'P1Y' 1 year. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |

**Generated parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `baseTime` | string | `[utcNow('yyyy-MM-dd-HH-mm-ss')]` | Do not provide a value! This date value is used to make sure the script run every time the template is deployed. |


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
| `name` | string | The name of the deployment script. |
| `resourceGroupName` | string | The resource group the deployment script was deployed into. |
| `resourceId` | string | The resource ID of the deployment script. |

## Considerations

This module requires a User Assigned Identity (MSI, managed service identity) to exist, and this MSI has to have contributor rights on the subscription - that allows the Deployment Script to create the required Storage Account and the Azure Container Instance.

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Cli</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module deploymentScripts './Microsoft.Resources/deploymentScripts/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-rdscli'
  params: {
    // Required parameters
    name: '<<namePrefix>>rdscli001'
    // Non-required parameters
    azCliVersion: '2.40.0'
    cleanupPreference: 'Always'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    kind: 'AzureCLI'
    retentionInterval: 'P1D'
    runOnce: false
    scriptContent: 'echo \'echo echo echo\''
    timeout: 'PT30M'
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
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
      "value": "<<namePrefix>>rdscli001"
    },
    // Non-required parameters
    "azCliVersion": {
      "value": "2.40.0"
    },
    "cleanupPreference": {
      "value": "Always"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "kind": {
      "value": "AzureCLI"
    },
    "retentionInterval": {
      "value": "P1D"
    },
    "runOnce": {
      "value": false
    },
    "scriptContent": {
      "value": "echo \"echo echo echo\""
    },
    "timeout": {
      "value": "PT30M"
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>

<h3>Example 2: Ps</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module deploymentScripts './Microsoft.Resources/deploymentScripts/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-rdsps'
  params: {
    // Required parameters
    name: '<<namePrefix>>rdsps001'
    // Non-required parameters
    azPowerShellVersion: '8.0'
    cleanupPreference: 'Always'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    kind: 'AzurePowerShell'
    lock: 'CanNotDelete'
    retentionInterval: 'P1D'
    runOnce: false
    scriptContent: 'Write-Host \'The cake is a lie!\''
    timeout: 'PT30M'
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
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
      "value": "<<namePrefix>>rdsps001"
    },
    // Non-required parameters
    "azPowerShellVersion": {
      "value": "8.0"
    },
    "cleanupPreference": {
      "value": "Always"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "kind": {
      "value": "AzurePowerShell"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "retentionInterval": {
      "value": "P1D"
    },
    "runOnce": {
      "value": false
    },
    "scriptContent": {
      "value": "Write-Host \"The cake is a lie!\""
    },
    "timeout": {
      "value": "PT30M"
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>
