<#
.SYNOPSIS
Generates Azure Advisor recommendations for all the subscriptions to the given Azure Account.
.DESCRIPTION
Generates Azure Advisor recommendations for all the subscriptions to the given Azure Account.

The script calls Login-AzureRmAccount to require authentication before it can start generating/updating Azure Advisor recommendations.

.EXAMPLE
GenerateAllSubsAdvisorRecommendations.ps1

#>


        Login-AzureRmAccount

        if (-not (Get-Module AzureRm.Profile))
        {
            Import-Module AzureRm.Profile
        }

        $azureRmProfileModuleVersion = (Get-Module AzureRm.Profile).Version
        # refactoring performed in AzureRm.Profile v3.0 or later
        if ($azureRmProfileModuleVersion.Major -ge 3)
        {
            $azureRmProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
            if (-not $azureRmProfile.Accounts.Count)
            {
                Write-Error "Please run Login-AzureRmAccount before calling this function."
                break
            }
        }
        else
        {
            # AzureRm.Profile < v3.0
            $azureRmProfile = [Microsoft.WindowsAzure.Commands.Common.AzureRmProfileProvider]::Instance.Profile
            if (-not $azureRmProfile.Context.Account.Count)
            {
                Write-Error "Please run Login-AzureRmAccount before calling this function."
                break
            }
        }
        
        $Timeout = 60
        $currentAzureContext = Get-AzureRmContext
        $profileClient = New-Object Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient($azureRmProfile)
        Write-Debug ("Getting access token for tenant" + $currentAzureContext.Subscription.TenantId)
        $token = $profileClient.AcquireAccessToken($currentAzureContext.Subscription.TenantId)
        $headers = @{"Authorization"="Bearer " + $token.AccessToken}
        Write-Debug $token.AccessToken
    
        $SubsList = Get-AzureRmSubscription | where {$_.state -eq "Enabled"}


        foreach ($sub in $SubsList)
        {
            $uri = ("https://management.azure.com/subscriptions/$sub/providers/Microsoft.Advisor/generateRecommendations?api-version=2017-03-31")
            Write-Debug ("POST {0}" -f $uri)
            $response = Invoke-WebRequest -Uri $uri -Method Post -Headers $headers
            $statusUri = $response.Headers.Location
            Write-Debug ("GET {0}" -f $statusUri)

            $secondsElapsed = 0
            while ($secondsElapsed -lt $Timeout)
            {
                $response = Invoke-WebRequest -Uri $statusUri -Method Get -Headers $headers
                if ($response.StatusCode -eq 204) {break}
                Write-Verbose ("Waiting for generation to complete for subscription {0}..." -f $sub)
                Start-Sleep -Seconds 1
                $secondsElapsed++
            }

            $result = New-Object PSObject -Property @{"SubscriptionId" = $sub; "Status" = "Success"; "SecondsElapsed" = $secondsElapsed}

            if ($secondsElapsed -ge $Timeout)
            {
                $result.Status = "Timed out"
            }

            Write-Output $result


        }