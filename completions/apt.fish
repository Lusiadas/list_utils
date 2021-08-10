source "$PREFIX"/../usr/share/fish/completions/apt.fish
complete -xc apt -n "string match -qr -- '^(search|list)\$' (commandline -po)[2]" -s n -l new \
-d 'Include only packages recently added to repositories'
complete -xc apt -n "string match -q -- list (commandline -po)[2]" -s o -l old \
-d "include only packages recently removed from repositories"
complete -fc apt -n "string match -qr -- '^(search|list)\$' (commandline -po)[2]" -s h -l help \
-d 'Display instructions'
complete -xc apt -n "string match -qr -- '^(search|list)\$' (commandline -po)[2]" -s i -l installed \
-d 'Include only installed packages'
complete -xc apt -n "string match -qr -- '^(search|list)\$' (commandline -po)[2]" -s r -l repo \
-d 'Include only packages from a given repository'
for repo in (ls "$PREFIX"/var/lib/apt/lists/*Packages \
| string match -ar '(?<=dists_).+(?=_binary)' \
| command uniq)
  complete -xc apt -n "commandline -p | string match -qr -- '^apt (search|list) -(r|-repo)'" \
  -a $repo -d Repository
end