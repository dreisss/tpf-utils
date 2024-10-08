$command = Read-Host "Comando"

$events = ls -Directory -exclude "SELEÇÃO" | % { $_.Name.Split("-")[0].Trim() }

mkdir ".\SELEÇÃO\" -Force
$events | % { mkdir ".\SELEÇÃO\$_\" -Force }

(Read-Host "Lista").Replace("., ", "`n").Replace("jpg", "").Replace("JPG", "").Replace(".", "").Split("`n") | % { ls -r "./**/*$_.jpg" } | % {
    $photoPath = "$_"

    $events | % {
        if ($photoPath.Contains($_)) {
            Invoke-Expression "$command '$photoPath' '.\SELEÇÃO\$_'"
        }
    }
}
    
