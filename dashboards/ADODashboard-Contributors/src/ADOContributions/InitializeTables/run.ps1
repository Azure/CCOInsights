using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

Import-Module Common
$projectNames = Get-Project
$repositories = Get-Repository -projectNames $projectNames
$repositories | ForEach-Object {
    Get-OpenPullRequests -projectName $_.projectName -repositoryId $_.id
    Get-ClosedPullRequests -projectName $_.projectName -repositoryId $_.id
    Get-Commits -projectName $_.projectName -repositoryId $_.id
    Get-Branches -projectName $_.projectName -repositoryId $_.id
}
Get-Wikis -projectNames $projectNames