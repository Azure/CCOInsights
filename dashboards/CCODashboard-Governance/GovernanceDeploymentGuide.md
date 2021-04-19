# CCO Azure Governance Dashboard

<div style="text-align: justify">

- [CCO Azure Governance Dashboard](#cco-azure-governance-dashboard)
  - [Overview](#overview)
    - [Requirements](#requirements)
  - [APIs in use](#apis-in-use)
  - [Resource Providers requirements](#resource-providers-requirements)
- [Installing the custom connector](#installing-the-custom-connector)
- [Setting up the CCO Azure Governance Dashboard Governance](#setting-up-the-cco-azure-governance-dashboard-governance)
  - [Template download](#template-download)
  - [Environment selection](#environment-selection)
  - [Modify Privacy settings](#modify-privacy-settings)
  - [Credentials](#credentials)
    - [Clean Credentials on the Data Source](#clean-credentials-on-the-data-source)
    - [Refresh the dashboard](#refresh-the-dashboard)
    - [Credentials for management.azure.com</span> REST API request](#credentials-for-managementazurecomspan-rest-api-request)
    - [Credentials for CCO Dashboard Custom Connector](#credentials-for-cco-dashboard-custom-connector)
- [Report Pages](#report-pages)
  - [Management Groups and Subscriptions Hierarchy Overview page](#management-groups-and-subscriptions-hierarchy-overview-page)
  - [Tags and naming standards page](#tags-and-naming-standards-page)
  - [Azure Regulatory Standards Forecast](#azure-regulatory-standards-forecast)
  - [Azure Resources Security & Compliance page](#azure-resources-security--compliance-page)
  - [Azure Policies page](#azure-policies-page)
  - [Azure Blueprints page](#azure-blueprints-page)

## Overview

The CCO Azure Governance Dashboard is aligned with the Microsoft Cloud Adoption Framework governance principles and will allow to get quick insights around Management Groups, Subscriptions, Blueprints, Polices, Naming Standards, Tagging and Regulatory Standards compliance. The information captured on this Power BI Dashboard can help Cloud Teams, Operations Teams or business decision makers to have a snapshot of the current Azure configuration in just few minutes.

### Requirements

- The CCO Azure Governance Dashboard is a Power BI Template that requires to download and install the Microsoft Power BI Desktop Edition from the Microsoft Store. Below you can find the minimum requirements to run the Dashboard
  - Windows 10 version **14393.0** or **higher**.
  - Internet access from the computer running Microsoft Power BI desktop.
  - An Azure account on the desired tenant space with permissions on the subscriptions to read from the Azure Services described above.
  - Install the custom connector and allow the use of any extension to load data without validation or warning.

## APIs in use

<div style="text-align: justify">The CCO Azure Governance Dashboard Governance pulls the information from several APIs. You can read the public documentation if you need further information about the calls and methods available:
<br><br>
</div>

| API Name| Dashboard API Version | Last API version | Using latest version|
| --- | :---: | :---: |:---: |
| [Resource Groups](https://docs.microsoft.com/en-us/rest/api/resources/resourcegroups)  |2019-05-01 |2019-05-01|:heavy_check_mark:|
| [Azure Resources](https://docs.microsoft.com/en-us/rest/api/resources/resources)  |2019-05-01 |2019-05-01|:heavy_check_mark:|
| [Azure Subscriptions](https://docs.microsoft.com/en-us/rest/api/resources/subscriptions)  |2020-01-01 |2020-01-01|:heavy_check_mark:|
| [Azure Locations](https://docs.microsoft.com/en-us/rest/api/resources/subscriptions/listlocations)  |2019-05-01 |2019-05-01|:heavy_check_mark:|
| [Azure Blueprints](https://docs.microsoft.com/en-us/rest/api/resources/subscriptions/listlocations)  |2018-11-01-preview |2018-11-01-preview|:heavy_check_mark:|
| [Azure Policies](https://docs.microsoft.com/en-us/rest/api/resources/subscriptions/listlocations)  |2019-09-01 |2019-09-01|:heavy_check_mark:|
| [Azure Regulatory Compliances](https://docs.microsoft.com/en-us/rest/api/securitycenter/regulatorycompliancestandards)  |2019-01-01-preview |2019-01-01-preview|:heavy_check_mark:|
| [Azure Assessments](https://docs.microsoft.com/en-us/rest/api/resources/subscriptions/listlocations)  |2020-01-01 |2020-01-01|:heavy_check_mark:|
| [Azure Secure Scores](https://docs.microsoft.com/en-us/rest/api/securitycenter/securescores) |2020-01-01 |2020-01-01|:heavy_check_mark:|
| [Azure Secure Scores Controls](https://docs.microsoft.com/en-us/rest/api/securitycenter/securescorecontrols) |2020-01-01-preview |2020-01-01-preview|:heavy_check_mark:|

<div style="text-align: justify">

API URLs by environment:

| API Name| API URL | Environment|
|--- |--- |--- |
| Management |https://management.azure.com/|Global|
| Management |https://management.usgovcloudapi.net/|US Government|
| Management |https://management.chinacloudapi.cn/|China|

## Resource Providers requirements

Although some of the Resource Providers might be enabled by default, you need to make sure that at least the **Microsoft.Security** resource provider is registered across all the  subscriptions that you plan analyze using the Dashboard. 

Registering this Resource Provider has no cost or performance penalty on the subscription:

1. Click on **Subscriptions**.
2. Click on the Subscription name you want to configure.
3. Click on **Resource Providers**.
4. Click on **Microsoft.Security** and **Register**.

# Installing the custom connector

The CCO Azure Governance Dashboard requires to install the Power BI Custom Connector located in the same folder as the CCO Governance Dashboard ([CCoDashboardAzureConnector.mez](/dashboards/CCODashboard-Governance/CcoDashboardAzureConnector.mez)). This Custom Connector allows us to leverage information from Azure Management REST APIs that requires POST methods and errors control

To install the custom connector you must copy the file [CCoDashboardAzureConnector.mez](/dashboards/CCODashboard-Governance/CcoDashboardAzureConnector.mez) from the **ccodashboard/dashboards/CCODashboard-Governance/** folder to the folder that Power BI creates by default in the Documents folder in your PC. If this folder doesn't exist, you can create a new one with this name.

The path should be **C:\Users\\%username%\Documents\Power BI Desktop\Custom Connectors** or if you are using onedrive to backup the documents folder this path would not work for you and you should manualy go to your documents folder and create the folder structure there. 

![cc](/install/images/customconnectorfolder.PNG)

Then go to Power BI Options and under Global category in the Security section, select **(Not Recommended) Allow any extension to load without validation or warning** and click **OK**.

![cc](/install/images/customconnectorsecurity.PNG)

# Setting up the CCO Azure Governance Dashboard Governance

## Template download
Make sure to download and open the `.pbit` file from  https://github.com/Azure/ccodashboard/tree/master/dashboards/CCODashboard-Governance

## Environment selection

Before start loading data you need to select which type of environment you're using:

- Select "Global" for Microsoft Azure commercial environments. This is the default selection.
- Select [US-Government](https://docs.microsoft.com/en-us/azure/azure-government/documentation-government-developer-guide) for Azure Us government services. Azure Government is a separate instance of the Microsoft Azure service. It addresses the security and compliance needs of United States federal agencies, state and local governments, and their solution providers.

![selector](/install/images/selectorGov.PNG)

## Modify Privacy settings

- Go to File -> Options -> Privacy and set to Always ignore privacy level settings.

![Privacy](https://user-images.githubusercontent.com/39730064/60920947-3e6d2580-a24e-11e9-9042-f799c9f6fc53.png)

## Credentials

By default, the template doesn't have any Azure Account credentials preloaded. Hence, the first step to start loading subscriptions data is to sign-in with the right user credentials.

**IMPORTANT NOTE**: Power BI Desktop caches the credentials after the first logon. It is important to clear the credentials from Power BI desktop if you plan to switch between Azure GLobal and any other region like US Government or China. The same concept applies if you plan to switch between tenants. Otherwise, the staged credentials will be used again for the different Azure environments and the authentication or data load process will fail.

### Clean Credentials on the Data Source

In some cases, old credentials are cached by previous logins using Power BI Desktop and the dashboard might show errors or blank fields.

- Click on Data sources in **Current file/Global permissions**
- Click on **Clear Permissions**.
- Click on **Clear All Permissions**.

![credentials1](/install/images/Credentials1.png) ![credentials2](/install/images/Credentials2.png)

### Refresh the dashboard

If the permissions and credentials are properly flushed it should ask you for credentials for each REST API and you will have to set the Privacy Levels for each of them.

- Click on **Refresh**.
  
![refreshgovernance](/install/images/refreshgovernance1.png)

### Credentials for management.azure.com</span> REST API request

- Click on **Organizational Account**.
- Click on **Sign in**.
- Click on **Connect**.

![credentials4](/install/images/Credentials4.png)

### Credentials for CCO Dashboard Custom Connector

- Click on **Organizational Account**.
- Click on **Sign in**.
- Click on **Connect**.

![cc](/install/images/customconnector.PNG)


# Report Pages

## Management Groups and Subscriptions Hierarchy Overview page

In this page, you will be able to identify easily the hierarchy within your environment with the view of the Management Groups and Subscriptions.
It's important to mention that this page just gives you a quick view.

![overview](/install/images/GovernanceOverview.png)

## Tags and naming standards page

In this page you will be able to sort and filter all your Resources and Resource groups based on Tags. It will help you identify any missing Tag and if your naming standards and Tags classifications adheres to your organization guidelines or policies.

You can filter the information by:

- Management Group with subscriptions
- Subscription

![Tagsoverview](/install/images/TagsOverview.png)

## Azure Regulatory Standards Forecast

In this page you can compare your current Azure resources compliance against selected Regulatory Standards, to understand how far from a given Regulatory Standard your current Azure footprint is today. For more information check the published [Regulatory Standards](https://docs.microsoft.com/en-us/azure/governance/blueprints/samples/).

You can filter the information by:

- Subscription
- Regulatory Compliance
- Assessment Category

![regulatorycompliance](/install/images/regulatorycompliance.png)

## Azure Resources Security & Compliance page

In this page you can check the compliance status of your Azure resources based on the Azure Security Center Secure Score Controls and the corresponding Policy Set or Regulatory Standard.

You can filter the information by:

- Subscription
- Policy Set
- Regulatory Standard Name
- Secure Controls
- Policy Category
  
![regulatorycomplianceresources](/install/images/regulatorycomplianceresources.png)

## Azure Policies page

In this page of the report, you will be able to identify the total amount of policies that are you applying in your environment. It will also give a high-level overview of which policies has less compliance level and which resources require more attention.

You can filter the information by:

- Management Group with subscriptions
- Subscription
- Policy scope

If you navigate to a impacted resource you will see a quick description of the applied policies.

![policies](/install/images/governancePolicies.png)

## Azure Blueprints page

In this page of the report, you will be able to identify the total amount of blueprints that are you applying in your environment. It will also show which are the artifacts within the blueprints.

You can filter the information by:

- Subscription with assigned blueprints
- Blueprint Definition
  
![governanceSubsBlueprints](/install/images/governanceSubsBlueprints.png)
