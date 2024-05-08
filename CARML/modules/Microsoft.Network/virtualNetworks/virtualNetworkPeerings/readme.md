# VirtualNetworkPeering `[Microsoft.Network/virtualNetworks/virtualNetworkPeerings]`

This template deploys Virtual Network Peering.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/virtualNetworks/virtualNetworkPeerings) |

### Resource dependency

The following resources are required to be able to deploy this resource.

- Local Virtual Network (Identified by the `localVnetName` parameter).
- Remote Virtual Network (Identified by the `remoteVirtualNetworkId` parameter)

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `remoteVirtualNetworkId` | string | The Resource ID of the VNet that is this Local VNet is being peered to. Should be in the format of a Resource ID. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `localVnetName` | string | The name of the parent Virtual Network to add the peering to. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `allowForwardedTraffic` | bool | `True` | Whether the forwarded traffic from the VMs in the local virtual network will be allowed/disallowed in remote virtual network. Default is true. |
| `allowGatewayTransit` | bool | `False` | If gateway links can be used in remote virtual networking to link to this virtual network. Default is false. |
| `allowVirtualNetworkAccess` | bool | `True` | Whether the VMs in the local virtual network space would be able to access the VMs in remote virtual network space. Default is true. |
| `doNotVerifyRemoteGateways` | bool | `True` | If we need to verify the provisioning state of the remote gateway. Default is true. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `name` | string | `[format('{0}-{1}', parameters('localVnetName'), last(split(parameters('remoteVirtualNetworkId'), '/')))]` | The Name of Vnet Peering resource. If not provided, default value will be localVnetName-remoteVnetName. |
| `useRemoteGateways` | bool | `False` | If remote gateways can be used on this virtual network. If the flag is set to true, and allowGatewayTransit on remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Default is false. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the virtual network peering. |
| `resourceGroupName` | string | The resource group the virtual network peering was deployed into. |
| `resourceId` | string | The resource ID of the virtual network peering. |

## Cross-referenced modules

_None_
