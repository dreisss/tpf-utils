$path = Read-Host "Caminho"
$name = Read-Host "Nome"

ls "$path/[A-ZÁ-Ú]*" | % { mkdir "$path/$_/$name"; mv "$path/$_/*.jpg" "$path/$_/$name" }
