# Release Notes

- [Release Notes](#release-notes)
  - [CCO Azure Governance Dashboard](#cco-azure-governance-dashboard)
    - [CCO Azure Governance Dashboard Version 2.6 Updates](#cco-azure-governance-dashboard-version-26-updates)
    - [CCO Azure Governance Dashboard Version 2.1](#cco-azure-governance-dashboard-version-21)
    - [CCO Azure Governance Dashboard Version 2.0](#cco-azure-governance-dashboard-version-20)
  - [CCO Azure Infrastructure Dashboard](#cco-azure-infrastructure-dashboard)
    - [CCO Azure Infrastructure Dashboard Version 9.1](#cco-azure-infrastructure-dashboard-version-91)
    - [CCO Azure Infrastructure Dashboard Version 8.2](#cco-azure-infrastructure-dashboard-version-82)
    - [CCO Azure Infrastructure Dashboard Version 8.1](#cco-azure-infrastructure-dashboard-version-81)
    - [CCO Azure Infrastructure Dashboard Version 7.1](#cco-azure-infrastructure-dashboard-version-71)
    - [CCO Azure Infrastructure Dashboard Version 7.0](#cco-azure-infrastructure-dashboard-version-70)
    - [CCO Azure Infrastructure Dashboard Version 6.3](#cco-azure-infrastructure-dashboard-version-63)
    - [CCO Azure Infrastructure Dashboard Version 6.2](#cco-azure-infrastructure-dashboard-version-62)
    - [CCO Azure Infrastructure Dashboard Version 6.1](#cco-azure-infrastructure-dashboard-version-61)
    - [CCO Azure Infrastructure Dashboard Version 6.0](#cco-azure-infrastructure-dashboard-version-60)
    - [CCO Azure Infrastructure Dashboard Version 5.4](#cco-azure-infrastructure-dashboard-version-54)
    - [CCO Azure Infrastructure Dashboard Version 5.3](#cco-azure-infrastructure-dashboard-version-53)
    - [CCO Azure Infrastructure Dashboard Version 5.2](#cco-azure-infrastructure-dashboard-version-52)
      - [Overview Page](#overview-page)
      - [Tags Overview](#tags-overview)
      - [Azure Advisor](#azure-advisor)
      - [Azure Security Center](#azure-security-center)
      - [Security Alerts](#security-alerts)
      - [Compute](#compute)
      - [Networking](#networking)
      - [NSGs](#nsgs)
      - [RBAC](#rbac)
      - [RBAC Service Principals](#rbac-service-principals)
  - [CCO ADO Contributions Dashboard](#cco-ado-contributions-dashboard)
    - [CCO ADO Contributions Dashboard Version 1.0](#cco-ado-contributions-dashboard-version-10)
  - [CCO GitHub Contributions Dashboard](#cco-github-contributions-dashboard)
    - [CCO GitHub Contributions Dashboard Version 1.0](#cco-github-contributions-dashboard-version-10)

## CCO Azure Governance Dashboard

### CCO Azure Governance Dashboard Version 2.6 Updates

- Governance dashboard policies visuals fix

### CCO Azure Governance Dashboard Version 2.1

- Custom connector and Assessments metadata API Bug fixing
- Azure Policy and Azure Blueprints names changed.

### CCO Azure Governance Dashboard Version 2.0

- US Government region support 
- Alignment with Azure Security Benchmarks and Azure Security Center Secure Scores
- New Security & Compliance page 
- New Regulatory Standards Forecast page 
- Redesigned Azure Blueprints page
- New UX design with latest Azure Portal Icons 
- General Bug Fixes and code improvements

## CCO Azure Infrastructure Dashboard

### CCO Azure Infrastructure Dashboard Version 9.1

- New report page available for Azure Web Applications.
- Management Group filtering
- IMPORTANT: Now it requires the Custom connector (mandatory to retrieve the MGs)

### CCO Azure Infrastructure Dashboard Version 8.2

- Bug fix: Maps location problems in Overview, Compute and Usage&Limits resources pages fixed.
- New features:
  - Expiration date added to the SPNs. 
  - Reset filters button added. 

### CCO Azure Infrastructure Dashboard Version 8.1

- Bug fixing 1:1 relationship between Tenants and Subscriptions to M:N relationship.

### CCO Azure Infrastructure Dashboard Version 7.1

- Bug fix [Issue #72](https://github.com/Azure/CCOInsights/issues/72):
  - Subscription IDs in All Subscriptions table must be uniques.
  - One tenant can be managed by one or more tenants (this data now is hidden but it will be used in future releases).

### CCO Azure Infrastructure Dashboard Version 7.0

- Multi tenant feature  (requires Azure delegated resource management).
  - Tenant filtering in all pages.
- Added subscription filtering in IaaS Usage and Limits and IaaS Idle Resources pages.

IMPORTANT: You must follow this [procedure](https://docs.microsoft.com/en-us/azure/lighthouse/how-to/onboard-customer) to implement Azure delegated resource management.

### CCO Azure Infrastructure Dashboard Version 6.3

- Bug fixing ASC recommendation: Now all the Security Center Recommendations are defined in this [file](./docs/assets/SecRec.md). This file contains all the recommendations from docs.microsoft.com but will be updated by us for consolidating the model and avoid the issues when the official URL is updated.

### CCO Azure Infrastructure Dashboard Version 6.2

- Bug fixing ASC recommendation URLs updated.

### CCO Azure Infrastructure Dashboard Version 6.1

- Bug fixing ASC recommendation URLs updated.
- Bug fixing IaaS Idle Resources data number color changed from black to white.

### CCO Azure Infrastructure Dashboard Version 6.0

Azure Resources Usage and Limits Page 

- List Compute, Networking and Storage Azure Resources Usage and limits per subscription and region

Azure Idle Resources identification Page 

- List Idle Public IPs, Network Interfaces and Disks per Subscription

### CCO Azure Infrastructure Dashboard Version 5.4

- NSGs bug fixing when NSGs configuration are empty
- Bug fixing number of VNETs per subscription
- Bug Fixing duplicated VNET Peerings count

### CCO Azure Infrastructure Dashboard Version 5.3

- Bug fixing issues with ASC Network Recommendations table load from docs.microsoft.com
- Incorporating icons new feature from PowerBI Desktop

### CCO Azure Infrastructure Dashboard Version 5.2

#### Overview Page

- New Resource Groups tags counter
- New Subscriptions, RG and Tags Search option

#### Tags Overview 

- Filter Resource Groups and Resources with Tags
- Filter Resource Groups and Resources without Tags
- Number of tagged resources by resource type
- Number of untagged resources by resource type
- Search option for Resource Group and Resources tags

#### Azure Advisor

- Performance improvements and bugs fixes
- Simplified recommendations images
- Security recommendations

#### Azure Security Center

- Performance improvements and bugs fixes
- Simplified recommendations images
- Enhanced recommendation types filtering

#### Security Alerts

- Performance improvements and bugs fixes
- Simplified recommendations images

#### Compute

- Performance improvements and bugs fixes

#### Networking

- Performance improvements and bugs fixes

#### NSGs 

- NSG rules overview across subscriptions (VMs and Subnets)
- Filter NSGs by subscription, Resource Group, NSG name, Tags, Direction and Ports

#### RBAC

- Performance improvements and bugs fixes
- Filtering RBAC permissions by object type (Users or Groups)
- Search option for Resource Group and users

#### RBAC Service Principals 

- Filtering RBAC permissions by Service Principal Type
- Search option for Users and Resource Groups

## CCO ADO Contributions Dashboard

### CCO ADO Contributions Dashboard Version 1.0

The version 1.0 of the CCO ADO Contributions Dashboard includes 1 report page. You will be able to navigate, filter and report the following information:
- Number of Projects
- Number of open/closed pull requests
- Average pull requests per day
- Comparison between number of open vs closed pull requests over the last months
- Branches created over the last months

## CCO GitHub Contributions Dashboard

### CCO GitHub Contributions Dashboard Version 1.0

The version 1.0 of the CCO GitHub Contributions Dashboard includes 1 report page. You will be able to navigate, filter and report the following information:
- Number of contributors
- Total number of pull requests
- Number of watchers
- Number of stars
- Number of forks
- Number of clones
- Number of open pull requests
- Average pull requests per day
- Pull requests' lifecycle (in days)
- Comparison between number of open vs closed pull requests over the last months.
- Comparison between number of additions vs deletions per month
- Top contributors measured by changes in their pull requests.