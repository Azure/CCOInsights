using namespace System.Net



function get-bicepRepos {
    # Define the URL of the CSV file
    $csvUrl = "https://azure.github.io/Azure-Verified-Modules/module-indexes/BicepResourceModules.csv"

    # Use Invoke-WebRequest to download the CSV file
    $response = Invoke-WebRequest -Uri $csvUrl

    # Check if the request was successful
    if ($response.StatusCode -eq 200) {
        # Save the content of the response to a temporary file
        $tempFile = [System.IO.Path]::GetTempFileName() + ".csv"
        $response.Content | Set-Content -Path $tempFile -Force
        # Import the CSV data into a variable
        $csvData = Import-Csv -Path $tempFile
        # Display the data:
        #$csvData | Format-Table
        # Clean up the temporary file when you're done
        Remove-Item $tempFile -Force
    } else {
        Write-Host "Failed to download CSV file. Status code: $($response.StatusCode)"
    }

    $repolist = @()

    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "CSVBicepReposData"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable –Name $partitionKey –Context $ctx).CloudTable

    foreach($repo in $csvData){
        #write-host "Fetching repository... $($repo.RepoURL)"
        # Define a regular expression pattern to match the desired part of the URL
        $pattern = "github\.com\/([^/]+\/[^/]+)"
        # Use the -match operator to find matches in the URL
        if ($($repo.RepoURL) -match $pattern) {
            # $matches[1] contains the matched portion of the URL
            $result = $matches[1]
            #Write-Host $result
            if (($repo.ModuleStatus -eq "Module Available :green_circle:") -or ($repo.ModuleStatus -eq "Module Orphaned :eyes:")) {
                $repolist += $result
            }
            else{
                #Write-Host "Module not available"
            }
        } else {
            Write-Host "No match found."
        }
        #Add all CSV repo data to a storage table
        $BicepRepo = @{
            ProviderNamespace	            =	$repo.ProviderNamespace
            ResourceType	                =	$repo.ResourceType
            ModuleDisplayName	            =	$repo.ModuleDisplayName
            ModuleName	                    =	$repo.ModuleName
            ModuleStatus	                =	$repo.ModuleStatus
            RepoURL	                        =	$repo.RepoURL
            PublicRegistryReference	        =	$repo.PublicRegistryReference
            TelemetryIdPrefix	            =	$repo.TelemetryIdPrefix
            PrimaryModuleOwnerGHHandle	    =	$repo.PrimaryModuleOwnerGHHandle
            PrimaryModuleOwnerDisplayName	=	$repo.PrimaryModuleOwnerDisplayName
            SecondaryModuleOwnerGHHandle	=	$repo.SecondaryModuleOwnerGHHandle
            SecondaryModuleOwnerDisplayName	=	$repo.SecondaryModuleOwnerDisplayName
            ModuleOwnersGHTeam	            =	$repo.ModuleOwnersGHTeam
            ModuleContributorsGHTeam	    =	$repo.ModuleContributorsGHTeam
            Description	                    =	$repo.Description
            Comments	                    =	$repo.Comments
        }
        Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $repo.TelemetryIdPrefix -property $BicepRepo -UpdateExisting | Out-Null
    }
    $AVMRepo = "Azure/Azure-Verified-Modules"
    $repolist += $AVMRepo
    #$repolist_final = ($repolist | get-unique)
    return $repolist| get-unique
}

