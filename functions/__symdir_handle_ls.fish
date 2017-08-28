function __symdir_handle_ls
    set -l token (commandline --current-token)
    if string match --regex --quiet '^\.\./?' "$token"
        set -l path_list (__symdir_split_path $symdir_pwd)
        set -e path_list[-1]

        set -l commandline_list (commandline --token)
        set -e commandline_list[-1]
        set -l commandline_list $commandline_list (__symdir_join_path $path_list)

        commandline --replace (string join ' ' $commandline_list)
    end
end
