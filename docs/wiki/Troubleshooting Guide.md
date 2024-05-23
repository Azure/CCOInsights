### _Navigation_

- [Introduction](#introduction)
- [List of known issues or limitations](#list-of-known-issues-or-limitations)
  - [Which Power BI Desktop version I should use? (Microsoft Store or Web Download)](#which-power-bi-desktop-version-i-should-use-microsoft-store-or-web-download)
  - [Power BI Regional Settings (Maps Visualizations incorrectly locate resources or VNET peerings)](#power-bi-regional-settings-maps-visualizations-incorrectly-locate-resources-or-vnet-peerings)
  - [Graph REST API credentials error](#graph-rest-api-credentials-error)
  - [Privacy Levels across Data Sources not configured properly](#privacy-levels-across-data-sources-not-configured-properly)
  - [RBAC information is empty or blank](#rbac-information-is-empty-or-blank)
  - [Management Groups Access to the resource is forbidden error](#management-groups-access-to-the-resource-is-forbidden-error)
  - [Log Analytics REST API timeout (CCO AKS dashboard add-on only)](#log-analytics-rest-api-timeout-cco-aks-dashboard-add-on-only)
  - [Data Model Relationships missing](#data-model-relationships-missing)
  - [Errors regarding missing `column1` on refresh](#errors-regarding-missing-column1-on-refresh)
  - [Custom connector not recognized](#custom-connector-not-recognized)
  - ["Invoked Custom Function" step error](#invoked-custom-function-step-error)
  - [Using CCO Insights with Azure subscriptions provided by Visual Studio benefits (MSDN)](#using-cco-insights-with-azure-subscriptions-provided-by-visual-studio-benefits-msdn)
---

<br>

# Introduction
During the continued development of CCO Insights, we have been able to identify and fix several bugs or product limitations and we would like to encourage you to read this document before starting to leverage the solution. Before creating a new issue, please review the existing ones [here](https://github.com/Azure/CCOInsights/issues?q=is%3Aissue) to avoid wait periods obtaining response.


# List of known issues or limitations

We will keep updating this list of known issues as soon as we get more feedback from the community.

## Which Power BI Desktop version I should use? (Microsoft Store or Web Download)

Based on our experience we highly recommend to use the Power BI Desktop version from the Microsoft Store to get automatic updates. [This explains][PowerBIDesktop] the main difference between both options. <br>
Make sure that you don't have both versions installed on the computer where you plan to use CCO Insights.

## Power BI Regional Settings (Maps Visualizations incorrectly locate resources or VNET peerings)

It might happen then when you run the Dashboard using different regional settings some coordinates are not calculated properly. CCO Insights' development has been based on English US regional settings. Make sure that you set the Regional Settings to use English (United States) on the application language on both Global and Current File options. If the current file has a different configuration you will need to change to English US, export the file as template again, and then open it from your computer

![LocaleOptionsPowerBI][LocaleOptionsPowerBI]

## Graph REST API credentials error

During the first use of the CCO Insights templates you should be prompted to enter the credentials for both the Azure Management REST API and the GRAPH REST API. You might get the error message from below if you incorrectly enter your credentials. Also, in some cases, during the first run, Power BI will not ask for credentials because they are already cached by a previous use of another Power BI Dashboard accessing the same APIs.

![WrongTenantNameError][WrongTenantNameError]

![ProblemGraphApi][ProblemGraphApi]

If that happens you will need to manually set the proper credentials for the GRAPH REST API Data Source.
To do this you must follow this steps:

- Go to **File**.
- Click on **Options and settings**.
- Click on **Data source settings**.
- In in **Current file/Global permissions** select https://graph.windows.net and click on **Edit permissions**.
- Click on **Edit** and enter your credentials.

![Credentials5][Credentials5]

## Privacy Levels across Data Sources not configured properly

Another credentials issue we identified during our pilots is that in some cases the end user didn't setup the Privacy levels correctly getting the following error

![WrongPrivacyLevelError][WrongPrivacyLevelError]

This is an example of a wrong Privacy Levels configuration across Data Sources. Makes sure that you set both Data Sources to Organizational

![WrongPrivacyLevelConfig][WrongPrivacyLevelConfig]

## RBAC information is empty or blank

Every time you run the Dashboard from the .pbit template you will be asked to enter the Tenant parameter. This parameter is critical to properly get your RBAC information. If this parameter is entered incorrectly but the tenant exists it will load the Dashboard information with blank information on the RBAC page or the Subscriptions Owners visualization on the Overview page

![Wrong Tenant Name][WrongTenantName]

## Management Groups Access to the resource is forbidden error

Management Groups in Azure is a relatively new capability and some users reported the following error when loading the Dashboard for the first time. The reason behind that error can be the lack of permissions but also because there is no Management Groups definition.

![Management Groups access forbidden][ManagementGroupsAccessForbidden]

If that is the case and you are still not using Management Groups in your environment you can simply open the Query Editor, browse to the Management Groups query on the left side panel and disable the query. You will need to refresh all the data once this change is applied.

![Management Groups access forbidden workaround][ManagementGroupsAccessForbiddenWorkaround]

## Log Analytics REST API timeout (CCO AKS dashboard add-on only)

Depending on the number of records we have in log analytics, we can obtain a timeout during the refresh.

The solution is to wait a few minutes and launch a new refresh.

## Data Model Relationships missing

In some occasions when having both Power BI Desktop versions installed on the computer we have seen the Data Relationship model to disappear. If that happens you can use the following reference to manually reconfigure the relationship between tables. It should also help you to understand how we defined the Data Model in case you want to expand the default content

Governance:

![relationship model gov][RelationshipModelGov]

Infrastructure:

![relationship model infra][RelationshipModelInfra]


## Errors regarding missing `column1` on refresh

Try using a native user account to the AAD tenant you are connecting to instead of a guest user account.

## Custom connector not recognized

To make sure the custom connector is configured correctly, please check the following security settings in Power BI Desktop.

Under the File menu, click on the "Options and Settings" button, then chose Options. In the dialog, click on Security and select "Allow any extension to load without validation of warning".

![PowerBISecurityConfiguration][PowerBISecurityConfiguration]

Under the Home menu, click on "Get Data", then chose the "More..." option. Select Azure from the list on the left to filter the options.

![PowerBIDataConnectors][PowerBIDataConnectors]

Once this configuration is in place, you can use the solution to get data.

## "Invoked Custom Function" step error

In scenarios where this error is displayed, validate the PowerBi configurations on "Security" and "Privacy":

Under the File menu, click on the "Options and Settings" button, then chose Options. In the dialog, click on Security and select "Allow any extension to load without validation of warning".

![PowerBISecurityConfigurationDataExtensions][PowerBISecurityConfiguration]

Under the File menu, click on the "Options and Settings" button, then chose Options. In the dialog, click on Privacy and select the "Always ignore Privacy Level settings"

![PowerBIPrivacyConfigurationLevels][PowerBIPrivacyConfiguration]

## Using CCO Insights with Azure subscriptions provided by Visual Studio benefits (MSDN)

In the Governance dashboard, there is an error that might occurr in the "All Subscription > Get Pages" in these type of Azure subscription. The same error does not happen for non-MSDN subscriptions.

<!-- Docs -->
[PowerBIDesktop]: <https://learn.microsoft.com/en-us/power-bi/fundamentals/desktop-get-the-desktop>

<!-- Images -->
[WrongTenantNameError]: <./media/WrongTenantNameError.png>
[ProblemGraphApi]: <./media/problem_graph_api.png>
[WrongTenantName]: <./media/RBACwrongTenantName.PNG>
[ManagementGroupsAccessForbidden]: <./media/MGForbiddenAccessError.png>
[ManagementGroupsAccessForbiddenWorkaround]: <./media/MGQueryDisabled.png>
[RelationshipModelGov]: <./media/RelationshipsModelGovernance.PNG>
[RelationshipModelInfra]: <./media/RelationshipsModelInfrastructure.PNG>
[WrongPrivacyLevelError]: <./media/WrongPrivacyLevelError.png>
[WrongPrivacyLevelConfig]: <./media/WrongPrivacyLevelConfig.png>
[Credentials5]: <./media/Credentials5.png>
[LocaleOptionsPowerBI]: <./media/locale_options_powerBI.PNG>
[PowerBISecurityConfiguration]: <./media/PowerBI-SecurityConfiguration.png>
[PowerBIDataConnectors]: <./media/PowerBI-DataConnectors.png>
[PowerBIPrivacyConfiguration]: <./media/PowerBI-PrivacyConfigurationPrivacyLevels.png>

<!-- References -->
