# Continuous Cloud Optimization Insights (CCO Insights)

The Continuous Cloud Optimization Insights (CCO Insights) project is a set of Power BI Desktop Reports developed using Power Query M language and DAX, that pulls information directly from different Azure REST APIs and enables monitoring, operation and infrastructure teams to quickly gain insights about their existing Azure Platform footprint and resources as well as code contribution characteristics on two major platforms - Azure DevOps and GitHub.

![OverviewImage](./media/OverviewImage.png)

CCO Insights currently includes 5 different dashboards to discover information about your Azure, Azure DevOps and GitHub cloud platforms:

- [**CCO Azure Infrastructure Dashboard**](./dashboards/CCODashboard-Infra/InfraDeploymentGuide.md): Get insights about Azure advisor optimizations, Azure Security Center Alerts, Networking, Compute, RBAC, Idle resources and Subscriptions Quotas and Limits
- [**CCO Azure Governance Dashboard**](./dashboards/CCODashboard-Governance/GovernanceDeploymentGuide.md): Get insights about Azure Governance aspects like Management Groups and Subscriptions hierarchy, resource tagging and naming standards, security controls, policies compliance, Regulatory Standards and Azure Blueprints
- [**CCO Azure Infrastructure Dashboard with AKS (not maintained)**](./dashboards/CCODashboard-Infra/InfraDeploymentGuide.md): Get insights about AKS information
- [**CCO GitHub Contributions Dashboard**](./dashboards/GitHubDashboard-Contributors/GitHubDeploymentGuide.md): Get insights about the contributions to your GitHub project.
- [**CCO Azure DevOps Contributions Dashboard**](./dashboards/ADODashboard-Contributors/ADODeploymentGuide.md): Get insights about the contributions to your Azure DevOps (ADO) project.


### _Navigation_

- Home
  - [Continuous Cloud Optimization Insights (CCO Insights)](#continuous-cloud-optimization-insights-cco-insights)
      - [_Navigation_](#navigation)
  - [List of resources](#list-of-resources)
  - [Overview of dashboards](#overview-of-dashboards)
    - [CCO Azure Governance Dashboard Report Pages](#cco-azure-governance-dashboard-report-pages)
    - [CCO Azure Infrastructure Dashboard Report Pages](#cco-azure-infrastructure-dashboard-report-pages)
    - [CCO GitHub Contributions Dashboard](#cco-github-contributions-dashboard)
    - [CCO ADO Contributions Dashboard](#cco-ado-contributions-dashboard)
    - [CCO Azure Infrastructure Dashboard with AKS add-on Report Pages (not maintained)](#cco-azure-infrastructure-dashboard-with-aks-add-on-report-pages-not-maintained)
  - [Reporting Issues](#reporting-issues)
    - [Bugs](#bugs)
    - [Feature requests](#feature-requests)
  - [Call for contribution](#call-for-contribution)
  - [Trademarks](#trademarks)
  - [Learn More](#learn-more)
- Deployment Guides
  - [Deployment Guide - ADO Dashboard](./Deployment%20Guide%20-%20ADO%20Dashboard)
  - [Deployment Guide - GitHub Dashboard](./Deployment%20Guide%20-%20GitHub%20Dashboard)
  - [Deployment Guide - Governance Dashboard](./Deployment%20Guide%20-%20Governance%20Dashboard)
  - [Deployment Guide - Infrastructure Dashboard](./Deployment%20Guide%20-%20Infrastructure-Dashboard)

---

# List of resources

This project includes the following resources:

1. **install folder**: Includes all the files required to successfully deploy the Dashboard in your environment. The [Deployment Guide](./dashboards/CCODashboard-Governance/GovernanceDeploymentGuide.md) file contains a detailed guidance to install and setup your dashboard including the requirements, what REST APIs are in use, the resource providers that needs to be enabled or what tabs are included as part of the default Dashboard. The [Troubleshooting Guide](./Troubleshooting%20Guide) file contains guidance to solve potential issues that you might encounter during the Dashboard deployment. Errors like Power BI regional settings, or Privacy levels will be documented on this document.
2. **queries folder**: Includes the M queries used in the Dashboard to pull data from Azure and Graph REST APIs. This content is for reference purposes to facilitate the Data Model comprehension and to enable contributors to expand the Dashboard capabilities.
3. **docs/assets/pictures folder**: Contains all the images that the Dashboard will use when loading data from Azure. The content of this folder will be dynamic and we will update the repository regularly. Make sure the computer running the Dashboard that has internet access also have access to this URL https://azure.github.io/ccodashboard/assets/pictures
4. **dashboards folder**: This parent folder contains sub folders with different versions of the dashboards of CCO Insights depending on the workloads you want to get report from. We expect to see more versions in the future from community contributions.
    - ***CCODashboard-Infra folder*** has a more generic version of the Dashboard that includes information from Azure Advisor, Azure Security Center, Azure Networking REST APIs, Azure Compute REST APIs and Graph
    - ***CCODashboard-Governance folder*** has a dashboard aligned with the Microsoft Cloud Adoption Framework governance principles and will allow to get quick insights around Management Groups, Subscriptions, Blueprints, Polices, Naming Standards, Tagging and Regulatory Standards compliance. For this dashboard is needed the installation of a [custom connector](./Deployment%20Guide%20-%20Governance%20Dashboard#installing-the-custom-connector).
    - ***CCODashboard-AKS folder*** has the add-on report to monitor Azure Kubernetes Services.



# Reporting Issues

>**NOTE**: If you're experiencing problems during the deployment of the dashboards, please check the [Troubleshooting guide](./install/TroubleshootingGuide.md) and the [Github issues](https://github.com/Azure/CCOInsights/issues?q=is%3Aissue) before creating a new one.


## Bugs

If you find any bugs, please file an issue on the [GitHub Issues][GitHubIssues] page by filling out the provided template with the appropriate information.

> Please search the existing issues before filing new issues to avoid duplicates.

If you are taking the time to mention a problem, even a seemingly minor one, it is greatly appreciated, and a totally valid contribution to this project. **Thank you!**

## Feature requests

If there is a feature you would like to see in here, please file an issue or feature request on the [GitHub Issues][GitHubIssues] page to provide direct feedback.

---

# Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.

---

# Learn More

// **ADD LINKS TO LEARN ABOUT POWERBI, AND ALL OTHER RELEVANT TECHNOLOGY PIECES!!!**

- [PowerShell Documentation][PowerShellDocs]
- [Microsoft Azure Documentation][MicrosoftAzureDocs]
- [Azure Resource Manager][AzureResourceManager]
- [Bicep][Bicep]
- [GitHubDocs][GitHubDocs]

<!-- References -->

<!-- Local -->
[GitHubDocs]: <https://docs.github.com/>
[GitHubIssues]: <https://github.com/Azure/Modules/issues>
[AzureResourceManager]: <https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview>
[Bicep]: <https://github.com/Azure/bicep>

<!-- Docs -->
[MicrosoftAzureDocs]: <https://docs.microsoft.com/en-us/azure/>
[PowerShellDocs]: <https://docs.microsoft.com/en-us/powershell/>
