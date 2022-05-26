Function Get-Project {

    $organization = $env:organization
    $pat = $env:pat

    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "Project"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable -Name $partitionKey -Context $ctx).CloudTable

    Write-Host "Fetching projects..."
    $projectsBaseUrl = "https://dev.azure.com/$($organization)/_apis/projects?api-version=6.0"
    $encodedToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes((":{0}" -f $pat)))
    $header = @{authorization = "Basic $encodedToken" }

    $projects = Invoke-RestMethod -Uri $projectsBaseUrl -Method Get -ContentType "application/json" -Headers $header
    $dashboardProjects = @()
    $projects.value | ForEach-Object {
        $count += 1
        $projectsTable = @{
            id             = $_.id
            name           = $_.name
            url            = $_.url
            state          = $_.state
            revision       = $_.revision
            visibility     = $_.visibility
            lastUpdateTime = $_.lastUpdateTime
        }
        Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $_.id -property $projectsTable -UpdateExisting | Out-Null
        $dashboardProjects += $projectsTable
    }
    Write-Host "$($count) projects successfully loaded"
    $return = $dashboardProjects.name | Sort-Object -Unique
    return $return
}

Function Get-Repository {
    [CmdletBinding()]
    param (
        [Parameter()]
        [array]$projectNames
    )

    $organization = $env:organization
    $pat = $env:pat

    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "Repository"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable -Name $partitionKey -Context $ctx).CloudTable

    Write-Host "Fetching repositories..."
    $dashboardRepositories = @()
    foreach ($projectName in $projectNames) {

        $repositoryBaseUrl = "https://dev.azure.com/$($organization)/$($projectName)/_apis/git/repositories?api-version=7.1-preview.1"
        $encodedToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes((":{0}" -f $pat)))
        $header = @{authorization = "Basic $encodedToken" }

        $repositories = Invoke-RestMethod -Uri $repositoryBaseUrl -Method Get -ContentType "application/json" -Headers $header
        $repositories.value | ForEach-Object {
            if ((![String]::IsNullOrEmpty($_.id)) -and (!$_.isDisabled) ) {
                $repositoryTable = @{
                    id          = $_.id
                    name        = $_.name
                    projectName = $projectName
                    projectId   = $_.project.id
                    url         = $_.webUrl
                    disabled    = $_.isDisabled
                }
                Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $_.id -property $repositoryTable -UpdateExisting | Out-Null
                $dashboardRepositories += $repositoryTable
            }
        }
    }
    Write-Host "Repositories successfully loaded"
    $output = @()
    $dashboardRepositories | ForEach-Object {
        $output += @{
            id          = $_.id
            projectName = $_.projectName            
        }
    }
    return $output
}

