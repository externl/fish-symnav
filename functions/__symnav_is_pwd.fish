# Check if symnav_pwd is the same as the PWD
# Not to be confused with __symnav_is_realpath
function __symnav_is_pwd --argument path
    test "$symnav_pwd" = "$PWD"
end
