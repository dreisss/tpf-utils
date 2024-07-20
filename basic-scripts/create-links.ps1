$main = "$(pwd)".Split("\")[-1].Split("-")[0]

$auth = Read-Host "Authorization"
$cookie = Read-Host "Cookie"

function createLink {
    param($element)

    $url = $main.ToLower().Replace(" ", "_") + "-_" + $element.ToLower().Replace(" ", "_")

    $headers = @(
        'App-Code:proof'
        "Authorization:$auth"
        "Cookie:$cookie"
    )

    $request = echo @"
    {"collection":{
        "name":"$main - $element",
        "photographed_at":null,
        "message":"Bem-vindo(a) ao sistema de visualização e aprovação de fotos.",
        "download_photo_option_value":"DOWNLOAD_ALL",
        "downloadable":true,
        "single_download":true,
        "commentable":true,
        "shareable":false,
        "selection_limit":null,
        "category_id":124404,
        "exhibition_size_id":5,
        "selection_limit_date":null,
        "selection_limit_additional":null,
        "selection_limit_additional_value":null,
        "currency":null,
        "watermark_enabled":false,
        "friendly_url":"$url",
        "reminder_kind":"NONE",
        "collection_sell_attributes":{"buy_from":0,
        "disabled":true},
        "selection_min":null,
        "selection_quantity_type":"unlimited"
    }}
"@ | https --verify no POST "https://proof-api.alboompro.com/api/collections" $headers

    if (($request | jq '.success') -ne "true") {
        echo "-------------------------> Erro <----------------------"
        $request
        exit 1
    }

    $id = $request | jq '.collection.id'
    
    start chrome "https://proof.alboompro.com/selection/images/$id"
}

$input | % { createLink($_.Name) }

# TODO: auto image upload
