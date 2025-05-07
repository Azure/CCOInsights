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

### Updating

If you have forked this repository and the original repository has been updated, you can synchronize your fork to get the latest changes. Follow these steps:

1. Open a terminal and navigate to your local repository directory.
2. Add the original repository as a remote if you haven't already:
   ```bash
   git remote add upstream https://github.com/Azure/CCOInsights.git
   ```
3. Fetch the latest changes from the original repository:
   ```bash
   git fetch upstream
   ```
4. Merge the changes into your local `main` branch:
   ```bash
   git checkout main
   git merge upstream/main
   ```
5. Push the updated `main` branch to your forked repository:
   ```bash
   git push origin main
   ```

You have now synchronized your fork with the original repository. You can redeploy the updated code by following the deployment steps outlined above.

### Updating from a branch

If the original repository has updates in a specific branch (e.g., `feature/EarlyAdopters_Backend`), you can synchronize your fork and merge the changes into your `main` branch. Follow these steps:

1. Open a terminal and navigate to your local repository directory.
2. Add the original repository as a remote if you haven't already:
   ```bash
   git remote add upstream https://github.com/Azure/CCOInsights.git
   ```
3. Fetch the latest changes from the original repository:
   ```bash
   git fetch upstream
   ```
4. Check out the branch with the updates (e.g., `feature/EarlyAdopters_Backend`):
   ```bash
   git checkout -b feature/EarlyAdopters_Backend upstream/feature/EarlyAdopters_Backend
   ```
5. Merge the changes into your `main` branch:
   ```bash
   git checkout main
   git merge feature/EarlyAdopters_Backend
   ```
6. Resolve any merge conflicts if they arise, then commit the changes:
   ```bash
   git add .
   git commit -m "Merged updates from feature/EarlyAdopters_Backend"
   ```
7. Push the updated `main` branch to your forked repository:
   ```bash
   git push origin main
   ```

You have now synchronized your fork with the original repository and merged the updates from the branch into your `main` branch. You can redeploy the updated code by following the deployment steps outlined above.

## Conclusion

You have successfully deployed the backend solution in your subscription. If you encounter any issues or have any questions, please refer to the documentation or reach out to the support team.
