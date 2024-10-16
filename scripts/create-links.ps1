$main = $($(pwd).Path | sls "\w* \d{4} - [\w\s]*").Matches.Value

if (-not $main) {
    $main = $($(pwd).Path | sls "[\w|\s]* OUTORGA \( \d{2}.\d{2}.\d{4} \)").Matches.Value
    
    if (-not $main) {
        $main = Read-Host "Main"
    }
}

$info = $main.Split("-")[0].Trim()

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

    $url = "$(Remove-Diacritics($info.Split(" ")[1].ToLower()))$(-join ((97..122) | Get-Random -Count 10 | % {[char]$_}))"
    $name = Remove-Diacritics "$info - $element"
    $message = Remove-Diacritics 'Bem-vindo(a) ao sistema de visualização e aprovação de fotos.'
    
    $headers = @(
        'App-Code:proof'
        'Authorization:N2M2YmZhMDktMDg1NS00YTcxLWEwMzctMDc4NzlkOTk2NjRjfDE3MTkzNDQyMjI='
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
        "category_id":124404,
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
    
    ls -Directory $element | % { echo "{`"name`":`"$(Remove-Diacritics $_.Name.Split("-")[0].Trim())`"}" | https --verify no POST "https://proof-api.alboompro.com/api/collections/$id/folders/" $headers }
    
    start chrome "https://proof.alboompro.com/selection/images/$id"
}

$folders = Read-Host "Pasta(s)"

if (echo $folders | sls "\d+-\d+") {
    $range = $folders.split("-")

    ls -Directory "[A-YÁ-Ý]*" | select -skip ($range[0] - 1) | select -first $range[1]| % { createLink($_.Name) }
} else {
    $folder = $folders

    createLink($folder)
}
