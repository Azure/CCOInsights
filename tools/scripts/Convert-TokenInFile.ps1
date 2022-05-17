<#
.SYNOPSIS
Recieves an Input Object of Name/Value and Searches the Current File for the Name and Replaces it with the Value
.DESCRIPTION
Recieves an Input Object of Name/Value and Searches the Current File for the Name and Replaces it with the Value
.PARAMETER FilePath
Mandatory. Full Path for the file that contains the strings that need to be replaced. Supports multiple files comma seperated.
.PARAMETER TokenNameValueObject
Mandatory. An Object that contains the Name Key and Value Key For replacing tokens in files. See Example for structure.

#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $FilePath,
    [Parameter(Mandatory)]
    [string] $TokenName,
    [Parameter(Mandatory)]
    [string] $TokenValue
)
# Begin the Replace Function
# Process Path for Token Replacement
# Extract Required Content From the Input
try {
    $File = Get-Content -Path $FilePath
    $FileName = Split-Path -Path $FilePath -Leaf
}
catch {
    throw $PSItem.Exception.Message
}
Write-Verbose "Processing Tokens for file: $FileName"
# Perform the Replace of Tokens in the File
$File = $File -replace $TokenName, $TokenValue
# Set Content
$File | Set-Content -Path $FilePath

Write-Verbose "File: $FileName has been updated with the new token value Name: $TokenName, Value: $TokenValue"
