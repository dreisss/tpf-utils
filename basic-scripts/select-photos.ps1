mkdir .\Z\ -Force

$command = Read-Host "Comando"

(Get-Clipboard).Replace("., ", "`n").Replace(".", "").Split("`n") | % { ls -r "./**/*$_.jpg" } | % { Invoke-Expression "$command '$_' .\Z\" }
