$startDate = Read-Host "Data Início (yyyy-mm-dd)"
$endDate = Read-Host "Data Fim (yyyy-mm-dd)"

$headers = @(
    'App-Code:proof'
    'Authorization:OGNmYzRiODktMjQ1NC00N2UyLTgzMTctOGJiMDYzY2JlYzQ3fDE3MTkzNDQyMjI='
    'Cookie:__zlcmid=1MNmoPKeAcEQUs7'
)                      

$request = https --verify no GET "https://proof-api.alboompro.com/api/dashboard?type=all&q[created_at_gteq]=$startDate&q[created_at_lteq]=$endDate&q[archived_at_not_null]=false" $headers

$ids = $request | jq ".projects|.draft[],.in_progress[],.review[],.finished[]|.id"

$ids | % {
    https --verify no DELETE "https://proof-api.alboompro.com/api/collections/$_" $headers
    https --verify no DELETE "https://proof-api.alboompro.com/api/albums/$_" $headers
}
