set -g symdir_initialized 0
set -q symdir_pwd; or set -g symdir_pwd (pwd)
set -q symdir_complete_mode; or set -g symdir_complete_mode 'symlink'

function __symdir_initialize
    test $symdir_initialized -eq 1
        and return

    # Install symdir cd shim
    if not functions --query __symdir_fish_cd
        functions --copy cd __symdir_fish_cd
    end
    functions --erase cd
    functions --copy __symdir_shim_cd cd

    source (string split '\n' (functions prompt_pwd | sed 's/$PWD/$symdir_pwd/') | psub)

    set symdir_initialized 1
end

#
# Wrapper for cd. Resolve new symlink path and pass to builtin cd
#
function __symdir_shim_cd --description "Symdir shim for cd command" --argument arg
    if test (count $argv) -eq 0
        set symdir_pwd "$HOME"
        __symdir_fish_cd
    else if __symdir_string_match_flag "$arg"
        __symdir_fish_cd $argv
    else if test "$arg" = "/"
        set symdir_pwd "$arg"
        __symdir_fish_cd $symdir_pwd
    else
        set -l symdir_prevd "$symdir_pwd"
        set -l cd_dir (__symdir_trim_trailing_slash $argv[1])
        set symdir_pwd (__symdir_resolve_to "$cd_dir")
        __symdir_fish_cd $symdir_pwd
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

# In case another function changed the working directory, check if the current path
# resolves to PWD, if not just use PWD
function __symdir_pwd_handler --on-variable PWD
    if not __symdir_is_realpath
        set symdir_pwd "$PWD"
    end
end
