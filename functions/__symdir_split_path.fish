# TODO: This seems like a very bad to split with path; it does not check for '\/'s
function __symdir_split_path --argument path
    for component in (string split '/' -- $path)
        echo "$component"
    end
end
