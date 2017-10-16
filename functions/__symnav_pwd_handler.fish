# In case another function changed the working directory, check if the current path
# resolves to PWD, if not just use PWD
function __symnav_pwd_handler --on-variable PWD
    if not __symnav_is_realpath
        set symnav_pwd "$PWD"
    end
end
