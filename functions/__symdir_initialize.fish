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
