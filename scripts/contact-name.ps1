$clipboard = (Get-Clipboard).Split("-")
$titleCaseName = (Get-Culture).TextInfo.ToTitleCase($clipboard[1].ToLower()).Replace(" Da ", " da ").Replace(" Das ", " das ").Replace(" De ", " de ").Replace(" Des ", " des ").Replace(" Do ", " do ").Replace(" Dos ", " dos ")
$institutionAndCourse = $clipboard[0]

Set-Clipboard "$titleCaseName | $institutionAndCourse"
