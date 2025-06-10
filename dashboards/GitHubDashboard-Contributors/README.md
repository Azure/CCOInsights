# GitHubDashboard-Contributors Bicep Template

This Bicep template provisions the infrastructure for the CCO Insights GitHub Dashboard Contributors solution in Azure. It deploys the following resources:

- App Service Plan
- Log Analytics Workspace
- Application Insights
- Storage Account
- Azure Function App (with managed identity)
- Role Assignment for secure access

## Parameters

| Name      | Type   | Description                                      | Default                |
|-----------|--------|--------------------------------------------------|------------------------|
| name      | string | Base name to be used in all resources            |                   |
| staname   | string | Name of the storage account                      |         |
| location  | string | Location where resources should be deployed      | resourceGroup().location |

## Modules and Resources

| Resource/Module                | Type/Module Path                                                      | Purpose/Features                                                                 | Version   |
|------------------------------- |-----------------------------------------------------------------------|----------------------------------------------------------------------------------|-----------|
| **App Service Plan**           | `br/public:avm/res/web/serverfarm`                                    | Hosts the Azure Function App. SKU: S1 (Standard). Includes versioning tags.      | 0.4.1     |
| **Log Analytics Workspace**    | `br/public:avm/res/operational-insights/workspace`                    | Centralized logging and monitoring. Data retention: 120 days.                    | 0.9.1     |
| **Application Insights**       | `br/public:avm/res/insights/component`                                | Application performance monitoring. Linked to Log Analytics Workspace.            | 0.6.0     |
| **Storage Account**            | `br/public:avm/res/storage/storage-account`                           | General storage for the solution. SKU: Standard_LRS. Public blob access allowed.  | 0.20.0    |
| **Azure Function App**         | `br/public:avm/res/web/site`                                          | Backend logic. Managed identity, PowerShell 7, App Insights, storage integration. | 0.16.0    |
| **Role Assignment**            | `br/public:avm/ptn/authorization/resource-role-assignment`            | Grants Function App MI Contributor role on the storage account.                   | 0.1.2     |

## Outputs

This template does not define explicit outputs, but all deployed resources are named using the provided parameters for easy discovery.

## Function app source code

The src folder contains the Azure Functions implementation for GitHub contributions data processing. Here is an overview of its structure and contents:
```plaintext
src/
├── local.settings.json
└── GitHubContributions/
    ├── host.json
    ├── profile.ps1
    ├── requirements.psd1
    ├── GitHubDailySync/
    │   ├── function.json
    │   └── run.ps1
    ├── InitializeTables/
    │   ├── function.json
    │   └── run.ps1
    └── Modules/
        └── Common/
            └── Common.psm1
```
## File/Folder Descriptions

- **local.settings.json**
  Contains local development settings for Azure Functions, such as connection strings, environment variables, and other configuration values used when running the function app locally.

