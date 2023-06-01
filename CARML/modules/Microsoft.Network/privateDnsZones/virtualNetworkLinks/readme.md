# Private DNS Zone Virtual Network Link `[Microsoft.Network/privateDnsZones/virtualNetworkLinks]`

This module deploys private dns zone virtual network links.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | [2020-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/virtualNetworkLinks) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `virtualNetworkResourceId` | string | Link to another virtual network resource ID. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `privateDnsZoneName` | string | The name of the parent Private DNS zone. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `'global'` | The location of the PrivateDNSZone. Should be global. |
| `name` | string | `[format('{0}-vnetlink', last(split(parameters('virtualNetworkResourceId'), '/')))]` | The name of the virtual network link. |
| `registrationEnabled` | bool | `False` | Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled?. |
| `tags` | object | `{object}` | Tags of the resource. |


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
| `name` | string | The name of the deployed virtual network link. |
| `resourceGroupName` | string | The resource group of the deployed virtual network link. |
| `resourceId` | string | The resource ID of the deployed virtual network link. |

## Cross-referenced modules

_None_
