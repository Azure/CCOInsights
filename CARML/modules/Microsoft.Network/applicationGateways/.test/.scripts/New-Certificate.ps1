param(
    [string] $KeyVaultName,
    [string] $CertName
)

$certificate = Get-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName -ErrorAction 'Stop'

if (-not $certificate) {
    $policyInputObject = @{
        SecretContentType = 'application/x-pkcs12'
        SubjectName       = 'CN=fabrikam.com'
        IssuerName        = 'Self'
        ValidityInMonths  = 12
        ReuseKeyOnRenewal = $true
    }
    $certPolicy = New-AzKeyVaultCertificatePolicy @policyInputObject

    $null = Add-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName -CertificatePolicy $certPolicy
    Write-Verbose ('Initiated creation of certificate [{0}] in key vault [{1}]' -f $CertName, $KeyVaultName) -Verbose

    while (-not (Get-AzKeyVaultCertificateOperation -VaultName $KeyVaultName -Name $CertName).Status -eq 'completed') {
        Write-Verbose 'Waiting 10 seconds for certificate creation' -Verbose
        Start-Sleep 10
    }

    Write-Verbose 'Certificate created' -Verbose
}

$secretId = $certificate.SecretId
while ([String]::IsNullOrEmpty($secretId)) {
    Write-Verbose 'Waiting 10 seconds until certificate can be fetched' -Verbose
    Start-Sleep 10
    $certificate = Get-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName -ErrorAction 'Stop'
    $secretId = $certificate.SecretId
}

# Write into Deployment Script output stream
$DeploymentScriptOutputs = @{
    secretUrl = $secretId
}
