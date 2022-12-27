[CmdletBinding()]
param (
   [Parameter(Mandatory = $true)]
   [string]$Artifact,
   [Parameter(Mandatory = $true)]
   [string]$Version
)

$artifactsFilePath = "$PSScriptRoot/artifacts.json"
$artifacts = Get-Content -Path $artifactsFilePath | ConvertFrom-Json -AsHashtable
$artifacts.$Artifact = $Version
$artifacts | ConvertTo-Json | Set-Content -Path $artifactsFilePath