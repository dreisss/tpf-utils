$name = Read-Host "Nome"
$folders = Read-Host "Quantidade" 

ls | select -first $folders | % { mkdir "$_/$name"; mv "$_/*.jpg" "$_/$name"; cp (ls "$_/$name/*.jpg" | select -first 1) $_ }