Function Get-OpenPullRequests {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Switch]$DailyRefresh,
        [Parameter()]
        [string]$projectName,
        [Parameter()]
        [string]$repositoryId
    )
    
    $organization = $env:organization
    $pat = $env:pat

    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "OpenPullRequests"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable -Name $partitionKey -Context $ctx).CloudTable

    Write-Host "Fetching open pull requests for project $($projectName) and repository $($repositoryId)..."
    $openPullRequestsBaseUrl = "https://dev.azure.com/$($organization)/$($projectName)/_apis/git/repositories/$($repositoryId)/pullrequests?api-version=7.1-preview.1"
    $encodedToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes((":{0}" -f $pat)))
    $header = @{authorization = "Basic $encodedToken" }

    $openPullRequests = Invoke-RestMethod -Uri $openPullRequestsBaseUrl -Method Get -ContentType "application/json" -Headers $header -ErrorAction SilentlyContinue
    if ($DailyRefresh) {
        $openPullRequests = $openPullRequests | Where-Object { ($_.value.creationDate -gt (Get-Date -Hour 0 -Minute 00 -Second 00).AddDays(-1)) -or ($_.value.closedDate -gt (Get-Date -Hour 0 -Minute 00 -Second 00).AddDays(-1)) }
    }
    $dashboardopenPullRequests = @()

    if (![String]::IsNullOrEmpty($openPullRequests)) {
        $openPullRequests.value | ForEach-Object {
            $additions = 0
            $deletions = 0
            $changedFiles = 0
            $commitsUrl = "https://dev.azure.com/$($organization)/$($projectName)/_apis/git/repositories/$($repositoryId)/pullRequests/$($_.pullRequestId)/commits?api-version=6.0"
            try {
                $commits = Invoke-RestMethod -Uri $commitsUrl -Method Get -ContentType "application/json" -Headers $header
                foreach ($commit in $commits.value) {
                    $commitInfo = Invoke-RestMethod -Uri $commit.url -Method Get -ContentType "application/json" -Headers $header
                    $stats = Invoke-RestMethod -Uri $commitInfo._links.changes.href -Method Get -ContentType "application/json" -Headers $header
                    $additions += ($stats.changes | Where-Object { $_.changeType -eq 'add' }).Count
                    $deletions += ($stats.changes | Where-Object { $_.changeType -eq 'delete' }).Count
                    $changedFiles += ($stats.changes | Where-Object { $_.changeType -eq 'edit' }).Count
                }
                $openPullRequest = @{
                    projectName  = $projectName
                    repositoryId = $repositoryId
                    id           = $_.pullRequestId
                    user         = $_.createdBy.uniqueName
                    state        = $_.status
                    title        = $_.title
                    createdDate  = $_.creationDate
                    additions    = $additions
                    deletions    = $deletions
                    changedFiles = $changedFiles
                }
                Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey "$repositoryId-$($_.pullRequestId)" -property $openPullRequest -UpdateExisting | Out-Null
                $dashboardopenPullRequests += $openPullRequest
            }
            catch [System.Net.WebException] {
                # HTTP error, grab response from exception
                $HTTP_Response = $_.Exception.Response
                $HTTP_Status = [int]$HTTP_Response.StatusCode
                Write-Verbose "$HTTP_Status error thrown"
            }

        }
    }
    Write-Host "$($dashboardopenPullRequests.Count) Open pull requests successfully loaded"
}

Function Get-ClosedPullRequests {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Switch]$DailyRefresh,
        [Parameter()]
        [string]$projectName,
        [Parameter()]
        [string]$repositoryId
    )
    
    $organization = $env:organization
    $pat = $env:pat

    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "ClosedPullRequests"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable -Name $partitionKey -Context $ctx).CloudTable

    Write-Host "Fetching closed pull requests..."
    $closedPullRequestsBaseUrl = "https://dev.azure.com/$($organization)/$($projectName)/_apis/git/repositories/$($repositoryId)/pullrequests?searchCriteria.status=completed&api-version=7.1-preview.1"
    $encodedToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes((":{0}" -f $pat)))
    $header = @{authorization = "Basic $encodedToken" }

    $closedPullRequests = Invoke-RestMethod -Uri $closedPullRequestsBaseUrl -Method Get -ContentType "application/json" -Headers $header
    if ($DailyRefresh) {
        $closedPullRequests = $closedPullRequests | Where-Object { ($_.value.closedDate -gt (Get-Date -Hour 0 -Minute 00 -Second 00).AddDays(-1)) }
    }
    $dashboardclosedPullRequests = @()

    if (![String]::IsNullOrEmpty($closedPullRequests)) {
        $closedPullRequests.value | ForEach-Object {
            $additions = 0
            $deletions = 0
            $changedFiles = 0
            $commitsUrl = "https://dev.azure.com/$($organization)/$($projectName)/_apis/git/repositories/$($repositoryId)/pullRequests/$($_.pullRequestId)/commits?api-version=6.0"
            try {
                $commits = Invoke-RestMethod -Uri $commitsUrl -Method Get -ContentType "application/json" -Headers $header
                foreach ($commit in $commits.value) {
                    $commitInfo = Invoke-RestMethod -Uri $commit.url -Method Get -ContentType "application/json" -Headers $header
                    $stats = Invoke-RestMethod -Uri $commitInfo._links.changes.href -Method Get -ContentType "application/json" -Headers $header
                    $additions += ($stats.changes | Where-Object { $_.changeType -eq 'add' }).Count
                    $deletions += ($stats.changes | Where-Object { $_.changeType -eq 'delete' }).Count
                    $changedFiles += ($stats.changes | Where-Object { $_.changeType -eq 'edit' }).Count
                }
                $closedPullRequest = @{
                    projectName  = $projectName
                    repositoryId = $repositoryId
                    id           = $_.pullRequestId
                    user         = $_.createdBy.uniqueName
                    state        = $_.status
                    title        = $_.title
                    createdDate  = $_.creationDate
                    additions    = $additions
                    deletions    = $deletions
                    changedFiles = $changedFiles
                }
                Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey "$repositoryId-$($_.pullRequestId)" -property $closedPullRequest -UpdateExisting | Out-Null
                $dashboardclosedPullRequests += $closedPullRequest
            }
            catch [System.Net.WebException] {
                # HTTP error, grab response from exception
                $HTTP_Response = $_.Exception.Response
                $HTTP_Status = [int]$HTTP_Response.StatusCode
                Write-Verbose "$HTTP_Status error thrown"
            }
        }
    }
    Write-Host "$($dashboardclosedPullRequests.Count) Closed pull requests successfully loaded"
    return $dashboardclosedPullRequests.number
}

