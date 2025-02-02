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

### RUNNING  
$path = (Get-Clipboard).Replace('"', '')
$collection = Remove-Diacritics(Read-Host "Evento")

if (-not(Test-Path -Path "$path" -IsValid)) {
    exit
}

$date = (Get-Date -Format "yyyy-MM-dd").Trim()

$headers = @(
    'App-Code:proof'
    'Authorization:OGNmYzRiODktMjQ1NC00N2UyLTgzMTctOGJiMDYzY2JlYzQ3fDE3MTkzNDQyMjI='
    'Cookie:__zlcmid=1MNmoPKeAcEQUs7'
)                                   

ls -Directory "$path/[A-ZÁ-Ú]*" | % {
    $query = Remove-Diacritics($_.Name.Split("-")[0])
    $request = https --verify no GET "https://proof-api.alboompro.com/api/dashboard?type=collection&q[name_cont]=$query&q[created_at_gteq]=2019-03-06&q[created_at_lteq]=$date&q[archived_at_not_null]=false" $headers
    $id = $request | jq ".projects|.draft[],.in_progress[],.review[],.finished[]|.id"

    try {
        echo "{`"name`":`"$collection`"}" | https --verify no POST "https://proof-api.alboompro.com/api/collections/$id/folders/" $headers
    
        start chrome "https://proof.alboompro.com/selection/images/$id"
    } catch {
        continue
    }
}


