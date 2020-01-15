
# Continuous Cloud Optimization Power BI Dashboard

## Content
- [Version 6.3 updates](README.md#version-63-updates)
- [Version 6.2 updates](README.md#version-62-updates)
- [Version 6.1 updates](README.md#version-61-updates)
- [Version 6.0 updates](README.md#version-60-updates)
- [Version 5.4 updates](README.md#version-54-updates)
- [Version 5.3 updates](README.md#version-53-updates)
- [Version 5.2 new features and updates](README.md#version-52-new-features-and-updates)
- [Overview](README.md#overview)
- [List of resources](README.md#List-of-resources)
- [CCO Dashboard report pages](README.md#CCO-Dashboard-report-Pages)
- [CCO Dashboard AKS add-on report pages](README.md#CCO-Dashboard-AKS-add-on)
- [Call for Contribution](README.md#Call-for-Contribution)
-------------------------------
## **Version 6.3** Updates
- Bug fixing ASC recommendation: Now all the Security Center Recommendations are defined in this [file](/docs/assets/SecRec.md). This file contains all the recommendations from docs.microsoft.com but will be updated by us for consolidating the model and avoid the issues when the official URL is updated.

## **Version 6.2** Updates
- Bug fixing ASC recommendation URLs updated.

## **Version 6.1** Updates
- Bug fixing ASC recommendation URLs updated.
- Bug fixing IaaS Idle Resources data number color changed from black to white.

## **Version 6.0** Updates
**Azure Resources Usage and Limits Page** ***<span style="color:green"><sup>NEW</sup></span>***
- List Compute, Networking and Storage Azure Resources Usage and limits per subscription and region

**Azure Idle Resources identification Page** ***<span style="color:green"><sup>NEW</sup></span>***
- List Idle Public IPs, Network Interfaces and Disks per Subscription
## **Version 5.4** Updates
- NSGs bug fixing when NSGs configuration are empty
- Bug fixing number of VNETs per subscription
- Bug Fixing duplicated VNET Peerings count

## **Version 5.3** Updates 
- Bug fixing issues with ASC Network Recommendations table load from docs.microsoft.com
- Incorporating icons new feature from PowerBI Desktop

## **Version 5.2:** New features and updates

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

## Overview
The Continuous Cloud Optimization Power BI Dashboard (referred as CCO Dashboard here after) is a Power BI Dashboard developed using Power Query M language that pulls information directly from different Azure and Graph REST APIs. It presents the information in a simplified format to track potential recommendations from Azure Advisor or Azure Security Center allowing you to filter by subscriptions, resources groups, tags or particular resources.

![OverviewImage](/install/images/OverviewImage.png)

## List of resources
This project includes the following resources:

1. **install folder**: Includes all the files required to successfully deploy the Dashboard in your environment. The [Deployment Guide](/install/DeploymentGuide.md) file contains a detailed guidance to install and setup your dashboard including the requirements, what REST APIs are in use, the resource providers that needs to be enabled or what tabs are included as part of the default Dashboard. The [Troubleshooting Guide](/install/TroubleshootingGuide.md) file contains guidance to solve potential issues that you might encounter during the Dashboard deployment. Errors like Power BI regional settings, or Privacy levels will be documented on this document.
2. **queries folder**: Includes the M queries used in the Dashboard to pull data from Azure and Graph REST APIs. This content is for reference purposes to facilitate the Data Model comprehension and to enable contributors to expand the Dashboard capabilities. 
3. **docs/assets/pictures folder**: Contains all the images that the Dashboard will use when loading data from Azure. The content of this folder will be dynamic and we will update the repository regularly. Make sure the computer running the Dashboard that has internet access also have access to this URL https://azure.github.io/ccodashboard/assets/pictures
4. **dashboards folder**: This parent folder contains sub folders with different versions of the CCO Dashboard depending on the workloads you want to get report from. We expect to see more versions in the future from community contributions.
    - ***CCODashboard folder*** has a more generic version of the Dashboard that includes information from Azure Advisor, Azure Security Center, Azure Networking REST APIs, Azure Compute REST APIs and Graph
    - ***CCODashboard-AKS folder*** has the add-on report to monitor Azure Kubernetes Services.

## CCO Dashboard report pages
The version 6.0 of the CCO Power BI Dashboard includes 12 report pages. You will be able to navigate, filter and report the following information:
- Page 1: Overview
- Page 2: Tags Overview
- Page 3: Azure Advisor Recommendations
- Page 4: Azure Security Center Task recommendations
- Page 5: Azure Security Center Alerts
- Page 6: Azure Compute information
- Page 7: Azure Networking information
- Page 8: Network Security Groups
- Page 9: Azure RBAC permissions
- Page 10: Azure Service Principals RBAC permissions
- Page 11: IaaS Usage and Limits
- Page 12: IaaS Idle Resources
  
You can find more details about each page on the [Deployment Guide](/install/DeploymentGuide.md) file

## CCO Dashboard AKS add-on report pages

The version 5.0 of the CCO Power BI Dashboard AKS add-on includes the following information

- Azure Kubernetes Clusters information
- Nodes, Pods, Containers status from Azure Log Analytics
- Azure Container Images (and source repositories) running on AKS Clusters ***<span style="color:green"><sup>NEW</sup></span>***
- Security recommendations to apply from Azure Security Center ***<span style="color:green"><sup>NEW</sup></span>***
- Service principals (showing assigned RBAC Roles) with cluster permissions ***<span style="color:green"><sup>NEW</sup></span>***
- Azure Container Intances information ***<span style="color:green"><sup>NEW</sup></span>***
- Improved API Rest calls ***<span style="color:green"><sup>NEW</sup></span>***

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
