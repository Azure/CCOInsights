
# Continuous Cloud Optimization Insights

- [Continuous Cloud Optimization Insights](#continuous-cloud-optimization-insights)
  - [Description](#description)
  - [Get started](#get-started)
  - [Dashboard overview](#dashboard-overview)
  - [Release notes](#release-notes)
    - [Highlights of the latest releases](#highlights-of-the-latest-releases)
      - [CCO GitHub Contributions Dashboards Version 1.0](#cco-github-contributions-dashboards-version-10)
      - [CCO ADO Contributions Dashboards Version 1.0](#cco-ado-contributions-dashboards-version-10)
      - [CCO Azure Infrastructure Dashboard Version 9.1 Updates](#cco-azure-infrastructure-dashboard-version-91-updates)
      - [CCO Azure Governance Dashboard Version 2.6 Updates](#cco-azure-governance-dashboard-version-26-updates)
  - [Contributing](#contributing)
  - [Trademarks](#trademarks)

-------------------------------
>**NOTE**:  Watch these informational [videos](https://aka.ms/ccoinsights/videos) for a detailed overview of capabilities, features and installation steps of the CCO Insights solution.


## Description

The Continuous Cloud Optimization Insights (CCO Insights) project is a set of Power BI Desktop Reports developed using Power Query M language and DAX that pulls information directly from different Azure REST APIs and enables monitoring, operation and infrastructure teams to quickly gain insights about their existing Azure Platform footprint and resources as well as code contribution characteristics on two major platforms - Azure DevOps and GitHub.

## Get started

* For introduction and guidance visit the [Wiki](https://github.com/azure/CCOInsights/wiki).
* For information on contributing, see [Contribution](<https://github.com/Azure/CCOInsights/wiki/Contribution%20guide>).
* File an issue via [GitHub Issues](https://github.com/azure/CCOInsights/issues/new/choose).
* For a high level overview of the dashboards provided by this solution see [Dashboard overview](#dashboard-overview) section below.

## Dashboard overview

CCO Insights currently includes 5 different dashboards to discover information about your Azure, Azure DevOps and GitHub cloud platforms:

- [**CCO Azure Infrastructure Dashboard**](./dashboards/CCODashboard-Infra/InfraDeploymentGuide.md): Get insights about Azure advisor optimizations, Azure Security Center Alerts, Networking, Compute, RBAC, Idle resources and Subscriptions Quotas and Limits
- [**CCO Azure Governance Dashboard**](./dashboards/CCODashboard-Governance/GovernanceDeploymentGuide.md): Get insights about Azure Governance aspects like Management Groups and Subscriptions hierarchy, resource tagging and naming standards, security controls, policies compliance, Regulatory Standards and Azure Blueprints
- [**CCO Azure Infrastructure Dashboard with AKS (not maintained)**](./dashboards/CCODashboard-Infra/InfraDeploymentGuide.md): Get insights about AKS information
- [**CCO GitHub Contributions Dashboard**](./dashboards/GitHubDashboard-Contributors/GitHubDeploymentGuide.md): Get insights about the contributions to your GitHub project.
- [**CCO Azure DevOps Contributions Dashboard**](./dashboards/ADODashboard-Contributors/ADODeploymentGuide.md): Get insights about the contributions to your Azure DevOps (ADO) project.



>**NOTE**: If you're experiencing problems during the deployment of the dashboards, please check the [Troubleshooting guide](./install/TroubleshootingGuide.md) and the [Github issues](https://github.com/Azure/CCOInsights/issues?q=is%3Aissue) before creating a new one.


![OverviewImage](./install/images/OverviewImage.png)

## Release notes

For the comprehensive list of release notes, see the [Release notes](./Release-Notes.md) page.

### Highlights of the latest releases

#### CCO GitHub Contributions Dashboards Version 1.0

- Initial release of the CCO GitHub Contributions Dashboard

#### CCO ADO Contributions Dashboards Version 1.0

- Initial release of the CCO ADO Contributions Dashboard

#### CCO Azure Infrastructure Dashboard Version 9.1 Updates

- New report page available for Azure Web Applications.
- Management Group filtering
- **IMPORTANT**: Now it requires the Custom connector (mandatory to retrieve the MGs)

#### CCO Azure Governance Dashboard Version 2.6 Updates

- Governance dashboard policies visuals fix

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

For specific guidelines on how to contribute to this repository please refer to the [Contribution guide](https://github.com/Azure/ResourceModules/wiki/Contribution%20guide) Wiki section.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.