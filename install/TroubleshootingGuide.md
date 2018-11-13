# CCO Dashboard Troubleshooting guide
<div style="text-align: justify">

## Introduction
The Continuous Cloud Optimization Power BI Dashboard development started more than 1 year ago. During all this time the project team and some Microsoft Services folks have been piloting and testing different versions of the Dashboards until the latest version published in here (v4.0). We have been able to identify and fix several bugs or product limitations and we would like to encourage you to read this document before running the Dashboard.

- ## List of known issues or limitations
    - [Which Power BI Desktop version I should use?](TroubleshootingGuide.md#Which-Power-BI-Desktop-version-I-should-use?)  (Microsoft Store or  Web Download)
    - [Power BI Regional Settings](TroubleshootingGuide.md#Power-BI-Regional-Settings)
    (Maps Visualizations incorrectly locate resources or VNET peerings)
    - [Graph REST API credentials error](TroubleshootingGuide.md#Graph-REST-API-credentials-error)

    - [Privacy Levels across Data Sources not configured properly](TroubleshootingGuide.md#Privacy-Level-across-Data-Sources-not-configured-properly)

    - [RBAC information is empty or blank](TroubleshootingGuide.md#RBAC-information-is-empty-or-blank)

    - [Log Analytics REST API timeout (CCO Dashboard AKS add on only)](TroubleshootingGuide.md#Log-Analytics-REST-API-timeout)

    - [Relationship model across tables is broken]()

We will keep updating this list of known issues as soon as we get more feedback from the community....
   
----------------------------------
#### Which Power BI Desktop version I should use? (Microsoft Store or Web Download)

Based on our experience we highly recommend to use the Power BI Desktop version from the Microsoft Store to get automatic updates. The following article explains the main difference between both options. https://docs.microsoft.com/en-us/power-bi/desktop-get-the-desktop <br>
Make sure that you don't have both versions installed on the computer where you plan to run the CCO Dashboard.

#### Power BI Regional Settings (Maps Visualizations incorrectly locate resources or VNET peerings)

It might happen then when you run the Dashboard using different regional settings some coordinates are not calculated properly. The CCO Dashboard development has been based on English US regional settings. Make sure that you set the Regional Settings to use English (United States) on the application Language on both Global and Current File options. If the current file has a different configuration you will need to change to English US, export the file as template again, and then open it from your computer

![localel](/install/images/locale_options_powerBI.PNG)

#### Graph REST API credentials error

During the first run of the CCO Dashboard template you should be prompted to enter the credentials for both the Azure Management REST API and the GRAPH REST API. You might get the error message from below if you incorrectly enter your credentials. Also, in some cases, during the first execuction Power BI will not ask for credentials because they are already cached by some other Power BI Dashboard execution accessing the same APIs. 

![graph apil](/install/images/WrongTenantNameError.png)

![graph apil](/install/images/problem_graph_api.png)

If that happens you will need to manually set the proper credentials for the GRAPH REST API Data Source.
To do this you must follow this steps:

- Go to **File**.
- Click on **Options and settings**.
- Click on **Data source settings**.
- In in **Current file/Global permissions** select https://graph.windows.net and click on **Edit permissions**.
- Click on **Edit** and enter your credentials.

    ![creds sync](/install/images/Credentials5.png)




#### Privacy Levels across Data Sources not configured properly

Another credentials issue we identified during our pilots is that in some cases the end user didn't setup the Privacy levels correctly getting the following error

![Privacy Levels Error](/install/images/WrongPrivacyLevelError.png)

This is an example of a wrong Privacy Levels configuration across Data Sources. Makes sure that you set both Data Sources to Organizational

![Wrong Privacy Levels config](/install/images/WrongPrivacyLevelConfig.png)

#### RBAC information is empty or blank

Everytime you run the Dashboard from the .pbit template you will be asked to enter the Tenant parameter. This parameter is critical to properly get your RBAC information. If this parameter is entered incorrectly but the tenant exists it will load the Dashboard information with blank information on the RBAC page or the Subscriptions Owners visualization on the Overview page

![Wrong Tenant Name](/install/images/RBACwrongTenantName.PNG)

#### Log analytics API timeout

Depending on the number of records we have in log analytics, we can obtain a timeout during the refresh.

The solution is to wait a few minutes and launch a new refresh.

#### Relationships Model

If something happens and all the relationships between tables are broken, the following picture shows the actual relationship model inside the CCO Power BI dashboard.

![relationship model](/install/images/RelationshipsModel.PNG)


