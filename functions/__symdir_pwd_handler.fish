# In case another function changed the working directory, check if the current path
# resolves to PWD, if not just use PWD
function __symdir_pwd_handler --on-variable PWD
    if not __symdir_is_realpath
        set symdir_pwd "$PWD"
    end
end
