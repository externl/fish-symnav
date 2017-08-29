set -g symdir_pwd (pwd)
set -g symdir_initialized 0

function __symdir_initialize
    test $symdir_initialized -eq 1
        and return
        or set symdir_initialized 1

    # Install symdir cd shim
    functions --copy cd __symdir_fish_cd
    functions --erase cd
    functions --copy _symdir_shim_cd cd
end

#
# Wrapper for cd. Resolve new symlink path and pass to builtin cd
#
function _symdir_shim_cd --wraps cd --argument directory
    if test (count $argv) -eq 0
        set symdir_pwd "$HOME"
        __symdir_fish_cd
    else if test "$directory" = "/"
        set symdir_pwd "$directory"
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
