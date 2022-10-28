### _Navigation_

  - [Overview](#overview)
  - [Infrastructure](#infrastructure)
    - [Deployment](#deployment)
      - [Prerequisites](#prerequisites)
      - [Backend Deployment](#backend-deployment)
  - [Dashboard](#dashboard)

# Overview

As part of the Continuous Cloud Optimization Insights solution, a dashboard is included to track the contributions made to a GitHub repository. The objective is to monitor not only the cloud environment, but also all the resources used for its design, deployment and maintenance. This dashboard allows you to monitor different metrics such as:
- Number of contributors
- Number of clones, forks, watchers, stars
- Pull requests
  - Number of open pull requests
  - Average pull requests per day
  - Pull requests' lifecycle (in days)
  - Comparison between number of open vs closed pull requests over the last months
- Comparison between number of lines added vs deleted per month
- Top contributors measured by changes in their pull requests.

An important note about this dashboard is that **this dashboard can be published in the PowerBI online service with auto refresh enabled**. The difference with the current versions of the other dashboards of CCO Insights is that, for this one, no dynamic queries are being done directly from the PowerBI file, meaning that it can be published and consumed directly from the [PowerBI online][PublishPowerBI] service.

# Infrastructure

This dashboard requires an infrastructure being deployed in Azure. The infrastructure consists of a Powershell Function App, an Application Insights for monitoring and a Storage Account where results from the GitHub REST API calls will be stored in different tables. The following diagram represents the infrastructure to be deployed.

![ADO Dashboard Architecture][GHDashboardArchitecture]

## Deployment

As part of this solution we offer you already the required [bicep][BicepOverview] template that will deploy and connect the architecture presented previously.

### Prerequisites

In order to successfully user the deploy.bicep and workflow provided, you will need to have:
- This repository forked in your own environment.
- An Azure subscription. If you don't have one you can create one for free using this [link][GetAzure]. If you already have an Azure tenant but you want to create a new subscription you can follow the instructions [here][CreateSubscription].
- A [resource group][ResourceGroup] already created.
- A service principal with Owner permissions in your subscription. You will need owner permissions because as part of the architecture you will be creating a Managed Identity that will require a role assignment to save the retrieve data in the Storage Account. You can create your service principal with Contributor permissions by running the following commands:
    ```sh
    az ad sp create-for-rbac --name "<<service-principal-name>>" --role "Contributor" --output "json"
    ```
- A secret in your GitHub repository with the name `AZURE_CREDENTIALS`. You can user the output from the previous command to generate this secret. The format of the secret should be:
    ```json
    {
    "clientId": "<client_id>",
    "ClientSecret": "<client_secret>",
    "SubscriptionId": "<subscription_id>",
    "TenantId": "<tenant_id>"
    }
    ```
- Another secret in your GitHub repository with the name `PAT`. This will be store the value of a PAT token you will need to generate with the following permissions:
    | Scope | Permission |
    |-------| ---------- |
    | repo | Full control of private repositories |
    | user | Update ALL user data |
    | admin:repo_hook | Full control of repository hooks |
    | admin:org | Full control of orgs and teams, read and write org projects |
- In the [local.settings.json][local.settings.json] file, update the values for the `owner`, `repository`, `resourceGroup` and `storageAccount` with the names you want to configure in your environment. Also, make sure that these names match the values in the [deploy.bicep][deploy.bicep] file for the same resources.

    > Note: The **owner** and **repository** names correspond to the GitHub organization and repository name from where the information needs to be retrieved.

### Backend Deployment

In the [infrastructure][infrastructure] folder you will find a `deploy.bicep` file which is the template that will be used to deploy the infrastructure. Please, go ahead and update the first two parameters (`name` and `staname`) with your unique values. **Name** will be used to compose the name of all resources except for the storage account, which will leverage the **staname**.

In the [src][src] folder you can find the source code that will be deployed in the Function App once the infrastructure is ready. Basically you will deploy two endpoints:
- **InitializeTables**: you will need to run this endpoint once manually to initialize the Storage Account with the required tables and collect all the data history available in the GitHub API.
- **GitHubDailySync**: this endpoint will be automatically run in a daily basis and will add more data to the already created storage account tables. If you don't want a daily cadence you can update the cron expression in the `function.json` file under the [GitHub DailySync folder][GitHubDailySyncfolder].

Finally, if you go to the root folder of the repository, you will find the [workflows folder][WorkflowsFolder] under the `.github` folder. There you can locate the workflow that you will have to run to deploy the backend of the dashboard. The only parameter you will need to setup manually while triggering the workflow in the `resourceGroupName` that you created earlier.

Now you are ready to deploy your backend in your environment:
![deploy-backend][DeployBackend]

After successfully deploying the backend go to the Azure portal and manually run the `InitializeTables` endpoint. Make sure you see the tables in your Storage Account before moving forward.

![storage-tables][StorageTables]

# Dashboard

With the previous backend deployed, you can now download the [GitHubContributions.pbit][GitHubContributionsDashboard] file and open it locally. You will be asked to enter:
- The Storage Account name of the Storage Account you deployed.
![Storage Account Name][StorageAccountName]
- The Storage account access key.

After that you will be able to monitor your contributions!

![GitHub Contributions][GitHubContributions]

<!-- Docs -->
[PublishPowerBI]: <https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-upload-desktop-files>
[BicepOverview]: <https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep>
[GetAzure]: <https://azure.microsoft.com/en-us/free/search/?OCID=AID2200258_SEM_069a8abd963111ebbd21e8d33199249f:G:s&ef_id=069a8abd963111ebbd21e8d33199249f:G:s&msclkid=069a8abd963111ebbd21e8d33199249f>
[CreateSubscription]: <https://docs.microsoft.com/en-us/azure/cost-management-billing/manage/create-subscription#:~:text=On%20the%20Customers%20page%2C%20select%20the%20customer.%20In,page%2C%20select%20%2B%20Add%20to%20create%20a%20subscription>
[ResourceGroup]: <https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal>

<!-- Images -->
[GHDashboardArchitecture]: <./media/github-dashboard-architecture.png>
[DeployBackend]: <./media/run-workflow.jpg>
[StorageTables]: <./media/storage-tables.jpg>
[StorageAccountName]: <./media/github-storage-account.jpg>
[GitHubContributions]: <./media/Github-contributions-dashboard.jpg>

<!-- References -->
[local.settings.json]: <https://github.com/Azure/CCOInsights/blob/main/dashboards/GitHubDashboard-Contributors/src/local.settings.json>
[deploy.bicep]: <https://github.com/Azure/CCOInsights/blob/main/dashboards/GitHubDashboard-Contributors/infrastructure/deploy.bicep>
[infrastructure]: <https://github.com/Azure/CCOInsights/blob/main/dashboards/GitHubDashboard-Contributors/infrastructure>
[src]: <https://github.com/Azure/CCOInsights/blob/main/dashboards/GitHubDashboard-Contributors/src>
[GitHubDailySyncfolder]: <https://github.com/Azure/CCOInsights/blob/main/dashboards/GitHubDashboard-Contributors/src/GitHubContributions/GitHubDailySync>
[WorkflowsFolder]: <https://github.com/Azure/CCOInsights/tree/main/.github/workflows>
[GitHubContributionsDashboard]: <https://github.com/Azure/CCOInsights/blob/main/dashboards/GitHubDashboard-Contributors/GitHubContributions%20v1.1.pbit>