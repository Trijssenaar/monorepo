[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]$Application,
    [Parameter(Mandatory=$true)]
    [Int32]$Port
)

$ErrorActionPreference = "Stop"

docker rm ${Application} --force
docker run -d -e PORT=8080 -p ${Port}:8080 --name ${Application} ${Application}:latest 