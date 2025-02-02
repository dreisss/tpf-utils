$path = Read-Host "Caminho"

$events = ls "$path" -Directory -exclude "\SELEÇÃO" | % { $_.Name.Split("-")[0].Trim() }

mkdir "$path\SELEÇÃO\" -Force
$events | % { mkdir "$path\SELEÇÃO\$_\" -Force }

(Read-Host "Lista").Replace("., ", "`n").Replace("jpg", "").Replace("JPG", "").Replace(".", "").Split("`n") | % { ls -r "$path/**/*$_.jpg" } | % {
    $photoPath = "$_"

    $events | % {
        if ($photoPath.Contains("$_")) {
            cp "$photoPath" "$path\SELEÇÃO\$_"
        }
    }
}
    
