### _Navigation_

- [Azure Infrastructure Dashboard - Report Pages](#azure-infrastructure-dashboard---report-pages)
  - [CCO Azure Infrastructure Dashboard overview page](#cco-azure-infrastructure-dashboard-overview-page)
  - [Azure Advisor Recommendations page](#azure-advisor-recommendations-page)
  - [Azure Defender Alerts page](#azure-defender-alerts-page)
  - [Azure Compute Overview page](#azure-compute-overview-page)
  - [Azure VNETs and Subnets Recommendations page](#azure-vnets-and-subnets-recommendations-page)
  - [Azure Network Security Groups page](#azure-network-security-groups-page)
  - [Azure App Services page](#azure-app-services-page)
  - [Role Based Access Control page](#role-based-access-control-page)
  - [Service Principal Role Based Access Control page](#service-principal-role-based-access-control-page)
  - [IaaS Usage and Limits page](#iaas-usage-and-limits-page)
  - [IaaS Idle Resources Dashboard page](#iaas-idle-resources-dashboard-page)
  - [Azure Kubernetes Service Dashboard Overview page](#azure-kubernetes-service-dashboard-overview-page)
  - [Azure Kubernetes Service page](#azure-kubernetes-service-page)

---

<br>

# Azure Infrastructure Dashboard - Report Pages

## CCO Azure Infrastructure Dashboard overview page

In this page, you will be able to identify the top 10 of recommendations that Azure Advisor has identified, the top 10 most attacked resources and the number of subscription owners. You can also locate all the deployed resources in a map.
It’s important to mention that this tab just gives you a quick view. All the recommendations will be available with more details in the following tabs

You can filter the information by:

- Tenant
- Subscription
- Resource Tags

![overview][Overview]

## Azure Advisor Recommendations page

In this page of the report, you will be able to identify the total amount of recommendations that Azure Advisor has identified, to what resources each recommendations apply and to what subscription as well.

You can filter the information by:

- Tenant
- Subscription
- Resource type

It will also give a high-level overview of what subscriptions require more attention and has more recommendations to snooze or implement.

If you navigate to a impacted resource you will see a quick description, potential solution and in some cases a link to a website where you can find all the steps to solve the problem.

![advisor][Advisor]


## Azure Defender Alerts page

The third tab is used to show the Azure Defender Advanced Threat Analytics Alerts from all the subscriptions a given Azure account has access to. Is important to remark that subscriptions will need to use the Standard plan if you want to detect and see the alerts in the Power BI Dashboard.


You can filter the information by:

- Tenant
- Subscription
- Attack type
- Data range

![security Center alerts][SecurityCenterAlerts]

## Azure Compute Overview page

In this tab, you will be able to identify the number of VMs, the Operating System, the SKU, the Availability Set name, the location, the VM Size, the VNET and subnet each VM is connected, the private IP address and if the VM has any extension installed.

You can filter the information by:

- Tenant
- Subscription
- Resource Group
- VM extension

![azure compute][IMG_AzureCompute]

## Azure VNETs and Subnets Recommendations page

In this tab, you will be able to identify VNETs with only one subnet, if there are any VNET peering and if some of the subnets is exhausting its IP Pool.

You can filter the information by:

- Tenant
- Subscription
- Resource Group
- VNET
- Subnet
- Networking Interface

![azure networking][AzureNetworking]

**IMPORTANT**: It is important to mention that although a VNET with only one subnet might not be an issue, it might be a good lead to investigate if that is the best network segmentation for the applications running on it.

## Azure Network Security Groups page

In this tab, you will be able to identify all the NSGs assigned to a VM or Subnet. On each one, you can check all the rules that are being applied

You can filter the information by:

- Tenant
- Subscription
- VM
- VNET
- Subnet
- NSG assignment


![azure NSGs][AzureNSGs]
## Azure App Services page

In this tab, you will be able to identify all the Application Services. On each one, you can check all the identities types, SKU and inbound and outbound IPs

You can filter the information by:

- Tenant
- Subscription
- Tags


![azure Apps][AppServices]


## Role Based Access Control page

This tab is used to show the Azure RBAC permissions from all the subscriptions a given Azure account has access to. You will be able to identify the roles applied to all Azure resources and if the subscriptions have custom roles.

You can filter the information by:

- Tenant
- Subscription
- Object type
- User

![azure rbac][AzureRbac]

## Service Principal Role Based Access Control page

This tab is used to show Azure Services Principals RBAC permissions from all the subscriptions a given Azure account has access to. You will be able to identify the roles applied to all Azure resources and if the subscriptions have custom roles.

You can filter the information by:

- Tenant
- Subscription
- Object type
- User

![azure rbacSP][AzureRbacSP]

## IaaS Usage and Limits page

This tab allows to identify the usage of any Compute, Storage and Networking Azure resource and validate the limits for each region and subscription.

You can filter the information by:

- Tenant
- Subscription
- Azure Region

![usage and limits][UsageAndLimits]

## IaaS Idle Resources Dashboard page

This tab is lists all the Public IPs, Network Interfaces and Disks that are disconnected, idle or unattached.

You can filter the information by:

- Tenant
- Subscription

![azure Idle][IdleResources]


<details>
<summary>
     Expand this section if you want to see the Azure Kubernetes Service Dashboard information (this dashboard is currently not maintained).
</summary>

## Azure Kubernetes Service Dashboard Overview page

In this page, you will be able to identify the number of AKS Clusters, Nodes, Pods, Containers, Service Principals and Azure Security Center recommendations. It’s important to mention that this tab just gives you a quick view. All the detailed information will be available in the following tab.

You can filter the information by:

- Subscription
- AKS Cluster

![aks][Aks1]

**IMPORTANT**: to receive all the information related to the Pods, Containers and Container Images a log analytics workspace configured **is required**.

## Azure Kubernetes Service page

In this page, you will be able to identify the number of AKS Clusters, Nodes, Pods, Containers, Container images, Service principals and Azure Container Instances . All the information related to these resources will be shown (IPs, pods in use, status, network, image repositories, RBAC roles …).

You can filter the information by:

- Subscription
- AKS Cluster
- Namespace
- Cluster Node

**IMPORTANT**: to receive all the information related to the Pods, Containers and Container Images a log analytics workspace configured **is required**.

![aks][Aks2]

 </details>




<!-- Docs -->

<!-- Images -->
[Overview]: <./media/OverviewImage.png>
[Advisor]: <./media/Advisor.png>
[SecurityCenterAlerts]: <./media/SecurityCenterAlerts.png>
[IMG_AzureCompute]: <./media/AzureCompute.png>
[AzureNetworking]: <./media/AzureNetworking.png>
[AzureNSGs]: <./media/NSGs.png>
[AzureRbac]: <./media/RBAC.png>
[AzureRbacSP]: <./media/RBACServicePrincipals.png>
[UsageAndLimits]: <./media/UsageAndLimits.png>
[IdleResources]: <./media/IdleResources.png>
[AppServices]: <./media/AppServices.png>
[Aks1]: <./media/aks.PNG>
[Aks2]: <./media/aks2.png>

<!-- References -->