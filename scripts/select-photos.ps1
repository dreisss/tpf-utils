mkdir .\Z\ -Force

$command = Read-Host "Comando"

(Get-Clipboard).Replace("., ", "`n").Replace("jpg", "").Replace("JPG", "").Replace(".", "").Split("`n") | % { ls -r "./**/*$_.jpg" } | % { Invoke-Expression "$command '$_' .\Z\" }