Function Get-TFRepos{
    $terraformCsvUrl = "https://azure.github.io/Azure-Verified-Modules/module-indexes/TerraformResourceModules.csv"

    # Use Invoke-WebRequest to download the CSV file
    $response = Invoke-WebRequest -Uri $terraformCsvUrl

    # Check if the request was successful
    if ($response.StatusCode -eq 200) {
        # Save the content of the response to a temporary file
        $tempFile = [System.IO.Path]::GetTempFileName() + ".csv"
        $response.Content | Set-Content -Path $tempFile -Force

        # Import the CSV data into a variable
        $csvData = Import-Csv -Path $tempFile

        # Display the data:
        #$csvData | Format-Table

        # Clean up the temporary file when you're done
        Remove-Item $tempFile -Force
    } else {
        Write-Host "Failed to download CSV file. Status code: $($response.StatusCode)"
    }

    $repolist = @()

    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "CSVTFReposData"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable –Name $partitionKey –Context $ctx).CloudTable

    foreach($repo in $csvData){
        #write-host "Fetching repository... $($repo.RepoURL)"
        $pattern = "github\.com\/(.+)$"
        # Use the -match operator to find matches in the URL
        if ($($repo.RepoURL) -match $pattern) {
            # $matches[1] contains the matched portion of the URL
            $result = $matches[1]
            #Write-Host $result
            if (($repo.ModuleStatus -eq "Module Available :green_circle:") -or ($repo.ModuleStatus -eq "Module Orphaned :eyes:")) {
                $repolist += $result
            }
            else{
                #Write-Host "Module not available"
            }
        } else {
            Write-Host "No match found."
        }
        # Add all CSV repo data to a storage table
        $TFRepo = @{
            ProviderNamespace	            =	$repo.ProviderNamespace
            ResourceType	                =	$repo.ResourceType
            ModuleDisplayName	            =	$repo.ModuleDisplayName
            ModuleName	                    =	$repo.ModuleName
            ModuleStatus	                =	$repo.ModuleStatus
            RepoURL	                        =	$repo.RepoURL
            PublicRegistryReference	        =	$repo.PublicRegistryReference
            TelemetryIdPrefix	            =	$repo.TelemetryIdPrefix
            PrimaryModuleOwnerGHHandle	    =	$repo.PrimaryModuleOwnerGHHandle
            PrimaryModuleOwnerDisplayName	=	$repo.PrimaryModuleOwnerDisplayName
            SecondaryModuleOwnerGHHandle	=	$repo.SecondaryModuleOwnerGHHandle
            SecondaryModuleOwnerDisplayName	=	$repo.SecondaryModuleOwnerDisplayName
            ModuleOwnersGHTeam	            =	$repo.ModuleOwnersGHTeam
            ModuleContributorsGHTeam	    =	$repo.ModuleContributorsGHTeam
            Description	                    =	$repo.Description
            Comments	                    =	$repo.Comments
        }
        Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $repo.TelemetryIdPrefix -property $TFRepo -UpdateExisting | Out-Null
    }
    $TFRepolist = $repolist | get-unique
    return $TFRepolist
}

Function Get-Repository {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array]$repolist
    )
    #$owner = $env:owner
    #$repository = $env:repository
    $pat = $env:pat
    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "Repository"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable –Name $partitionKey –Context $ctx).CloudTable
    foreach ($repo in $repolist){
        Write-Host "Fetching repository..."
        $repositoryBaseUrl = "https://api.github.com/repos/$($repo)"
        $header = @{authorization = "token $pat" }

        $repository = Invoke-RestMethod -Uri $repositoryBaseUrl -Method Get -ContentType "application/json" -Headers $header
        $repositoryTable = @{
            owner      = $repository.owner.login
            id         = $repository.id
            name       = $repository.name
            fullName   = $repository.full_name
            forks      = $repository.forks
            watchers   = $repository.subscribers_count
            stargazers = $repository.stargazers_count
            size       = $repository.size
            openIssues = $repository.open_issues
            createdAt  = $repository.created_at
            repo       = $repo
        }
        Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $repository.id -property $repositoryTable -UpdateExisting | Out-Null
        Write-Host "Repository successfully loaded"
    }
}

