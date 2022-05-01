[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)][String]$ResourceGroup,
    [Parameter(Mandatory = $true)][String]$FunctionAppName
)

# Create a Zip with the publish result
$publishFolder = "dashboards/GitHubDashboard-Contributors/src/GitHubContributions"
$publishZip = "publish.zip"
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::CreateFromDirectory($publishFolder, $publishZip)

$AppSettings = Get-Content "dashboards/GitHubDashboard-Contributors/src/local.settings.json"
# Deploy zipped package
if (![string]::IsNullOrEmpty($AppSettings)) {
    $settings = ($AppSettings | ConvertFrom-Json)
    $settings.Values | Get-Member -MemberType NoteProperty | ForEach-Object {
        $key = $_.Name
        $value = $settings.Values.$key
        $AppSettingsContent = "$key=$value".Trim()
        az functionapp config appsettings set -n $FunctionAppName -g $ResourceGroup --settings $AppSettingsContent -o none
    }
}
az functionapp deployment source config-zip -g $ResourceGroup -n $FunctionAppName --src $publishZip