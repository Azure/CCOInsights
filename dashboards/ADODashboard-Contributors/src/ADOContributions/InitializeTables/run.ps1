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
$wikis = Get-Wikis -projectNames $projectNames

# Clear existing WikiStats Azure Storage Table
$ctx = $storageAccount.Context
$partitionKey = "WikiStats"
New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
$table = (Get-AzStorageTable -Name $partitionKey -Context $ctx).CloudTable
Get-AzTableRow -table $table | Remove-AzTableRow -table $table | Out-Null
# Get wiki stats
$wikis | ForEach-Object {
    $wikiStats = Get-WikiStats -projectName $_.projectName -projectId $_.projectId -wikiId $_.wikiId
}
# $wikiStats | ForEach-Object {
#     Get-WikiPage -projectName $_.projectName -projectId $_.projectId -Id $_.Id -wikiId $_.wikiId
# }