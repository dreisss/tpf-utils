$main = [uri]::EscapeDataString("$(pwd)".Split("\")[-1].Split("-")[0])
$date = (Get-Date -Format "yyyy-MM-dd").Trim()

$headers = @(
    'App-Code:proof'
    'Authorization:OGNmYzRiODktMjQ1NC00N2UyLTgzMTctOGJiMDYzY2JlYzQ3fDE3MTkzNDQyMjI='
    'Cookie:__zlcmid=1MNmoPKeAcEQUs7'
)                      

$request = https --verify no GET "https://proof-api.alboompro.com/api/dashboard?type=collection&q[name_cont]=$main&q[created_at_gteq]=2019-03-06&q[created_at_lteq]=$date&q[archived_at_not_null]=false" $headers

$ids = $request | jq ".projects|.draft[],.in_progress[],.review[],.finished[]|.id"

$ids | % { start chrome "https://proof.alboompro.com/photo-proof/details/$_/?group=logged_in" }
