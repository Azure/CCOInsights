using namespace System.Net

# Input bindings are passed in via param block.
param($Timer)

Import-Module Common
$projectNames = Get-Project
$repositories = Get-Repository -projectNames $projectNames
$repositories | ForEach-Object {
    Get-OpenPullRequests -projectName $_.projectName -repositoryId $_.id -DailyRefresh
    Get-ClosedPullRequests -projectName $_.projectName -repositoryId $_.id -DailyRefresh
    Get-Commits -projectName $_.projectName -repositoryId $_.id
    Get-Branches -projectName $_.projectName -repositoryId $_.id
}
$wikis = Get-Wikis -projectNames $projectNames
$wikis | ForEach-Object {
    Get-WikiStats -projectName $_.projectName -projectId $_.projectId -wikiId $_.wikiId
}