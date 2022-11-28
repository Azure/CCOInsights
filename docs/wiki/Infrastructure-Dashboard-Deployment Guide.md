### _Navigation_

- [Requirements](#requirements)
- [Resource Providers requirements](#resource-providers-requirements)
- [Installing the custom connector](#installing-the-custom-connector)
- [Azure Advisor Recommendations](#azure-advisor-recommendations)
  - [Generating Azure Advisor recommendations manually](#generating-azure-advisor-recommendations-manually)
- [Azure Defender Recommendations](#azure-defender-recommendations)
- [Setting up the Azure Infrastructure Dashboard](#setting-up-the-azure-infrastructure-dashboard)
  - [Template download](#template-download)
  - [Environment selection](#environment-selection)
  - [Modify Privacy settings](#modify-privacy-settings)
  - [Credentials](#credentials)
    - [Clean Credentials on the Data Source](#clean-credentials-on-the-data-source)
    - [Refresh the dashboard](#refresh-the-dashboard)
    - [Credentials for management.azure.com REST API request:](#credentials-for-managementazurecom-rest-api-request)
    - [Credentials for graph.windows.net API](#credentials-for-graphwindowsnet-api)
    - [Enter Access Web content credentials](#enter-access-web-content-credentials)

---

<br>

# Requirements

- The CCO Azure Infrastructure Dashboard is a Power BI Template that requires to download and install the Microsoft Power BI Desktop Edition from the Microsoft Store. Below you can find the minimum requirements to run the Dashboard
    -	Windows 10 version **14393.0** or **higher**.
    -	Internet access from the computer running Microsoft Power BI desktop.
    - An Azure account on the desired tenant space with permissions on the subscriptions to read from the Azure Services described above.
    - The subscriptions will need to use the Azure Defender **paid** plan if you want to detect and see the alerts in the Azure Defender Alerts page of the CCO Azure Infrastructure Dashboard.

Below you can find the list of providers and the actions that you will need to permit to allow to run the CCO Power BI Dashboard:

| Resource Provider Name| Permissions |
| --- | --- |
|Azure Advisor| Microsoft.Advisor/generateRecommendations/action <br>
|*|*/Read|

**IMPORTANT**: You must follow [this procedure][OnboardToLighthouse] to implement Azure delegated resource management to get data from subscriptions in other tenants.

<br>

# Resource Providers requirements

Although some of the Resource Providers might be enabled by default, you need to make sure that at least the **Microsoft.Advisor** and the **Microsoft.Security** resource providers are registered across all the  subscriptions that you plan analyze using the Dashboard.

Registering these 2 Resource Providers has no cost or performance penalty on the subscription:

1. Click on **Subscriptions**.
2. Click on the Subscription name you want to configure.
3. Click on **Resource Providers**.
4. Click on **Microsoft.Advisor** and **Register**.
5. Click on **Microsoft.Security** and **Register**.

![resource providers][ResourceProviders]

<br>

# Installing the custom connector

The CCO Azure Infrastructure Dashboard requires to install the Power BI Custom Connector located in the same folder as the CCO Infrastructure Dashboard: ([CCoDashboardAzureConnector.mez][CCoDashboardAzureConnector]). This Custom Connector allows us to leverage information from Azure Management REST APIs that requires POST methods and errors control

To install the custom connector you must copy the file [CCoDashboardAzureConnector.mez][CCoDashboardAzureConnector] from the **ccodashboard/dashboards/CCODashboard-Infrastructure/** folder to the folder that Power BI creates by default in the Documents folder in your PC. If this folder doesn't exist, you can create a new one with this name.

The path should be **C:\Users\\%username%\Documents\Power BI Desktop\Custom Connectors** or if you are using OneDrive to backup the documents folder this path would not work for you and you should manually go to your documents folder and create the folder structure there.

![CustomConnectorFolder][CustomConnectorFolder]

Then go to Power BI Options and under Global category in the Security section, select **(Not Recommended) Allow any extension to load without validation or warning** and click **OK**.

![CustomConnectorSecurity][CustomConnectorSecurity]


# Azure Advisor Recommendations

Azure Advisor is a personalized cloud consultant that helps you follow best practices to optimize your Azure deployments. It analyzes your resource configuration and usage telemetry. It then recommends solutions to help improve the performance, security, and high availability of your resources while looking for opportunities to reduce your overall Azure spend.

The Continuous Optimization Power BI Dashboard will directly pull data from Azure Advisor REST APIs to aggregate all the information across the Azure account subscriptions. This requires generating the recommendations before the first time we load the template else the Dashboard will be empty or will fail because it was unable to download any data.


## Generating Azure Advisor recommendations manually

Open the Azure Portal with your Azure Account https://portal.azure.com

1. Click on **Advisor**.
2.	Expand the subscriptions drop-down menu.
3.	Select the subscription you want to update or generate the recommendations for the first time.
4.	Wait until the recommendations for the selected subscriptions has been loaded.
5.	Repeat these steps for each subscription you want to manually generate Azure Advisor recommendations.

![AdvisorRecommendations][AdvisorRecommendations]

<br>

# Azure Defender Recommendations

Microsoft Defender for Cloud is a Cloud Security Posture Management (CSPM) and Cloud Workload Protection Platform (CWPP) for all of your Azure, on-premises, and multicloud (Amazon AWS and Google GCP) resources. Defender for Cloud fills three vital needs as you manage the security of your resources and workloads in the cloud and on-premises.

You can find more information at the official Azure Defender site [here][SecurityCenterIntro].

The subscriptions will need to use the **paid** tier if you want to detect and see the alerts in the Azure Defender Alerts page of the dashboard.

<br>

# Setting up the Azure Infrastructure Dashboard

## Template download

Download and open the `.pbit` file from  [CCODashboard-Infra][CCODashboardInfra] folder.

## Environment selection

Before start loading data you need to select which type of environment you're using:

- Select "Global" for Microsoft Azure commercial environments. This is the default selection.
- Select [US-Government][UsGovernment] for Azure Us government services. Azure Government is a separate instance of the Microsoft Azure service. It addresses the security and compliance needs of United States federal agencies, state and local governments, and their solution providers.
- **Preview feature:** Select [China][China] to load data from cloud applications in Microsoft Azure operated by 21Vianet (Azure China).

![selector][Selector]

## Modify Privacy settings

- Go to File -> Options -> Privacy and set to Always ignore privacy level settings.

![Privacy][Privacy]

## Credentials

By default, the template doesn’t have any Azure Account credentials preloaded. Hence, the first step to start showing subscriptions data is to sign-in with the right user credentials.

**IMPORTANT NOTE**: Power BI Desktop caches the credentials after the first logon. It is important to clear the credentials from Power BI desktop if you plan to switch between Azure Global and any other region like US Government or China. The same concept applies if you plan to switch between tenants. Otherwise, the staged credentials will be used again for the different Azure environments and the authentication or data load process will fail.

### Clean Credentials on the Data Source

In some cases, old credentials are cached by previous logins using Power BI Desktop and the dashboard might show errors or blank fields.

- Click on Data sources in **Current file/Global permissions**.
- Click on **Clear Permissions**.
- Click on **Clear All Permissions**.

![credentials1][Credentials1] ![credentials2][Credentials2]

### Refresh the dashboard

If the permissions and credentials are properly flushed it should ask you for credentials for each REST API and you will have to set the Privacy Levels for each of them.

- Click on **Refresh**.

![credentials3][Credentials3]

### Credentials for management.azure.com REST API request:

- Click on **Organizational Account**.
- Click on **Sign in**.
- Click on **Connect**.


![credentials4][Credentials4]

### Credentials for graph.windows.net API

- Click on **Organizational Account**.
- Click on **Sign in**.
- Click on **Connect**.

![credentials5][Credentials5]


### Enter Access Web content credentials

- Make sure that you select **Organization account** type.
- Click on **Sign in**.

![credentials7][Credentials7]

<br>

<!-- Docs -->
[OnboardToLighthouse]: <https://learn.microsoft.com/en-us/azure/lighthouse/how-to/onboard-customer>
[SecurityCenterIntro]: <https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction>
[FreeForTheFirst60Days]: <https://azure.microsoft.com/en-us/pricing/details/security-center/>
[UsGovernment]: <https://learn.microsoft.com/en-us/azure/azure-government/documentation-government-developer-guide>
[China]: <https://learn.microsoft.com/en-us/azure/china/resources-developer-guide>
[Privacy]: <./media/governancePrivacy.png>


<!-- Images -->
[ResourceProviders]: <./media/resourceproviders.png>
[AdvisorRecommendations]: <./media/AdvisorRecommendations.png>
[SecurityCenterStandardRecommendations]: <./media/EnableSecurityCenterStandard.png>
[Selector]: <./media/selector.png>
[Credentials1]: <./media/Credentials1.png>
[Credentials2]: <./media/Credentials2.png>
[Credentials3]: <./media/Credentials3.png>
[Credentials4]: <./media/Credentials4.png>
[Credentials5]: <./media/Credentials5.png>
[LogAnalytics]: <./media/loganalyticsAPI.PNG>
[Credentials7]: <./media/Credentials7.png>

<!-- References -->
[GenerateAllSubscriptionsAdvisorRecommendations.ps1]: <https://github.com/Azure/CCOInsights/blob/main/install/scripts/GenerateAllSubsAdvisorRecommendations.ps1>
[CCODashboardInfra]: <https://github.com/Azure/CCOInsights/tree/master/dashboards/CCODashboard-Infra>