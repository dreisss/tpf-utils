$main = "$(pwd)".Split("\")[-1].Split("-")[0]

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

    $url = Remove-Diacritics($main + "_" + $element).ToLower().Replace(".", "").Replace(" ", "_").Replace("(", "_").Replace(")", "_").Replace("__", "_").Replace("__", "_")

    $headers = @(
        'App-Code:proof'
        'Authorization:N2M2YmZhMDktMDg1NS00YTcxLWEwMzctMDc4NzlkOTk2NjRjfDE3MTkzNDQyMjI='
        'Cookie:__zlcmid=1MNmoPKeAcEQUs7; _gcl_au=1.1.1868066083.1719488200'
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

$from = Read-Host "Número de início"
$folders = Read-Host "Quantidade de pastas"

ls | select -skip ($from - 1) | select -first $folders | % { createLink($_.Name) }

# TODO: auto image upload
