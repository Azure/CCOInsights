using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

Import-Module Common
Get-Repository
Get-Forks
Get-Clones
$users = Get-OpenPullRequests
$pullRequestsNumbers = Get-ClosedPullRequests
Get-Stargazers
Get-Contributors -users $users
Get-Traffic
Get-Issues
Get-Releases
Get-Secrets