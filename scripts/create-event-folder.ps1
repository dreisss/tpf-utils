$path = Read-Host "Caminho"
$name = Read-Host "Nome"
$folders = Read-Host "Quantidade" 

ls "$path" | select -first $folders | % { mkdir "$path/$_/$name"; mv "$path/$_/*.jpg" "$path/$_/$name" }
