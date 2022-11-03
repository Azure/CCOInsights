### _Navigation_

- [Requirements](#requirements)
- [Resource Providers requirements](#resource-providers-requirements)
- [Installing the custom connector](#installing-the-custom-connector)
- [Setting up the Azure Governance Dashboard](#setting-up-the-azure-governance-dashboard)
  - [Template download](#template-download)
  - [Environment selection](#environment-selection)
  - [Modify Privacy settings](#modify-privacy-settings)
  - [Credentials](#credentials)
    - [Clean Credentials on the Data Source](#clean-credentials-on-the-data-source)
    - [Refresh the dashboard](#refresh-the-dashboard)
    - [Credentials for management.azure.com REST API request](#credentials-for-managementazurecom-rest-api-request)
    - [Credentials for Custom Connector](#credentials-for-custom-connector)

---

<br>

# Requirements

- The CCO Azure Governance Dashboard is a Power BI Template that requires to download and install the Microsoft Power BI Desktop Edition from the Microsoft Store. Below you can find the minimum requirements to run the Dashboard
  - Windows 10 version **14393.0** or **higher**.
  - Internet access from the computer running Microsoft Power BI desktop.
  - An Azure account on the desired tenant space with permissions on the subscriptions to read from the Azure Services described above.
  - Install the custom connector and allow the use of any extension to load data without validation or warning.

<br>

# Resource Providers requirements

Although some of the Resource Providers might be enabled by default, you need to make sure that at least the **Microsoft.Security** resource provider is registered across all the  subscriptions that you plan analyze using the Dashboard. 

Registering this Resource Provider has no cost or performance penalty on the subscription:

1. Click on **Subscriptions**.
2. Click on the Subscription name you want to configure.
3. Click on **Resource Providers**.
4. Click on **Microsoft.Security** and **Register**.

<br>

# Installing the custom connector

The CCO Azure Governance Dashboard requires to install the Power BI Custom Connector located in the same folder as the CCO Governance Dashboard: ([CCoDashboardAzureConnector.mez][CCoDashboardAzureConnector]). This Custom Connector allows us to leverage information from Azure Management REST APIs that requires POST methods and errors control

To install the custom connector you must copy the file [CCoDashboardAzureConnector.mez][CCoDashboardAzureConnector] from the **ccodashboard/dashboards/CCODashboard-Governance/** folder to the folder that Power BI creates by default in the Documents folder in your PC. If this folder doesn't exist, you can create a new one with this name.

The path should be **C:\Users\\%username%\Documents\Power BI Desktop\Custom Connectors** or if you are using OneDrive to backup the documents folder this path would not work for you and you should manually go to your documents folder and create the folder structure there. 

![CustomConnectorFolder][CustomConnectorFolder]

Then go to Power BI Options and under Global category in the Security section, select **(Not Recommended) Allow any extension to load without validation or warning** and click **OK**.

![CustomConnectorSecurity][CustomConnectorSecurity]

<br>

# Setting up the Azure Governance Dashboard

## Template download
Download and open the `.pbit` file from  [CCODashboard-Governance][CCODashboardGovernance] folder.

## Environment selection

Before start loading data you need to select which type of environment you're using:

- Select "Global" for Microsoft Azure commercial environments. This is the default selection.
- Select [US-Government][UsGovernment] for Azure Us government services. Azure Government is a separate instance of the Microsoft Azure service. It addresses the security and compliance needs of United States federal agencies, state and local governments, and their solution providers.

![selector][SelectorGov]

## Modify Privacy settings

- Go to File -> Options -> Privacy and set to Always ignore privacy level settings.

![Privacy][Privacy]

## Credentials

By default, the template doesn't have any Azure Account credentials preloaded. Hence, the first step to start loading subscriptions data is to sign-in with the right user credentials.

**IMPORTANT NOTE**: Power BI Desktop caches the credentials after the first logon. It is important to clear the credentials from Power BI desktop if you plan to switch between Azure Global and any other region like US Government or China. The same concept applies if you plan to switch between tenants. Otherwise, the staged credentials will be used again for the different Azure environments and the authentication or data load process will fail.

### Clean Credentials on the Data Source

In some cases, old credentials are cached by previous logins using Power BI Desktop and the dashboard might show errors or blank fields.

- Click on Data sources in **Current file/Global permissions**
- Click on **Clear Permissions**.
- Click on **Clear All Permissions**.

![credentials1][Credentials1] ![credentials2][Credentials2]

### Refresh the dashboard

If the permissions and credentials are properly flushed it should ask you for credentials for each REST API and you will have to set the Privacy Levels for each of them.

- Click on **Refresh**.
  
![refreshgovernance][RefreshGovernance]

### Credentials for management.azure.com REST API request

- Click on **Organizational Account**.
- Click on **Sign in**.
- Click on **Connect**.

![credentials4][Credentials4]

### Credentials for Custom Connector

- Click on **Organizational Account**.
- Click on **Sign in**.
- Click on **Connect**.

![CustomConnector][CustomConnector]

<br>


<!-- Docs -->
[UsGovernment]: <https://learn.microsoft.com/en-us/azure/azure-government/documentation-government-developer-guide>

<!-- Images -->
[CustomConnectorFolder]: <./media/customconnectorfolder.PNG>
[CustomConnectorSecurity]: <./media/customconnectorsecurity.PNG>
[SelectorGov]: <./media/selectorGov.PNG>
[Privacy]: <./media/governancePrivacy.png>
[Credentials1]: <./media/Credentials1.png>
[Credentials2]: <./media/Credentials2.png>
[RefreshGovernance]: <./media/refreshgovernance1.png>
[Credentials4]: <./media/Credentials4.png>
[CustomConnector]: <./media/customconnector.PNG>

<!-- References -->
[CCoDashboardAzureConnector]: <https://github.com/Azure/CCOInsights/blob/main/dashboards/CCODashboard-Governance/CcoDashboardAzureConnector.mez>
[CCODashboardGovernance]: <https://github.com/Azure/CCOInsights/tree/main/dashboards/CCODashboard-Governance>