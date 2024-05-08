Write-Host "Starting script..."

$subscriptionId = (az account show --query 'id' -o tsv)
Write-Host "Retrieved subscription ID: $subscriptionId"

$jsonResponse = az ad sp create-for-rbac --role="Owner" --name "ccoinsightsdeployment" --scopes="/subscriptions/$subscriptionId" --json-auth
Write-Host "AZURE_CREDENTIALS:"
Write-Host ($jsonResponse | ConvertFrom-Json | ConvertTo-Json) -ForegroundColor Yellow
Write-Host "Please copy the above output and save it in a secure location."
Write-Host "Create a new secret in the GitHub repository and paste the above output as the value."
Write-Host "Script completed."
