# Site Config `[Microsoft.Web/sites/slots/config-authsettingsv2]`

This module deploys the auth settings v2.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/sites/slots/config` | [2022-03-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/sites) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `authSettingV2Configuration` | object |  | The auth settings V2 configuration. |
| `kind` | string | `[app, functionapp, functionapp,linux, functionapp,workflowapp, functionapp,workflowapp,linux]` | Type of slot to deploy. |
| `slotName` | string |  | Slot name to be configured. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `appName` | string | The name of the parent site resource. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |


### Parameter Usage: `authSettingV2Configuration`

The auth settings V2 configuration.

<details>

<summary>Parameter JSON format</summary>

```json
"siteConfig": {
    "value": [
        // Check out https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sites/config-authsettingsv2?tabs=bicep#siteauthsettingsv2properties for possible properties
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
siteConfig: [
    // Check out https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sites/config-authsettingsv2?tabs=bicep#siteauthsettingsv2properties for possible properties
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the slot config. |
| `resourceGroupName` | string | The resource group the slot config was deployed into. |
| `resourceId` | string | The resource ID of the slot config. |

## Cross-referenced modules

_None_