Function Get-Forks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Switch]$DailyRefresh,
        [Parameter(Mandatory = $true)]
        [array]$repolist
    )
    #$owner = $env:owner
    #$repository = $env:repository
    $pat = $env:pat

    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "Forks"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable –Name $partitionKey –Context $ctx).CloudTable

    foreach ($repo in $repolist){
        $forksBaseUrl = "https://api.github.com/repos/$($repo)/forks?per_page=100"
        $header = @{authorization = "token $pat" }
        $page = 1
        Write-Host "Fetching Forks..."
        $forks = Invoke-RestMethod -Uri $forksBaseUrl -Method Get -ContentType "application/json" -Headers $header
        if ($DailyRefresh) {
            $forks = $forks | Where-Object { $_.created_at -gt (Get-Date -Hour 0 -Minute 00 -Second 00).AddDays(-1) }
        }
        $dashboardForks = @()
        while ($forks.Count -gt 0) {
            $forks | ForEach-Object {
                $fork = @{
                    id        = $_.id
                    fullName  = $_.full_name
                    owner     = $_.owner.login
                    createdAt = $_.created_at
                    repo      = $repo
                }
                Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $_.id -property $fork -UpdateExisting | Out-Null
                $dashboardForks += $fork
                #Check if the fork has been forked (2nd level)
                try {
                    $secondForks = Invoke-RestMethod -Uri $_.forks_url -Method Get -ContentType "application/json" -Headers $header
                    $secondForks | ForEach-Object {
                        $fork = @{
                            id        = $_.id
                            fullName  = $_.full_name
                            owner     = $_.owner.login
                            createdAt = $_.created_at
                            repo      = $repo
                        }
                        Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $_.id -property $fork -UpdateExisting | Out-Null
                        $dashboardForks += $fork
                    }
                }
                catch {
                    $StatusCode = $_.Exception.Response.StatusCode.value__
                    if ($StatusCode -eq "404") {
                        Write-Host "Fork not found"
                    }
                    else {
                        Write-Host "$($_.Exception.Message)"
                    }
                }
            }
            $page += 1
            $uri = $forksBaseUrl + "&page=$page"
            $forks = Invoke-RestMethod -Uri $uri -Method Get -ContentType "application/json" -Headers $header
            if ($DailyRefresh) {
                $forks = $forks | Where-Object { $_.created_at -gt (Get-Date -Hour 0 -Minute 00 -Second 00).AddDays(-1) }
            }
        }
        Write-Host "$($dashboardForks.Count) Forks successfully loaded"
    }
}

Function Get-Clones {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Switch]$DailyRefresh,
        [Parameter(Mandatory = $true)]
        [array]$repolist
    )
    #$owner = $env:owner
    #$repository = $env:repository
    $pat = $env:pat

    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "Clones"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable –Name $partitionKey –Context $ctx).CloudTable

    foreach ($repo in $repolist){
        Write-Host "Fetching Clones..."
        $clonesBaseUrl = "https://api.github.com/repos/$($repo)/traffic/clones?per_page=100"
        $header = @{authorization = "token $pat" }
        $page = 1

        $clones = Invoke-RestMethod -Uri $clonesBaseUrl -Method Get -ContentType "application/json" -Headers $header
        if ($DailyRefresh) {
            $clones = $clones | Where-Object { $_.timestamp -gt (Get-Date -Hour 0 -Minute 00 -Second 00).AddDays(-1) }
        }
        $dashboardClones = @()
        while ((($clones.clones).Count -gt 0) -and ($page -lt 10)) {
            $clones.clones | ForEach-Object {
                $id = [int]((([string]$_.timestamp).Split(" ")[0]) -replace "/", "")
                $clone = @{
                    id      = $id
                    date    = $_.timestamp
                    uniques = $_.uniques
                    count   = $_.count
                    repo    = $repo
                }
                Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $id -property $clone -UpdateExisting | Out-Null
                $dashboardClones += $clone
            }
            $page += 1
            $uri = $clonesBaseUrl + "&page=$page"
            $clones = Invoke-RestMethod -Uri $uri -Method Get -ContentType "application/json" -Headers $header
            if ($DailyRefresh) {
                $clones = $clones | Where-Object { $_.timestamp -gt (Get-Date -Hour 0 -Minute 00 -Second 00).AddDays(-1) }
            }
        }
        Write-Host "$($dashboardClones.Count) Clones successfully loaded"
    }
}

