function __symnav_shadow_pwd --wraps pwd
    echo "$symnav_pwd"
end
