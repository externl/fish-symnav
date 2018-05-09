function __symnav_join_path
    # Root directory if empty list
    if test -z "$argv"
        echo '/'
    else
        string join '/' $argv
    end
end