Function Get-Commits {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Switch]$DailyRefresh,
        [Parameter()]
        [string]$projectName,
        [Parameter()]
        [string]$repositoryId
    )
    
    $organization = $env:organization
    $pat = $env:pat

    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "Commits"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable -Name $partitionKey -Context $ctx).CloudTable

    Write-Host "Fetching commits for project $($projectName) and repository $($repositoryId)..."
    $commitsBaseUrl = "https://dev.azure.com/$($organization)/$($projectName)/_apis/git/repositories/$($repositoryId)/commits?api-version=6.0"
    $encodedToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes((":{0}" -f $pat)))
    $header = @{authorization = "Basic $encodedToken" }

    $commits = Invoke-RestMethod -Uri $commitsBaseUrl -Method Get -ContentType "application/json" -Headers $header -ErrorAction SilentlyContinue
    if ($DailyRefresh) {
        $commits = $commits | Where-Object { ($_.value.committer.date -gt (Get-Date -Hour 0 -Minute 00 -Second 00).AddDays(-1)) }
    }
    $dashboardCommits = @()

    if (![String]::IsNullOrEmpty($commits)) {
        $commits.value | ForEach-Object {
            $commit = @{
                projectName  = $projectName
                repositoryId = $repositoryId
                id           = $_.commitId
                authorName   = $_.author.name
                authorEmail  = $_.author.email
                comment      = $_.comment
                data         = $_.committer.date
                additions    = $_.changeCounts.add
                deletions    = $_.changeCounts.edit
                changedFiles = $_.changeCounts.delete
            }
            Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $_.commitId -property $commit -UpdateExisting | Out-Null
            $dashboardCommits += $commit
        }
    }
    Write-Host "$($dashboardCommits.Count) commits successfully loaded"
}

Function Get-Branches {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Switch]$DailyRefresh,
        [Parameter()]
        [string]$projectName,
        [Parameter()]
        [string]$repositoryId
    )
    
    $organization = $env:organization
    $pat = $env:pat

    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "Branches"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable -Name $partitionKey -Context $ctx).CloudTable

    Write-Host "Fetching branches for project $($projectName) and repository $($repositoryId)..."
    $branchesBaseUrl = "https://dev.azure.com/$($organization)/$($projectName)/_apis/git/repositories/$($repositoryId)/refs?api-version=6.0"
    $encodedToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes((":{0}" -f $pat)))
    $header = @{authorization = "Basic $encodedToken" }

    $branches = Invoke-RestMethod -Uri $branchesBaseUrl -Method Get -ContentType "application/json" -Headers $header -ErrorAction SilentlyContinue
    $dashboardBranches = @()

    if (![String]::IsNullOrEmpty($branches)) {
        $branches.value | ForEach-Object {
            $branch = @{
                projectName  = $projectName
                repositoryId = $repositoryId
                objectId     = $_.objectId
                name         = $_.name
                creator      = $_.creator.displayName
                creatorEmail = $_.creator.uniqueName
            }
            Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $_.objectId -property $branch -UpdateExisting | Out-Null
            $dashboardBranches += $branch
        }
    }
    Write-Host "$($dashboardBranches.Count) commits successfully loaded"
}

