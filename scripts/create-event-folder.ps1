$path = Read-Host "Caminho"
$name = Read-Host "Nome"
$folders = Read-Host "Quantidade" 

ls "$path" | select -first $folders | % { mkdir "$_/$name"; mv "$_/*.jpg" "$_/$name" }