- **GitHubContributions/**
  Root directory for the Azure Functions app.

  - **host.json**
    Global configuration file for the Azure Functions host. Controls settings like logging, extension bundles, and function runtime behaviors.

  - **profile.ps1**
    PowerShell profile script that is loaded for every function execution. Commonly used to import shared modules or perform initialization tasks required by all functions.

  - **requirements.psd1**
    Specifies PowerShell module dependencies that must be installed for the function app to run. Ensures all required modules are available in the function environment.

  - **GitHubDailySync/**
    Contains the `GitHubDailySync` function, responsible for synchronizing daily GitHub contributions data.
    - **function.json**: Defines the trigger (e.g., timer or HTTP) and input/output bindings for the function.
    - **run.ps1**: Implements the logic to fetch and process daily GitHub contributions, storing results as needed.

  - **InitializeTables/**
    Contains the `InitializeTables` function, used to set up required storage tables or other resources.
    - **function.json**: Defines the trigger (typically HTTP) and bindings for the initialization function.
    - **run.ps1**: PowerShell script that creates or initializes necessary Azure Storage tables or other resources.

  - **Modules/Common/Common.psm1**
    PowerShell module containing common helper functions or shared logic. This module is imported by other scripts to promote code reuse and maintainability.

## Common.psm1: Function Overview and API Endpoints

The `Common.psm1` PowerShell module provides a set of helper functions for extracting and storing GitHub repository analytics and metadata into Azure Table Storage. Each function interacts with the GitHub REST API to fetch specific data and persists it in Azure Storage tables for reporting and dashboarding.

### Summary Table

| Function Name              | Purpose                                                      | GitHub API Endpoint(s) Used                                   |
|----------------------------|-------------------------------------------------------------|---------------------------------------------------------------|
| Get-Repository             | Fetches repository metadata                                 | `/repos/{owner}/{repo}`                                       |
| Get-Forks                  | Fetches all forks (and 2nd-level forks)                     | `/repos/{owner}/{repo}/forks`                                 |
| Get-Clones                 | Fetches repository clone traffic statistics                  | `/repos/{owner}/{repo}/traffic/clones`                        |
| Get-OpenPullRequests       | Fetches all open pull requests and their stats               | `/repos/{owner}/{repo}/pulls`, `/repos/{owner}/{repo}/pulls/{number}` |
| Get-ClosedPullRequests     | Fetches all closed pull requests and their stats             | `/repos/{owner}/{repo}/pulls?state=closed`, `/repos/{owner}/{repo}/pulls/{number}` |
| Get-Stargazers             | Fetches all stargazers                                      | `/repos/{owner}/{repo}/stargazers`                            |
| Get-Contributors           | Fetches user details for a list of contributors              | `/users/{username}`                                           |
| Get-Traffic                | Fetches repository view traffic statistics                   | `/repos/{owner}/{repo}/traffic/views`                         |
| Get-Issues                 | Fetches all issues (excluding pull requests)                 | `/repos/{owner}/{repo}/issues?state=all`                      |
| Get-Releases               | Fetches all releases                                        | `/repos/{owner}/{repo}/releases`                              |

---

### Function Explanations

- **Get-Repository**
  Retrieves metadata about the repository (owner, id, name, forks, watchers, stargazers, size, open issues, creation date) from the GitHub API and stores it in the "Repository" Azure Table.

  [GitHub API Reference: Get a repository](https://docs.github.com/en/rest/repos/repos#get-a-repository)

- **Get-Forks**
  Retrieves all forks of the repository (including second-level forks), optionally filtering for daily refresh. Stores fork details (id, full name, owner, created date) in the "Forks" Azure Table.

  [GitHub API Reference: List forks](https://docs.github.com/en/rest/repos/forks#list-forks)

- **Get-Clones**
  Retrieves clone traffic statistics (date, count) for the repository, optionally filtering for daily refresh. Stores results in the "Clones" Azure Table.

  [GitHub API Reference: Get repository clones](https://docs.github.com/en/rest/metrics/traffic#get-repository-clones)

- **Get-OpenPullRequests**
  Retrieves all open pull requests, fetches detailed stats for each (additions, deletions, changed files), and stores them in the "OpenPullRequests" Azure Table. Optionally filters for daily refresh.

  [GitHub API Reference: List pull requests](https://docs.github.com/en/rest/pulls/pulls#list-pull-requests)
  [GitHub API Reference: Get a pull request](https://docs.github.com/en/rest/pulls/pulls#get-a-pull-request)

- **Get-ClosedPullRequests**
  Retrieves all closed pull requests, fetches detailed stats for each, and stores them in the "ClosedPullRequests" Azure Table. Optionally filters for daily refresh.

  [GitHub API Reference: List pull requests](https://docs.github.com/en/rest/pulls/pulls#list-pull-requests)
  [GitHub API Reference: Get a pull request](https://docs.github.com/en/rest/pulls/pulls#get-a-pull-request)

- **Get-Stargazers**
  Retrieves all users who have starred the repository and stores their details (login, id, avatar, url, type) in the "Stargazers" Azure Table.

  [GitHub API Reference: List stargazers](https://docs.github.com/en/rest/activity/starring#list-stargazers)

- **Get-Contributors**
  For a provided list of usernames, fetches user details from GitHub and stores them in the "Contributors" Azure Table.

  [GitHub API Reference: Get a user](https://docs.github.com/en/rest/users/users#get-a-user)

- **Get-Traffic**
  Retrieves view traffic statistics (date, uniques, count) for the repository and stores them in the "Views" Azure Table.

  [GitHub API Reference: Get page views](https://docs.github.com/en/rest/metrics/traffic#get-page-views)

- **Get-Issues**
  Retrieves all issues (excluding pull requests), including metadata such as title, user, state, assignee, milestone, and timestamps, and stores them in the "Issues" Azure Table. Optionally filters for daily refresh.

  [GitHub API Reference: List repository issues](https://docs.github.com/en/rest/issues/issues#list-repository-issues)

- **Get-Releases**
  Retrieves all releases for the repository (tag name and published date) and stores them in the "Releases" Azure Table.

  [GitHub API Reference: List releases](https://docs.github.com/en/rest/releases/releases#list-releases)
```