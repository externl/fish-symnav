function __symdir_shadow_pwd --wraps pwd
    echo "$symdir_pwd"
end
