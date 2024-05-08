# Network NetworkManagers ConnectivityConfigurations `[Microsoft.Network/networkManagers/connectivityConfigurations]`

This module deploys Network NetworkManagers ConnectivityConfigurations.
Connectivity configurations define hub-and-spoke or mesh topologies applied to one or more network groups.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/connectivityConfigurations` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers/connectivityConfigurations) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `appliesToGroups` | array |  | Network Groups for the configuration. |
| `connectivityTopology` | string | `[HubAndSpoke, Mesh]` | Connectivity topology type. |
| `name` | string |  | The name of the connectivity configuration. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `hubs` | array | List of hub items. This will create peerings between the specified hub and the virtual networks in the network group specified. Required if connectivityTopology is of type "HubAndSpoke". |
| `networkManagerName` | string | The name of the parent network manager. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `deleteExistingPeering` | string | `'False'` | `[False, True]` | Flag if need to remove current existing peerings. If set to "True", all peerings on virtual networks in selected network groups will be removed and replaced with the peerings defined by this configuration. Optional when connectivityTopology is of type "HubAndSpoke". |
| `description` | string | `''` |  | A description of the connectivity configuration. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `isGlobal` | string | `'False'` | `[False, True]` | Flag if global mesh is supported. By default, mesh connectivity is applied to virtual networks within the same region. If set to "True", a global mesh enables connectivity across regions. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed connectivity configuration. |
| `resourceGroupName` | string | The resource group the connectivity configuration was deployed into. |
| `resourceId` | string | The resource ID of the deployed connectivity configuration. |

## Cross-referenced modules

_None_
