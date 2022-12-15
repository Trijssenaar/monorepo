$fullSemVer = (gitversion | ConvertFrom-Json).FullSemVer
$index = Get-Content $PSScriptRoot\app\index.html
$index = $index.Replace("{{version}}", $fullSemVer)
docker build --tag app1:$fullSemVer $PSScriptRoot\.