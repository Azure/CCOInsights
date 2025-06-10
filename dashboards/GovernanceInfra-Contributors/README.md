# GovernanceInfra-Contributors Bicep Template

This Bicep template provisions the core infrastructure for the CCO Insights Governance and Infrastructure Contributors solution in Azure. It deploys the following resources:

- App Service Plan
- Azure Storage Account
- Azure Function App (with managed identity)
- Log Analytics Workspace
- Application Insights
- Data Lake Storage Account (with hierarchical namespace)
- Blob Containers for data organization
- Role Assignments for secure access

## Parameters

| Name      | Type   | Description                                      | Default                |
|-----------|--------|--------------------------------------------------|------------------------|
| name      | string | Base name to be used in all resources            | (empty)                |
| dlsname   | string | Name of the datalake account                     | (empty)                |
| location  | string | Location where resources should be deployed      | resourceGroup().location |

## Modules and Resources

| Resource/Module                | Type/Module Path                                                      | Purpose/Features                                                                 | Version   |
|------------------------------- |-----------------------------------------------------------------------|----------------------------------------------------------------------------------|-----------|
| **App Service Plan**           | `br/public:avm/res/web/serverfarm`                                    | Hosts the Azure Function App. SKU: B1 (Basic). Includes versioning tags.         | 0.4.1     |
| **Storage Account**            | `br/public:avm/res/storage/storage-account`                           | General storage for the solution. SKU: Standard_LRS.                             | 0.20.0    |
| **Azure Function App**         | `br/public:avm/res/web/site`                                          | Backend logic. Managed identity, .NET 8 isolated, App Insights, CORS for portal. | 0.16.0    |
| **Log Analytics Workspace**    | `br/public:avm/res/operational-insights/workspace`                    | Centralized logging and monitoring.                                              | 0.9.1     |
| **Application Insights**       | `br/public:avm/res/insights/component`                                | Application performance monitoring. Linked to Log Analytics Workspace.            | 0.6.0     |
| **Data Lake Storage Account**  | `br/public:avm/res/storage/storage-account`                           | Analytics storage. Hierarchical namespace, public blob access, network ACLs.      | 0.20.0    |
| **Blob Containers**            | `Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01`| Organizes data by resource type. Public (Container level) access.                 | 2023-01-01|
| **Role Assignments**           | `br/public:avm/ptn/authorization/resource-role-assignment`            | Grants Function App MI Contributor and Storage Blob Data Contributor roles.        | 0.1.2     |

## Outputs

| Name                | Type   | Description                       |
|---------------------|--------|-----------------------------------|
| dataLakeStorageName | string | Name of the Data Lake Storage     |

## Usage

Deploy this template using Azure CLI:

```sh
az deployment group create \
  --resource-group <your-rg> \
  --template-file  \
  --parameters name=<base-name> dlsname=<datalake-name>
```