function Remove-Diacritics {
    param ([String]$src = [String]::Empty)
    
    $normalized = $src.Normalize( [Text.NormalizationForm]::FormD )
    $sb = new-object Text.StringBuilder
    $normalized.ToCharArray() | % { 
        if( [Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne [Globalization.UnicodeCategory]::NonSpacingMark) {
            [void]$sb.Append($_)
        }
    }
    
    $sb.ToString()
}

function createLink {
    param($element)

    $url = "folclore" + -join ((97..122) | Get-Random -Count 10 | % {[char]$_})
    $name = Remove-Diacritics "CDA FOLCLORE 2024 - $element"
    $message = Remove-Diacritics 'Bem-vindo(a) ao sistema de visualização e aprovação de fotos.'
    
    $headers = @(
        'App-Code:proof'
        'Authorization:OGNmYzRiODktMjQ1NC00N2UyLTgzMTctOGJiMDYzY2JlYzQ3fDE3MTkzNDQyMjI='
        'Cookie:__zlcmid=1MNmoPKeAcEQUs7; _gcl_au=1.1.1868066083.1719488200'
    )

    $request = echo @"
    {"collection":{
        "name":"$name",
        "photographed_at":null,
        "message":"$message",
        "download_photo_option_value":"DOWNLOAD_ALL",
        "downloadable":true,
        "single_download":true,
        "commentable":true,
        "shareable":false,
        "selection_limit":null,
        "category_id":124410,
        "exhibition_size_id":5,
        "selection_limit_date":null,
        "selection_limit_additional":null,
        "selection_limit_additional_value":null,
        "currency":null,
        "watermark_enabled":false,
        "friendly_url":"$url",
        "reminder_kind":"NONE",
        "collection_sell_attributes":{"buy_from":0,"disabled":true},
        "selection_min":null,
        "selection_quantity_type":"unlimited"
    }}
"@ | https --verify no POST "https://proof-api.alboompro.com/api/collections" $headers

    if (($request | jq '.success') -ne "true") {
        echo "-------------------------> Erro <----------------------"
        $request
        Start-Sleep -Seconds 60
        exit 1
    }

    $id = $request | jq '.collection.id'
    
    echo "{`"name`":`"DIA 3 ( 24.08.2024 )`"}" | https --verify no POST "https://proof-api.alboompro.com/api/collections/$id/folders/" $headers
    
    start chrome "https://proof.alboompro.com/selection/images/$id"
}

$folder = Read-Host "Pasta"

createLink("$folder")
