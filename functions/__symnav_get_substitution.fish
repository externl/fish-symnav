function __symnav_get_substitution --argument current_token

    set -l relative_path (__symnav_relative_to "$current_token")

    switch $symnav_substitution_mode
        case "ask"
            __symnav_is_absolute "$current_token"
            and  set -l path_to_check $current_token
            or set -l path_to_check $symnav_pwd/$current_token

            if not set -l real_path (realpath "$path_to_check" ^/dev/null)
                # Not a real path
                printf $current_token
                return
            end

            if test $real_path != $relative_path; and __symnav_is_absolute "$relative_path"
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
