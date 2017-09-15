function __symdir_get_substitution --argument current_token

    set -l relative_path (__symdir_relative_to "$current_token")

    switch $symdir_substitution_mode
        case "ask"
            __symdir_is_absolute "$current_token"
                and  set -l real_path (realpath $current_token)
                or set -l real_path (realpath $symdir_pwd/$current_token)

            if test $real_path != $relative_path; and __symdir_is_absolute "$relative_path"
                printf "$relative_path\n$real_path" | fzf --height '2' | read -l selection
                commandline -f repaint
                if test -z "$selection"
                    printf $current_token
                else if test "$selection" = "$relative_path"
                    printf $relative_path
                else
                    printf $real_path
                end
            else
                printf $current_token
            end
        case "symlink"
            printf $relative_path
        case *
            printf $current_token
    end
end
