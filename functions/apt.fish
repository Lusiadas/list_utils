function apt -w apt
  if string match -qvr '^(update|list|search)$' $argv[1]
    command apt $argv
    return $status
  end

  # Source dependencies and declare variables
  source (status filename | command xargs dirname)/../dependency.fish -n apt apt grep
  or return 1
  set -l tmp (mktemp)
  set -l tmp2 (mktemp)

  function apt_main -V tmp -V tmp2

    # "update" option
    if string match -q update $argv[1]
      command apt list 2>/dev/null | string match -ar '^\S+(?=/)' > $tmp
      if type -qf termux-info
        command apt update
      else
        command sudo apt update
      end
      or return 1
      command apt list 2>/dev/null | string match -ar '^\S+(?=/)' > $tmp2
      if set -U _apt_new (diff $tmp $tmp2 | string match -ar '(?<=> )[^/]+')
        set_color green
        echo (count $_apt_new) new packages available
      end
      if set -U _apt_old (diff $tmp $tmp2 | string match -ar '(?<=< ).+')
        set_color red
        test (count $_apt_old) = 1
        and echo package $_apt_old removed from repository
        or echo packages (string join ', ' $_apt_old), removed from repositories
      end
      set_color normal
      return 0
    end

    set -lx GREP_COLORS 'ms=01;32'

    # "new" filter
    function apt_new -V tmp -V tmp2 -V GREP_COLORS
      if test -z "$_apt_new"
        err 'No new packages available. Try updating your repositories.'
        return 1
      end
      for i in $_apt_new
        string match -q list $argv
        and grep -P "^$i(?=/)" $tmp >> $tmp2
        or grep -P "^$i(?=/)" -A 2 $tmp >> $tmp2
      end
    end

    # "installed" filter
    function apt_installed -V tmp -V tmp2 -V GREP_COLORS
      string match -q list $argv
      and grep -P 'installed]$' $tmp > $tmp2
      or grep -P 'installed]$' -A 2 $tmp > $tmp2
    end

    # "repo" filter
    function apt_repo -V tmp -V tmp2 -V GREP_COLORS
      set -l packages (command find "$PREFIX"/var/lib/apt/lists/ -maxdepth 1 -type f \
      | command grep -P -- "[^/]+_dists_("{$argv[2..-1]}")_[^/]+Packages\$" \
      | command xargs grep -hoP '(?<=^Package: ).+')
      if test -z "$packages"
        err "apt: No results where found for |"(string join '|, |' $argv[2..-1])"|"
        return 1
      end
      for package in $packages
        string match -q list $argv[1]
        and grep -P "^$package(?=/)" $tmp >> $tmp2
        or grep -P "^$package(?=/)" -A 2 $tmp >> $tmp2
      end
    end

    # parse flags
    if argparse -n apt -x n,o -x n,i 'n/new' 'i/installed' \
    'o/old' 'r/repo=+' 'h/help' -- $argv 2>&1 | read err
      err $err
      return 1
    end

    # "help" option
    if set --query _flag_help
      source (dirname (status -f))/../instructions.fish $argv[1]
      test -n "$argv[2..-1]"
      return $status
    end

    # Apply filters and display result
    if set --query _flag_old
      if test -z "$_apt_old"
        err 'No record of packages removed from repositories as of yet.'
        return 1
      end
      command printf '%s\n' $_apt_old > $tmp
    else
      if not command apt $argv 2>$tmp2 | command tail +3 >$tmp
        err "apt: "(command tail -1 $tmp2)
        return 1
      end
      rm $tmp2
      set -x GREP_COLORS 'ms=01;32'
    end
    set --query _flag_new
    and apt_new $argv[1]
    set --query _flag_installed
    and apt_installed $argv[1]
    set --query _flag_repo
    and apt_repo $argv[1] $_flag_repo
    set --names | string match -qr '^_flag_(new|installed|repo)$'
    and command mv -f $tmp2 $tmp
    string match -q list
    and grep -P '^\S+(?=/)' $tmp
    or grep -P '^\S+(?=/)' -A 2 $tmp
  end
  apt_main $argv
  set -l exit_status $status
  functions -e (functions | string match -ar '^apt_.+')
  command rm "$tmp" "$tmp2" 2>/dev/null
  test "$exit_status" = 0
end