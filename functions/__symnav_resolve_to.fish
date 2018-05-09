#
# Resolve new "resolved symlink" directory from 'path'.
# Eg. passing '../foo/bor' with the current path of /path/to/symlink1/symlink2/
# will result in /path/to/symlink1/foo/bar
# This will remove all '../' and './'
#
function __symnav_resolve_to --argument path
    set -l to_dir $path

    __symnav_is_absolute "$to_dir"
    and set -l path_to_resolve $to_dir
    or set -l path_to_resolve "$symnav_pwd/$to_dir"

    # Replace all //'s. This can occur if symnav_pwd is '/'
    set -l path_to_resolve (string replace --all -- '//' '/' "$path_to_resolve")

    set -l path_list (__symnav_split_path "$path_to_resolve")

    set -l resolved_path
    for component in $path_list
        if test -z "$component"
            set resolved_path $resolved_path ""
        else if test $component = ".."
            set -e resolved_path[-1]
        else if test $component = "."
            continue # skip this component
        else
            set resolved_path $resolved_path "$component"
        end
    end

    __symnav_join_path $resolved_path
end