Function Get-OpenPullRequests {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Switch]$DailyRefresh,
        [Parameter(Mandatory = $true)]
        [array]$repolist
    )

    # $owner = $env:owner
    # $repository = $env:repository
    $pat = $env:pat

    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "OpenPullRequests"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable –Name $partitionKey –Context $ctx).CloudTable

    foreach ($repo in $repolist){
        Write-Host "Fetching open pull requests..."
        $openPullRequestsBaseUrl = "https://api.github.com/repos/$($repo)/pulls?state=all&per_page=100"
        $header = @{authorization = "token $pat" }
        $page = 1

        $openPullRequests = Invoke-RestMethod -Uri $openPullRequestsBaseUrl -Method Get -ContentType "application/json" -Headers $header
        if ($DailyRefresh) {
            $openPullRequests = $openPullRequests | Where-Object { ($_.created_at -gt (Get-Date -Hour 0 -Minute 00 -Second 00).AddDays(-1)) -or ($_.closed_at -gt (Get-Date -Hour 0 -Minute 00 -Second 00).AddDays(-1)) }
        }
        $dashboardopenPullRequests = @()
        while (($openPullRequests.Count -gt 0) -and ($page -lt 10)) {
            $openPullRequests | ForEach-Object {
                $statsUrl = "https://api.github.com/repos/$($repo)/pulls/$($_.number)"
                $stats = Invoke-RestMethod -Uri $statsUrl -Method Get -ContentType "application/json" -Headers $header
                $openPullRequest = @{
                    id           = $_.id
                    number       = $_.number
                    user         = $_.user.login
                    state        = $_.state
                    title        = $_.title
                    createdDate  = $_.created_at
                    additions    = $stats.additions
                    deletions    = $stats.deletions
                    changedFiles = $stats.changed_files
                    repo         = $repo
                }
                Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $_.number -property $openPullRequest -UpdateExisting | Out-Null
                $dashboardopenPullRequests += $openPullRequest
            }
            $page += 1
            $uri = $openPullRequestsBaseUrl + "&page=$page"
            $openPullRequests = Invoke-RestMethod -Uri $uri -Method Get -ContentType "application/json" -Headers $header
            if ($DailyRefresh) {
                $openPullRequests = $openPullRequests | Where-Object { ($_.created_at -gt (Get-Date -Hour 0 -Minute 00 -Second 00).AddDays(-1)) -or ($_.closed_at -gt (Get-Date -Hour 0 -Minute 00 -Second 00).AddDays(-1)) }
            }
        }
        Write-Host "$($dashboardopenPullRequests.Count) Open pull requests successfully loaded"
        $return = $dashboardopenPullRequests.user | Sort-Object -Unique
        return $return
    }
}

Function Get-ClosedPullRequests {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Switch]$DailyRefresh,
        [Parameter(Mandatory = $true)]
        [array]$repolist
    )

    #$owner = $env:owner
    #$repository = $env:repository
    $pat = $env:pat

    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "ClosedPullRequests"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable –Name $partitionKey –Context $ctx).CloudTable

    foreach ($repo in $repolist){
        Write-Host "Fetching closed pull requests..."
        $closedPullRequestsBaseUrl = "https://api.github.com/repos/$($repo)/pulls?state=closed&per_page=100"
        $header = @{authorization = "token $pat" }
        $page = 1

        $closedPullRequests = Invoke-RestMethod -Uri $closedPullRequestsBaseUrl -Method Get -ContentType "application/json" -Headers $header
        if ($DailyRefresh) {
            $closedPullRequests = $closedPullRequests | Where-Object { ($_.closed_at -gt (Get-Date -Hour 0 -Minute 00 -Second 00).AddDays(-1)) }
        }
        $dashboardclosedPullRequests = @()
        while (($closedPullRequests.Count -gt 0) -and ($page -lt 10)) {
            $closedPullRequests | ForEach-Object {
                $statsUrl = "https://api.github.com/repos/$($repo)/pulls/$($_.number)"
                $stats = Invoke-RestMethod -Uri $statsUrl -Method Get -ContentType "application/json" -Headers $header
                $closedPullRequest = @{
                    id           = $_.id
                    number       = $_.number
                    user         = $_.user.login
                    state        = $_.state
                    title        = $_.title
                    createdDate  = $_.created_at
                    closedDate   = if ([String]::IsNullOrEmpty($_.closed_at)) { "" } else { $_.closed_at }
                    mergedDate   = if ([String]::IsNullOrEmpty($_.merged_at)) { "" } else { $_.merged_at }
                    additions    = $stats.additions
                    deletions    = $stats.deletions
                    changedFiles = $stats.changed_files
                    repo         = $repo
                }
                Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $_.number -property $closedPullRequest -UpdateExisting | Out-Null
                $dashboardclosedPullRequests += $closedPullRequest
            }
            $page += 1
            $uri = $closedPullRequestsBaseUrl + "&page=$page"
            $closedPullRequests = Invoke-RestMethod -Uri $uri -Method Get -ContentType "application/json" -Headers $header
            if ($DailyRefresh) {
                $closedPullRequests = $closedPullRequests | Where-Object { ($_.closed_at -gt (Get-Date -Hour 0 -Minute 00 -Second 00).AddDays(-1)) }
            }
        }
        Write-Host "$($dashboardclosedPullRequests.Count) Closed pull requests successfully loaded"
        return $dashboardclosedPullRequests.number
    }
}

