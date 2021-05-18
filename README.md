
# Continuous Cloud Optimization Power BI Dashboards Project

## Content

- [Overview](README.md#overview)
- [CCO Azure Governance Dashboard Governance Version 2.2](README.md#cco-azure-governance-dashboard-report-pages) ***<span style="color:green"><sup>NEW</sup></span>***
- [CCO Azure Infrastructure Dashboard Version 8.3](README.md#cco-azure-infrastructure-dashboard-version-83) ***<span style="color:green"><sup>NEW</sup></span>***
- [List of resources](README.md#List-of-resources)
- [CCO Azure Infrastructure Dashboard report pages](README.md#cco-azure-infrastructure-dashboard-report-pages)
- [CCO Azure Infrastructure Dashboard with AKS add-on report pages](README.md#cco-azure-infrastructure-dashboard-with-aks-add-on-report-pages)
- [Call for Contribution](README.md#Call-for-Contribution)

-------------------------------

## Overview

The Continuous Cloud Optimization Power BI Dashboards project is a set of Power BI Desktop Reports developed using Power Query M language and DAX, that pulls information directly from different Azure REST APIs and enables monitoring, operation and infrastructure teams to quickly gain insights about their existing Azure Platform footprint and resources.

The current set of CCO Dashboards includes 3 different Dashboards to discover information about different Azure critical design areas:

- [**CCO Azure Infrastructure Dashboard**](/dashboards/CCODashboard-Infra/InfraDeploymentGuide.md): Get insights about Azure advisor optimizations, Azure Security Center Alerts, Networking, Compute, RBAC, Idle resources and Subscriptions Quotas and Limits
- [**CCO Azure Governance Dashboard**](/dashboards/CCODashboard-Governance/GovernanceDeploymentGuide.md): Get insights about Azure Governance aspects like Management Groups and Subscriptions hierarchy, resource tagging and naming standards, security controls, policies compliance, Regulatory Standards and Azure Blueprints
- [**CCO Azure Infrastructure Dashboard with AKS**](/dashboards/CCODashboard-Infra/InfraDeploymentGuide.md): Get insights about AKS information

**NOTE**: If your're experiencing problems during the deployment of the dashboards, please check the [Troubleshooting guide](https://github.com/Azure/ccodashboard/blob/EarlyAdopters/install/TroubleshootingGuide.md) and the [Github issues](https://github.com/Azure/ccodashboard/issues?q=is%3Aissue) before creating a new one.


![OverviewImage](/install/images/OverviewImage.png)

## Last release notes

### **CCO Azure Infrastructure Dashboard Version 8.3 Updates**

- Bug fixes: Issues [169](https://github.com/Azure/ccodashboard/issues/169), [168](https://github.com/Azure/ccodashboard/issues/168) , [166](https://github.com/Azure/ccodashboard/issues/166) and [160](https://github.com/Azure/ccodashboard/issues/160).

### **CCO Azure Governance Dashboard Version 2.2 Updates**

- Secure Score Definitions API (2020-01-01-preview) updates data model bug fix.

## List of resources

This project includes the following resources:

1. **install folder**: Includes all the files required to successfully deploy the Dashboard in your environment. The [Deployment Guide](https://github.com/Azure/ccodashboard/blob/master/dashboards/CCODashboard-Governance/GovernanceDeploymentGuide.md) file contains a detailed guidance to install and setup your dashboard including the requirements, what REST APIs are in use, the resource providers that needs to be enabled or what tabs are included as part of the default Dashboard. The [Troubleshooting Guide](/install/TroubleshootingGuide.md) file contains guidance to solve potential issues that you might encounter during the Dashboard deployment. Errors like Power BI regional settings, or Privacy levels will be documented on this document.
2. **queries folder**: Includes the M queries used in the Dashboard to pull data from Azure and Graph REST APIs. This content is for reference purposes to facilitate the Data Model comprehension and to enable contributors to expand the Dashboard capabilities.
3. **docs/assets/pictures folder**: Contains all the images that the Dashboard will use when loading data from Azure. The content of this folder will be dynamic and we will update the repository regularly. Make sure the computer running the Dashboard that has internet access also have access to this URL https://azure.github.io/ccodashboard/assets/pictures
4. **dashboards folder**: This parent folder contains sub folders with different versions of the CCO Dashboard depending on the workloads you want to get report from. We expect to see more versions in the future from community contributions.
    - ***CCODashboard-Infra folder*** has a more generic version of the Dashboard that includes information from Azure Advisor, Azure Security Center, Azure Networking REST APIs, Azure Compute REST APIs and Graph
    - ***CCODashboard-Governance folder*** has a dashboard aligned with the Microsoft Cloud Adoption Framework governance principles and will allow to get quick insights around Management Groups, Subscriptions, Blueprints, Polices, Naming Standards, Tagging and Regulatory Standards compliance. For this dashboard is needed the installation of a [custom connector](https://github.com/Azure/ccodashboard/blob/master/dashboards/CCODashboard-Governance/GovernanceDeploymentGuide.md#installing-the-custom-connector).
    - ***CCODashboard-AKS folder*** has the add-on report to monitor Azure Kubernetes Services.

## CCO Azure Governance Dashboard Report Pages

The version 2.2 of the CCO Power BI Dashboard Governance includes the following information:

- Azure Management Groups and Subscriptions hierarchy
- Resource Groups and Resources Tagging information
- Regulatory Standards Compliance Overview ***<span style="color:green"><sup>NEW</sup></span>***
- Azure Security and Compliance ***<span style="color:green"><sup>NEW</sup></span>***
- Azure Policies
- Azure Subscriptions Blueprints ***<span style="color:green"><sup>NEW</sup></span>***

You can find more details about each page on the [Deployment Guide](https://github.com/Azure/ccodashboard/blob/master/dashboards/CCODashboard-Governance/GovernanceDeploymentGuide.md) file.

## CCO Azure Infrastructure Dashboard Report Pages

The version 8.3 of the CCO Power BI Dashboard includes 10 report pages. You will be able to navigate, filter and report the following information:

- Page 1: Overview
- Page 2: Azure Advisor Recommendations
- Page 3: Azure Security Center Alerts
- Page 4: Azure Compute information
- Page 5 Azure Networking information
- Page 6: Network Security Groups
- Page 7: Azure RBAC permissions
- Page 8: Azure Service Principals RBAC permissions
- Page 9: IaaS Usage and Limits
- Page 10: IaaS Idle Resources

You can find more details about each page on the [Deployment Guide](https://github.com/Azure/ccodashboard/blob/master/dashboards/CCODashboard-Infra/InfraDeploymentGuide.md) file.

**IMPORTANT**: You must follow this [procedure](https://docs.microsoft.com/en-us/azure/lighthouse/how-to/onboard-customer) to implement Azure delegated resource management to get data from subscriptions in other tenants.

## CCO Azure Infrastructure Dashboard with AKS add-on Report Pages

The version 5.0 of the CCO Power BI Dashboard AKS add-on includes the following information:

- Azure Kubernetes Clusters information
- Nodes, Pods, Containers status from Azure Log Analytics
- Azure Container Images (and source repositories) running on AKS Clusters ***<span style="color:green"><sup>NEW</sup></span>***
- Security recommendations to apply from Azure Security Center ***<span style="color:green"><sup>NEW</sup></span>***
- Service principals (showing assigned RBAC Roles) with cluster permissions ***<span style="color:green"><sup>NEW</sup></span>***
- Azure Container Instances information ***<span style="color:green"><sup>NEW</sup></span>***
- Improved API Rest calls ***<span style="color:green"><sup>NEW</sup></span>***



## Old release notes

## CCO Azure Governance Dashboard

### CCO Azure Governance Dashboard Version 2.1 Updates

- Custom connector and Assessments metadata API Bug fixing
- Azure Policy and Azure Blueprints names changed.

### CCO Azure Governance Dashboard Version 2.0 Updates

- US Government region support <span style="color:green"><sup>NEW</sup></span>
- Alignment with Azure Security Benchmarks and Azure Security Center Secure Scores
- New Security & Compliance page <span style="color:green"><sup>NEW</sup></span>
- New Regulatory Standards Forecast page <span style="color:green"><sup>NEW</sup></span>
- Redesigned Azure Blueprints page
- New UX design with latest Azure Portal Icons <span style="color:green"><sup>NEW</sup></span>
- General Bug Fixes and code improvements

## CCO Azure Infrastructure Dashboard

### **CCO Azure Infrastructure Dashboard Version 8.2 Updates**

- Bug fix: Maps location problems in Overview, Compute and Usage&Limits resources pages fixed.
- New features:
  - Expiration date added to the SPNs. ***<span style="color:green"><sup>NEW</sup></span>***
  - Reset filters button added. ***<span style="color:green"><sup>NEW</sup></span>***

### **CCO Azure Infrastructure Dashboard Version 8.1 Updates**

- Bug fixing 1:1 relationship between Tenants and Subscriptions to M:N relationship.

### **CCO Azure Infrastructure Dashboard Version 8.1 Updates**

- Bug fixing 1:1 relationship between Tenants and Subscriptions to M:N relationship.

### **CCO Azure Infrastructure Dashboard Version 7.1** Updates

- Bug fix [Issue #72](https://github.com/Azure/ccodashboard/issues/72):
  - Subscription IDs in **All Subscriptions** table must be uniques.
  - One tenant can be managed by one or more tenants (this data now is hidden but it will be used in future releases).

### **CCO Azure Infrastructure Dashboard Version 7.0** Updates

- **Multi tenant feature** ***<span style="color:green"><sup>NEW</sup></span>*** (requires Azure delegated resource management).
  - Tenant filtering in all pages.
- Added subscription filtering in IaaS Usage and Limits and IaaS Idle Resources pages.

**IMPORTANT**: You must follow this [procedure](https://docs.microsoft.com/en-us/azure/lighthouse/how-to/onboard-customer) to implement Azure delegated resource management.

### **CCO Azure Infrastructure Dashboard Version 6.3** Updates

- Bug fixing ASC recommendation: Now all the Security Center Recommendations are defined in this [file](/docs/assets/SecRec.md). This file contains all the recommendations from docs.microsoft.com but will be updated by us for consolidating the model and avoid the issues when the official URL is updated.

### **CCO Azure Infrastructure Dashboard Version 6.2** Updates

- Bug fixing ASC recommendation URLs updated.

### **CCO Azure Infrastructure Dashboard Version 6.1** Updates

- Bug fixing ASC recommendation URLs updated.
- Bug fixing IaaS Idle Resources data number color changed from black to white.

### **CCO Azure Infrastructure Dashboard Version 6.0** Updates

**Azure Resources Usage and Limits Page** ***<span style="color:green"><sup>NEW</sup></span>***

- List Compute, Networking and Storage Azure Resources Usage and limits per subscription and region

**Azure Idle Resources identification Page** ***<span style="color:green"><sup>NEW</sup></span>***

- List Idle Public IPs, Network Interfaces and Disks per Subscription

### **CCO Azure Infrastructure Dashboard Version 5.4** Updates

- NSGs bug fixing when NSGs configuration are empty
- Bug fixing number of VNETs per subscription
- Bug Fixing duplicated VNET Peerings count

### **CCO Azure Infrastructure Dashboard Version 5.3** Updates

- Bug fixing issues with ASC Network Recommendations table load from docs.microsoft.com
- Incorporating icons new feature from PowerBI Desktop

### **CCO Azure Infrastructure Dashboard Version 5.2:** New features and updates

**Overview Page**

- New Resource Groups tags counter
- New Subscriptions, RG and Tags Search option

**Tags Overview** ***<span style="color:green"><sup>NEW</sup></span>***

- Filter Resource Groups and Resources with Tags
- Filter Resource Groups and Resources without Tags
- Number of tagged resources by resource type
- Number of untagged resources by resource type
- Search option for Resource Group and Resources tags

**Azure Advisor**

- Performance improvements and bugs fixes
- Simplified recommendations images
- Security recommendations

**Azure Security Center**

- Performance improvements and bugs fixes
- Simplified recommendations images
- Enhanced recommendation types filtering

**Security Alerts**

- Performance improvements and bugs fixes
- Simplified recommendations images

**Compute**

- Performance improvements and bugs fixes

**Networking**

- Performance improvements and bugs fixes

**NSGs** ***<span style="color:green"><sup>NEW</sup></span>***

- NSG rules overview across subscriptions (VMs and Subnets)
- Filter NSGs by subscription, Resource Group, NSG name, Tags, Direction and Ports

**RBAC**

- Performance improvements and bugs fixes
- Filtering RBAC permissions by object type (Users or Groups)
- Search option for Resource Group and users

**RBAC Service Principals** ***<span style="color:green"><sup>NEW</sup></span>***

- Filtering RBAC permissions by Service Principal Type
- Search option for Users and Resource Groups


## Call for contribution

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
