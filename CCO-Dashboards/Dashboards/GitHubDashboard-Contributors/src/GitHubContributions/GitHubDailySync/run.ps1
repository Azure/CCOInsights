# Input bindings are passed in via param block.
param($Timer)

Import-Module Common
Get-Repository
Get-Forks -DailyRefresh
Get-Clones -DailyRefresh
$users = Get-OpenPullRequests -DailyRefresh
if ($users.Count -gt 0) {
    Get-Contributors -users $users
}
$pullRequestsNumbers = Get-ClosedPullRequests -DailyRefresh
Get-Stargazers
Get-Traffic
Get-Issues -DailyRefresh
Get-Releases