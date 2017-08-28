function __symdir_handle_ls
    set -l cmd

    set -l path_list (__symdir_split_path $symdir_pwd)
    set -e path_list[-1]
    set -l prev_dir (__symdir_join_path $path_list)

    for arg in (commandline --token)
        set -l replacement_arg (string replace -r '^\.\.' "$prev_dir" $arg)
        set cmd $cmd "$replacement_arg"
    end

    commandline --replace (string join ' ' $cmd)
end
