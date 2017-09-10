function __symdir_is_realpath --argument dir
    if test -n "$dir"
        test (realpath "$dir") = "$dir"
    else
        test (realpath "$symdir_pwd") = "$PWD"
    end
end