Function Get-Stargazers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array]$repolist
    )

    #$owner = $env:owner
    #$repository = $env:repository
    $pat = $env:pat

    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "Stargazers"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable –Name $partitionKey –Context $ctx).CloudTable

    foreach ($repo in $repolist){
        Write-Host "Fetching stargazers..."
        $stargazersBaseUrl = "https://api.github.com/repos/$($repo)/stargazers?per_page=100"
        $header = @{authorization = "token $pat" }
        $page = 1
        $stargazers = Invoke-RestMethod -Uri $stargazersBaseUrl -Method Get -ContentType "application/json" -Headers $header
        $dashboardStargazers = @()
        while (($stargazers.Count -gt 0) -and ($page -lt 10)) {
            $stargazers | ForEach-Object {
                $stargazer = @{
                    login      = $_.login
                    id         = $_.id
                    avatar_url = $_.avatar_url
                    url        = $_.url
                    type       = $_.type
                    repo       = $repo
                }
                Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $_.id -property $stargazer -UpdateExisting | Out-Null
                $dashboardStargazers += $stargazer
            }
            $page += 1
            $uri = $stargazersBaseUrl + "&page=$page"
            $stargazers = Invoke-RestMethod -Uri $uri -Method Get -ContentType "application/json" -Headers $header
        }
        Write-Host "$($dashboardStargazers.Count) stargazers successfully loaded"
    }
}

Function Get-Contributors {
    [CmdletBinding()]
    param (
        [Parameter()]
        [array]$users
    )
    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "Contributors"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable –Name $partitionKey –Context $ctx).CloudTable

    Write-Host "Fetching contributors..."
    $pat = $env:pat
    $header = @{authorization = "token $pat" }
    $count = 0
    $users | ForEach-Object {
        $count += 1
        $usersUrl = "https://api.github.com/users/$_"
        $userData = Invoke-RestMethod -Uri $usersUrl -Method Get -ContentType "application/json" -Headers $header
        $id = [int](((Get-Date -Format "dddd MM/dd/yyyy").Split(" ")[1]) -replace "/", "") + $userData.id
        $user = @{
            login  = $userData.login
            id     = $id
            avatar = $userData.avatar_url
            email =  if ([String]::IsNullOrEmpty($userData.email)) { "" } else { $userData.email }
            company = if ([String]::IsNullOrEmpty($userData.company)) { "" } else { $userData.company }

        }
        Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $id -property $user -UpdateExisting | Out-Null
    }
    Write-Host "$count contributors successfully loaded"
}

