mkdir Z; cat ./a.txt | % { ls -r **/$_.jpg } | % { cp $_ ./Z }
