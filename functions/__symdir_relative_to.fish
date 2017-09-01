#
# Resolve new "relative symlink" directory from 'path'.
# Eg. passing '../foo/bor' with the current path of /path/to/symlink1/symlink2/
# will return in /path/to/symlink1/foo/bar
# Eg. passing '../foo/bar' with the current path of /path/to/all/real/dirs
# will return '../foo/bar'
#
function __symdir_relative_to --argument path
    set -l to_dir $path

    __symdir_is_absolute "$to_dir"
        and set -l path_to_resolve $to_dir
        or set -l path_to_resolve "$symdir_pwd/$to_dir"

    set -l path_list (__symdir_split_path "$path_to_resolve")

    set -l symlink_detected 0
    set -l resolved_path
    for component in $path_list
        if test -z "$component"
            set resolved_path $resolved_path ""
        else if test $component = ".."
            test -L (__symdir_join_path $resolved_path)
                and set symlink_detected 1
            set -e resolved_path[-1]
        else
            set resolved_path $resolved_path "$component"
        end
    end

    if test $symlink_detected -eq 1
        __symdir_join_path $resolved_path
    else
        printf $to_dir
    end
end

