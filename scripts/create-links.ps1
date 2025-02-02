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

    $main = ($element | sls $validationRegex).Matches.Value

    $elementName = $element.Split("\")[-1].Trim()
     
    if ($main -match '\\') {
        $info = $main.Split("\")[-2].Trim().Split("-")[0]
    } elseif ($elementName -match "[\wÀ-ú ]* - [\wÀ-ú ]* \( [\wÀ-ú ]* \)$") {
        $info = $main.Replace(" -", "").Split("(")[0].Trim()    
        $elementName = $main.Split("(")[1].Replace(")", "").Trim()
    } elseif ($elementName -match "[\wÀ-ú ]*( \( \d{2}\.\d{2}\.\d{4} \))? - [\wÀ-ú ]*$") {
        $info = $main.Split("-")[0].Trim()
        $elementName = $main.Split("-")[1].Trim()
    } elseif ($element -match '[\wÀ-ú ]* OUTORGA \( \d{2}\.\d{2}\.\d{4} \)'){
        $info = $element.Split("\")[-2].Trim()
    } else {
        $info = Read-Host "Informação"
    }
    
    $url = "$(Remove-Diacritics($info.Split(" ")[1].ToLower()))$(-join ((97..122) | Get-Random -Count 10 | % {[char]$_}))"
    $name = Remove-Diacritics "$($info.Trim()) - $($elementName.Trim())".toUpper()
    $message = Remove-Diacritics 'Bem-vindo(a) ao sistema de visualização e aprovação de fotos.'
        
    $headers = @(
        'App-Code:proof'
        'Authorization:OGNmYzRiODktMjQ1NC00N2UyLTgzMTctOGJiMDYzY2JlYzQ3fDE3MTkzNDQyMjI='
        'Cookie:__zlcmid=1MNmoPKeAcEQUs7'
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
    
    ls -Directory $element | % {
        if ($_.Name -notmatch "- NÃO CONTRATOU") {
            mv "$element\$_" ($element + "\" + $_.Name.Split("-")[0].Trim() + " - ENVIADO $(date -format 'dd.MM.yyyy')")
            echo "{`"name`":`"$(Remove-Diacritics $_.Name.Split("-")[0].Trim())`"}" | https --verify no POST "https://proof-api.alboompro.com/api/collections/$id/folders/" $headers
        }
    }
    
    start chrome "https://proof.alboompro.com/selection/images/$id"
}

### RUNNING  
$path = (Get-Clipboard).Replace('"', '')
$validationRegex = "[\wÀ-ú ]*(\d{4}|\( \d{2}\.\d{2}\.\d{4} \))? - .*$"

if (-not(Test-Path -Path "$path" -IsValid)) {
    exit
}

createLink($path)
