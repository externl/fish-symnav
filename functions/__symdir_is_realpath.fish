function __symdir_is_realpath
    test (realpath "$symdir_pwd") = "$PWD"
end
