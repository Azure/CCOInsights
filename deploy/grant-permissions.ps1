Write-Host "Starting script..."

Install-Module AzureAD

$GraphAppId = "00000003-0000-0000-c000-000000000000"
$PermissionNames = "Application.Read.All", "Group.Read.All", "User.Read.All"

$tenantId = (az account show --query 'tenantId' -o tsv)
Write-Host "Retrieved tenant ID: $tenantId"
Connect-AzureAD -TenantId $tenantId

$fa = Get-AzureADServicePrincipal -All 1 | Where-Object { $_.DisplayName -like '*cco-fa' }
$GraphServicePrincipal = Get-AzureADServicePrincipal -Filter "appId eq '$GraphAppId'"

$AppRoles = $GraphServicePrincipal.AppRoles | Where-Object {$PermissionNames -contains $_.Value -and $_.AllowedMemberTypes -contains "Application"}

foreach ($AppRole in $AppRoles) {
    Write-Host "Granting permission $($AppRole.Value) to $($fa.DisplayName)"
    New-AzureAdServiceAppRoleAssignment -ObjectId $fa.ObjectId -PrincipalId $fa.ObjectId -ResourceId $GraphServicePrincipal.ObjectId -Id $AppRole.Id
    Write-Host "Permission granted."
}

Write-Host "Script completed."