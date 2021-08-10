set -l bld (set_color 00afff -o)
set -l reg (set_color normal)
echo $bld"list-utils
Usage: "$reg"apt $argv [options] packages ...

"$bld"Options:
  -n/--new"$reg" - include only packages that were  newly added to repositories"
string match -q list $argv
and echo -- $bld"  -o/--old "$reg"- include only packages removed from repositories"
echo -- $bld"  -i/--installed "$reg"- include only installed packages
"$bld"  -r/--repo [repository] "$reg"- include only packages from a given repository
"