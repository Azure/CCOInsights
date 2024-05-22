# Deployment

This guide will walk you through the steps to deploy the backend solution in your subscription.

## Prerequisites

Before you begin, make sure you have the following:

- Azure subscription
- PowerShell installed

## Steps

1. Fork the repository:
2. Navigate to the repository directory:
3. Run the `deploy/create-spn.ps1` script to create a Service Principal. It will retrieve the Service Principal credentials in a JSON format. Save the JSON output as you will need it later.
4. Create a GitHub secret with the Service Principal credentials:
   - Go to https://github.com/{user}/CCOInsights/settings/secrets/actions.
   - Click on `New repository secret`.
   - Add `AZURE_CREDENTIALS` as the secret name.
   - Paste the Service Principal credentials JSON as the secret value.
5. Deploy the infrastructure and the code:
   - Navigate to the `Actions` tab in the repository and select the `Deployment Workflow` (https://github.com/{user}/CCOInsights/actions/workflows/deployment.yml).
   - Click on Run workflow and fill in the required parameters:
     - **Location (Required)**: The Azure region where you want to deploy the resources.
     - **Resource Group Name (Required)**: The name of the resource group where the resources will be deployed. 
     - Data Lake Storage Account Name: The name of the Data Lake Storage account.
     - Base deployment name: The base name for the resources that will be deployed.
6. Monitor the deployment progress in the Actions tab.
7. Once the deployment is complete, execute the `deploy/grant-permissions.ps1` script to grant the necessary permissions to the Service Principal.
8. The backend solution is now deployed and configured in your subscription. Reboot the Azure Function App to start the data collection process or wait to the next execution.

## Conclusion

You have successfully deployed the backend solution in your subscription. If you encounter any issues or have any questions, please refer to the documentation or reach out to the support team.
