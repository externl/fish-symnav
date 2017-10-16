# Check if dir is a realpath. Default dir is symnav_pwd
# Not to be confused with __symnav_is_pwd
function __symnav_is_realpath --argument dir
    if test -n "$dir"
        test (realpath "$dir") = "$dir"
    else
        test (realpath "$symnav_pwd") = "$PWD"
    end
end
