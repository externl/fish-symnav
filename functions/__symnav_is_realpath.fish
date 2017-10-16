function __symnav_is_realpath --argument dir
    if test -n "$dir"
        test (realpath "$dir") = "$dir"
    else
        test (realpath "$symnav_pwd") = "$PWD"
    end
end