Function Get-Wikis {
    [CmdletBinding()]
    param (
        [Parameter()]
        [array]$projectNames
    )
    
    $organization = $env:organization
    $pat = $env:pat

    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "Wikis"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable -Name $partitionKey -Context $ctx).CloudTable

    Write-Host "Fetching wikis..."
    $dashboardWikis = @()
    foreach ($projectName in $projectNames) {

        $wikisBaseUrl = ('https://dev.azure.com/{0}/{1}/_apis/wiki/wikis?api-version=6.0-preview.1' -f $Organization, $projectName)
        $encodedToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes((":{0}" -f $pat)))
        $header = @{authorization = "Basic $encodedToken" }

        $wikis = Invoke-RestMethod -Uri $wikisBaseUrl -Method Get -ContentType "application/json" -Headers $header
        $wikis.value | ForEach-Object {
            if (![String]::IsNullOrEmpty($_.id)) {
                $wikisTable = @{
                    id          = $_.id
                    name        = $_.name
                    projectName = $projectName
                    projectId   = $_.projectid
                }
                Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $_.id -property $wikisTable -UpdateExisting | Out-Null
                $dashboardWikis += $wikisTable
            }
        }
    }
    Write-Host "$($dashboardWikis.Count) wikis successfully loaded"
    $output = @()
    $dashboardWikis | ForEach-Object {
        $output += @{
            projectName = $_.projectName
            wikiId      = $_.id         
        }
    }
    return $output
}

Function Get-WikiStats {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$projectName,
        [Parameter()]
        [string]$wikiId
    )
    
    $organization = $env:organization
    $pat = $env:pat

    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "WikiStats"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable -Name $partitionKey -Context $ctx).CloudTable

    Write-Host "Fetching wiki statistics for project $($projectName) and wikiId $($wikiId)..."
    $dashboardWikiStats = @()
    $wikiStatsBaseUrl = ('https://dev.azure.com/{0}/{1}/_apis/wiki/wikis/{2}/pagesbatch?api-version=7.1-preview.1' -f $Organization, $projectName, $wikiId)
    $encodedToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes((":{0}" -f $pat)))
    $header = @{authorization = "Basic $encodedToken" }

    $TotalResult = @()
    $body = @{
        "pageViewsForDays" = 30
    } | ConvertTo-Json

    $params = @{
        'Uri'         = $wikiStatsBaseUrl
        'Headers'     = $header
        'Method'      = 'POST'
        'Body'        = $body
        'ContentType' = 'application/json; charset=utf-8'
    }

    $Result = Invoke-WebRequest @params
    $TotalResult += $Result.Content

    While ($Result.Headers.'X-MS-ContinuationToken') {
        $body = @{
            "pageViewsForDays"  = 30
            "continuationToken" = $($Result.Headers.'X-MS-ContinuationToken')
        } | ConvertTo-Json

        $params = @{
            'Uri'         = $wikiStatsBaseUrl
            'Headers'     = $Header
            'Method'      = 'POST'
            'Body'        = $body
            'ContentType' = 'application/json; charset=utf-8'
        }

        $Result = Invoke-WebRequest @params
        $TotalResult += $Result.Content
    }

    ($TotalResult | ConvertFrom-Json).value | ForEach-Object {
        if (![String]::IsNullOrEmpty($_.id)) {
            $wikiStatsTable = @{
                id               = $_.id
                path             = $_.path
                projectName      = $projectName
                visits           = [int]($_.viewStats | measure-object -Property count -Sum).sum
                pageViewsForDays = 30
            }
            Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $(new-guid).guid -property $wikiStatsTable | Out-Null
            $dashboardWikiStats += $wikiStatsTable
        }        
    }
}