Function Get-Traffic {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array]$repolist
    )

    # $owner = $env:owner
    # $repository = $env:repository
    $pat = $env:pat

    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "Views"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable –Name $partitionKey –Context $ctx).CloudTable

    foreach ($repo in $repolist){
        Write-Host "Fetching Views..."
        $viewsBaseUrl = "https://api.github.com/repos/$($repo)/traffic/views?per_page=100"
        $header = @{authorization = "token $pat" }

        $views = Invoke-RestMethod -Uri $viewsBaseUrl -Method Get -ContentType "application/json" -Headers $header
        if ($DailyRefresh) {
            $views = $views.views | Where-Object { $_.timestamp -gt (Get-Date -Hour 0 -Minute 00 -Second 00).AddDays(-1) }
        }
        else {
            $views = $views.views
        }
        $dashboardviews = @()

        $views | ForEach-Object {
            $id = [int]((([string]$_.timestamp).Split(" ")[0]) -replace "/", "")
            $view = @{
                id      = $id
                date    = $_.timestamp
                uniques = $_.uniques
                count   = $_.count
                repo    = $repo
            }
            Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $id -property $view -UpdateExisting | Out-Null
            $dashboardviews += $view
        }

        Write-Host "$($dashboardviews.Count) views successfully loaded"
    }
}

Function Get-Issues {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Switch]$DailyRefresh,
        [Parameter(Mandatory = $false)]
        [array]$repolist
    )

    # $owner = $env:owner
    # $repository = $env:repository
    $pat = $env:pat

    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "Issues"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable –Name $partitionKey –Context $ctx).CloudTable

    foreach ($repo in $repolist){
        $issuesBaseUrl = "https://api.github.com/repos/$($repo)/issues?state=all&per_page=100"
        $header = @{authorization = "token $pat" }
        $page = 1

        Write-Host "Fetching Issues..."
        $issues = Invoke-RestMethod -Uri $issuesBaseUrl -Method Get -ContentType "application/json" -Headers $header
        if ($DailyRefresh) {
            $issues = $issues | Where-Object { ($_.created_at -gt (Get-Date -Hour 0 -Minute 00 -Second 00).AddDays(-1)) -and ($null -eq $_.pull_request) }
        }
        $dashboardIssues = @()
        while ($issues.Count -gt 0) {
            $issues | ForEach-Object {
                $issue = @{
                    id         = $_.id
                    number     = $_.number
                    title      = $_.title
                    user       = $_.user.login
                    state      = $_.state
                    assignee   = if ([String]::IsNullOrEmpty($_.assignee)) { "" } else { $_.assignee.login }
                    milestone  = if ([String]::IsNullOrEmpty($_.milestone)) { "" } else { $_.milestone.title }
                    created_at = $_.created_at
                    updated_at = $_.updated_at
                    closed_at  = if ([String]::IsNullOrEmpty($_.closed_at)) { "" } else { $_.closed_at }
                    repo       = $repo
                    pr         = if ([String]::IsNullOrEmpty($_.pull_request.url)) { "" } else { $_.pull_request.url }

                }
                Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $_.id -property $issue -UpdateExisting | Out-Null
                $dashboardIssues += $issue
            }
            $page += 1
            $uri = $issuesBaseUrl + "&page=$page"
            $issues = Invoke-RestMethod -Uri $uri -Method Get -ContentType "application/json" -Headers $header
            if ($DailyRefresh) {
                $issues = $issues | Where-Object { $_.created_at -gt (Get-Date -Hour 0 -Minute 00 -Second 00).AddDays(-1) }
            }
        }
        Write-Host "$($dashboardIssues.Count) issues successfully loaded"
    }
}

Function Get-Releases {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array]$repolist
    )
    # $owner = $env:owner
    # $repository = $env:repository
    $pat = $env:pat

    #Create table
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = "Releases"
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable –Name $partitionKey –Context $ctx).CloudTable
    foreach ($repo in $repolist){
        $tagsBaseUrl = "https://api.github.com/repos/$($repo)/releases"
        $header = @{authorization = "token $pat" }

        Write-Host "Fetching Releases..."
        $releases = Invoke-RestMethod -Uri $tagsBaseUrl -Method Get -ContentType "application/json" -Headers $header

        $dashboardReleases = @()
        while ($releases.Count -gt 0) {
            $releases | ForEach-Object {
                $release = @{
                    name = $_.tag_name
                    date = $_.published_at
                    repo = $repo

                }
                Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $_.name -property $release -UpdateExisting | Out-Null
                $dashboardReleases += $release
            }
        }
        Write-Host "$($dashboardTags.Count) tags successfully loaded"
    }
}