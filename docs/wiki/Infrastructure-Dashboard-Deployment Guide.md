### _Navigation_

- [Requirements](#requirements)
- [Resource Providers requirements](#resource-providers-requirements)
- [Azure Advisor Recommendations](#azure-advisor-recommendations)
  - [Generating Azure Advisor recommendations manually](#generating-azure-advisor-recommendations-manually)
- [Azure Security Center Recommendations](#azure-security-center-recommendations)
- [Setting up the Azure Infrastructure Dashboard](#setting-up-the-azure-infrastructure-dashboard)
  - [Template download](#template-download)
  - [Environment selection](#environment-selection)
  - [Modify Privacy settings](#modify-privacy-settings)
  - [Credentials](#credentials)
    - [Clean Credentials on the Data Source](#clean-credentials-on-the-data-source)
    - [Refresh the dashboard](#refresh-the-dashboard)
    - [Credentials for management.azure.com REST API request:](#credentials-for-managementazurecom-rest-api-request)
    - [Credentials for graph.windows.net API](#credentials-for-graphwindowsnet-api)
    - [Credentials for api.loganalytics.io API](#credentials-for-apiloganalyticsio-api)
    - [Enter Access Web content credentials](#enter-access-web-content-credentials)

---

<br>

# Requirements

- The CCO Azure Infrastructure Dashboard is a Power BI Template that requires to download and install the Microsoft Power BI Desktop Edition from the Microsoft Store. Below you can find the minimum requirements to run the Dashboard
    -	Windows 10 version **14393.0** or **higher**.
    -	Internet access from the computer running Microsoft Power BI desktop.
    - An Azure account on the desired tenant space with permissions on the subscriptions to read from the Azure Services described above.
    - The subscriptions will need to use the Azure Security Center **Standard** plan if you want to detect and see the alerts in the Azure Security Center Alerts page of the CCO Azure Infrastructure Dashboard.

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

# Azure Advisor Recommendations

Azure Advisor is a personalized cloud consultant that helps you follow best practices to optimize your Azure deployments. It analyzes your resource configuration and usage telemetry. It then recommends solutions to help improve the performance, security, and high availability of your resources while looking for opportunities to reduce your overall Azure spend.

The Continuous Optimization Power BI Dashboard will directly pull data from Azure Advisor REST APIs to aggregate all the information across the Azure account subscriptions. This requires generating the recommendations before the first time we load the template else the Dashboard will be empty or will fail because it was unable to download any data.

To do so, you need to generate the recommendations for the first time manually from the Azure Portal, or programmatically using the script [GenerateAllSubscriptionsAdvisorRecommendations.ps1][GenerateAllSubscriptionsAdvisorRecommendations.ps1]

## Generating Azure Advisor recommendations manually

Open the Azure Portal with your Azure Account https://portal.azure.com 

1. Click on **Advisor**.
2.	Expand the subscriptions drop-down menu.
3.	Select the subscription you want to update or generate the recommendations for the first time.
4.	Wait until the recommendations for the selected subscriptions has been loaded.
5.	Repeat these steps for each subscription you want to generate Azure Advisor recommendations.

![AdvisorRecommendations][AdvisorRecommendations]

<br>

# Azure Security Center Recommendations

Azure Security Center provides unified security management and advanced threat protection for workloads running in Azure, on-premises, and in other clouds. It delivers visibility and control over hybrid cloud workloads, active defense that reduces your exposure to threats, and intelligent detection to help you keep pace with rapidly evolving cyber-attacks.

You can find more information at the official Azure Security Center site [here][SecurityCenterIntro].

Azure Security Center is offered in two tiers:

- Free
- Standard
  
The Standard tier is offered [free for the first 60 days][FreeForTheFirst60Days].

The subscriptions will need to use the **Standard** tier if you want to detect and see the alerts in the Azure Security Center Alerts page of the dashboard.

The following picture shows the steps to configure Azure Security Center plan for Azure Subscriptions

1.	Click on **Security Center**.
2.	Click on **Click on top to learn more**.
3.	Click on **Select the subscription you want to configure**.
4.	Click on **Free** or **Standard** plan and the click **Save**.

![SecurityCenterStandardRecommendations][SecurityCenterStandardRecommendations]

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

**IMPORTANT NOTE**: Power BI Desktop caches the credentials after the first logon. It is important to clear the credentials from Power BI desktop if you plan to switch between Azure GLobal and any other region like US Government or China. The same concept applies if you plan to switch between tenants. Otherwise, the staged credentials will be used again for the different Azure environments and the authentication or data load process will fail.

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

### Credentials for api.loganalytics.io API

- Click on **Organizational Account**.
- Click on **Sign in**.
- Click on **Connect**.

![loganalytics][LogAnalytics]

### Enter Access Web content credentials

- Make sure that you select **Organization account** type.
- Click on **Sign in**.
  
![credentials7][Credentials7]

<br>

<!-- Docs -->
[OnboardToLighthouse]: <https://learn.microsoft.com/en-us/azure/lighthouse/how-to/onboard-customer>
[SecurityCenterIntro]: <https://learn.microsoft.com/en-us/azure/security-center/security-center-intro>
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