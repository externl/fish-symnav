set symdir_pwd (pwd)

function __symdir_debug
    echo "[symdir] $argv" 1>&2
end

function __symdir_cd_is_absolute
    test (string split '' -- $argv)[1] = '/'
end

function __symdir_is_realpath
    test (realpath "$symdir_pwd") = "$PWD"
end

function __symdir_is_pwd
    test "$symdir_pwd" != "$PWD"
end

function __symdir_trim_trailing_slash
    string trim --right --chars '/' -- $argv[1]
end

# TODO: This seems like a very bad to split with path; it does not check for '\/'s
function __symdir_split_path --argument path
    for component in (string split '/' -- $path)
        echo "$component"
    end
end

function __symdir_join_path
    string join '/' $argv
end

#
# Resolve new "relative symlink" directory from 'path'.
# Eg. passing '../foo/bor' with the current path of /path/to/symlink1/symlink2/
# will result in /path/to/symlink1/foo/bar
#
function __symdir_resolve_to --argument path
    set -l to_dir (__symdir_trim_trailing_slash $path)

    __symdir_cd_is_absolute "$to_dir"
        and set -l path_to_resolve $to_dir
        or set -l path_to_resolve "$symdir_pwd/$to_dir"

    set -l path_list (__symdir_split_path "$path_to_resolve")

    set -l resolved_path
    for component in $path_list
        if test -z "$component"
            set resolved_path $resolved_path ""
        else if test $component = ".."
            set -e resolved_path[-1]
        else
            set resolved_path $resolved_path "$component"
        end
    end

    __symdir_join_path $resolved_path
end

#
# Wrapper for cd. Resolve new symlink path and pass to builtin cd
#
function cd --wraps cd
    if test (count $argv) -eq 0
        set symdir_pwd "$HOME"
        builtin cd
    else
        set -l symdir_prevd "$symdir_pwd"
        set -l cd_dir (__symdir_trim_trailing_slash $argv[1])
        set symdir_pwd (__symdir_resolve_to "$cd_dir")
        builtin cd $symdir_pwd
        set -l cd_status $status
        if test $cd_status -ne 0
            set symdir_pwd $symdir_prevd
        end
        return $cd_status
    end
end

function pwd --wraps pwd
    echo "$symdir_pwd"
end

#
# Completion handler for tab completions
# eg. Path is '/usr/local/symlink1/' and the user tries to complete 'cd ../', this will be
# rewritten as 'cd /usr/local/'
#
function __symdir_complete
    if __symdir_is_pwd
        set -l token (commandline --current-token)
        if string match --regex --quiet '^\.\./' "$token"
            set -l commandline_list (commandline --tokenize)[1..-2] (__symdir_resolve_to "$token")
            commandline --replace (string join ' ' $commandline_list)
        end
    end
    commandline -f complete
end

function __symdir_execute
    if __symdir_is_pwd
        set -l cmd (commandline --token)[1]
        set -l handler "__symdir_handle_$cmd"
        if functions -q "$handler"
            eval "$handler"
        end
    end
    commandline -f execute
end

# In case another function changed the working directory, check if the current path
# resolves to PWD, if not just use PWD
function __symdir_pwd_handler --on-variable PWD
    if not __symdir_is_realpath
        set symdir_pwd "$PWD"
    end
end
