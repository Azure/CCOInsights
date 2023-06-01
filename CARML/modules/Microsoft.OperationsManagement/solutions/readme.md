# OperationsManagement Solutions `[Microsoft.OperationsManagement/solutions]`

This module deploys OperationsManagement Solutions.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `logAnalyticsWorkspaceName` | string | Name of the Log Analytics workspace where the solution will be deployed/enabled. |
| `name` | string | Name of the solution. For Microsoft published gallery solution the target solution resource name will be composed as `{name}({logAnalyticsWorkspaceName})`. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |
| `product` | string | `'OMSGallery'` | The product of the deployed solution. For Microsoft published gallery solution it should be `OMSGallery` and the target solution resource product will be composed as `OMSGallery/{name}`. For third party solution, it can be anything. This is case sensitive. |
| `publisher` | string | `'Microsoft'` | The publisher name of the deployed solution. For Microsoft published gallery solution, it is `Microsoft`. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed solution. |
| `resourceGroupName` | string | The resource group where the solution is deployed. |
| `resourceId` | string | The resource ID of the deployed solution. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module solutions './Microsoft.OperationsManagement/solutions/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-omsmin'
  params: {
    // Required parameters
    logAnalyticsWorkspaceName: '<logAnalyticsWorkspaceName>'
    name: 'Updates'
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
    "logAnalyticsWorkspaceName": {
      "value": "<logAnalyticsWorkspaceName>"
    },
    "name": {
      "value": "Updates"
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

<h3>Example 2: Ms</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module solutions './Microsoft.OperationsManagement/solutions/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-omsms'
  params: {
    // Required parameters
    logAnalyticsWorkspaceName: '<logAnalyticsWorkspaceName>'
    name: 'AzureAutomation'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    product: 'OMSGallery'
    publisher: 'Microsoft'
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
    "logAnalyticsWorkspaceName": {
      "value": "<logAnalyticsWorkspaceName>"
    },
    "name": {
      "value": "AzureAutomation"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "product": {
      "value": "OMSGallery"
    },
    "publisher": {
      "value": "Microsoft"
    }
  }
}
```

</details>
<p>

<h3>Example 3: Nonms</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module solutions './Microsoft.OperationsManagement/solutions/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-omsnonms'
  params: {
    // Required parameters
    logAnalyticsWorkspaceName: '<logAnalyticsWorkspaceName>'
    name: '<<namePrefix>>omsnonms001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    product: 'nonmsTestSolutionProduct'
    publisher: 'nonmsTestSolutionPublisher'
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
    "logAnalyticsWorkspaceName": {
      "value": "<logAnalyticsWorkspaceName>"
    },
    "name": {
      "value": "<<namePrefix>>omsnonms001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "product": {
      "value": "nonmsTestSolutionProduct"
    },
    "publisher": {
      "value": "nonmsTestSolutionPublisher"
    }
  }
}
```

</details>
<p>
