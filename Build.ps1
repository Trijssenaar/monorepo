[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]$Application
)

$ErrorActionPreference = "Stop"

$fullSemVer = (gitversion | ConvertFrom-Json)
$index = Get-Content $PSScriptRoot\src\${Application}\app\index.html
$index = $index -replace '(<!--Version-->)(.*)(<!--\/Version-->)', "<!--Version-->$($fullSemVer.Major).$($fullSemVer.Minor).$($fullSemVer.Patch)<!--/Version-->"
$index | Set-Content $PSScriptRoot\src\${Application}\app\index.html
docker build `
    --tag ${Application}:latest --tag ${Application}:$($fullSemVer.Major).$($fullSemVer.Minor).$($fullSemVer.Patch) --tag ${Application}:$($fullSemVer.Major).$($fullSemVer.Minor) `
    --tag ${Application}:$($fullSemVer.Major) `
    $PSScriptRoot\src\${Application}\.