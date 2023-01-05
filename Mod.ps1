$TOKEN = 'eyJ2ZXIiOiIyIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYiLCJraWQiOiJuc2R0a1pHVmRLbV9DcEZ3ZG8xV09VNmpMSUtqelVheFd3eldmeHN5S2RRIn0.eyJleHQiOiJ7XCJyZXZvY2FibGVcIjpcInRydWVcIn0iLCJzdWIiOiJqZmFjQDAxZ21qamExMXgxN3RuMXJucGhuN2ExeWV5XC91c2Vyc1wvc3RyaWpzc2VuYWFyQHhwaXJpdC5jb20iLCJzY3AiOiJhcHBsaWVkLXBlcm1pc3Npb25zXC9hZG1pbiIsImF1ZCI6IipAKiIsImlzcyI6ImpmZmVAMDAwIiwiaWF0IjoxNjcyOTEyMjQ3LCJqdGkiOiJmNDZiMWFlMS1kZTZkLTRkMmItOWY5Ny05NTE5MjJkNGM4ZjEifQ.L1aZBwOGALJyi8QKcaGo4ft6G2zXV0AvjPc7z9nSYIeVL94q7WnKBT3hva8WqxYSh6ZPufYWgFuLtAwhn4HlG0YQ1VEs_Kstkv6eDycuaWh1-uoJe9W7mnrv8GAJESS9WiJGgOaWfMvtdZBzCA7715ShSDcYPPO64uIoCn0SiyCbEmLx4WT7FIqMriIZHJwO6VIz_Z_R22pnscj3_LSH2NAzy5OeSASeEaNmzIpY-YJGiKt_MdtTRlqHKEdqhPiPA-AVhzPNHXWLcA_6wzkrO4Cx0wF2VWRT5AYXpOQ0-adUza9qBDHzjNs7ruBdoqzX4wHr9jn_WgcK3VW9lVHNBg'
$HOSTNAME = 'trijssenaar.jfrog.io'
$ORG_NAME = 'monorepo'
$MODULE = 'modules-keyvault'
$PROVIDER = 'azurerm'

$params = @{
   Uri     = "https://${HOSTNAME}/artifactory/api/terraform/infrastructure-terraform-local/${ORG_NAME}/${MODULE}/${PROVIDER}/versions"
   Headers = @{ 'Authorization' = "Bearer ${TOKEN}"; 'Content-Type' = "application/vnd.api+json" }
   Method  = 'GET'
}

Invoke-RestMethod @params | ConvertTo-Json -Depth 20

AKCp8nyYKSmcPoAwUgzmD4UFA4oihs9EorAWtFV2i3r2JnQqeVEr6spTQBeEtwKTDpuMMRyGj