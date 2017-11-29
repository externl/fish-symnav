#
# Returns symnav substitution from the based on the
# current_token parameter and the value of symnav_substitution_mode
#
function __symnav_get_substitution --argument current_token
    set -l relative_path (__symnav_relative_to "$current_token")
    switch $symnav_substitution_mode
        #
        # Ask mode. Use fzf to ask user to choose between symbolic link and real path
        #
        case "ask"
            # Either build a possible absolute path to check, or
            # just check the current token
            __symnav_is_absolute "$current_token"
            and  set -l path_to_check $current_token
            or set -l path_to_check $symnav_pwd/$current_token

            set -l real_path (realpath "$path_to_check" ^/dev/null)
            # If the realpath is an empty just return the current token.
            # TODO: maybe check if parts could be changed in case of a command like
            #       touch /path/to/symlink/non-exist-file
            if test -z "$real_path"
                printf '%s' $current_token
            # only if the real_path is not the same and as the absolute path (so a symlink) and
            # the relative_path is indeed an absolute path do we ask the user to select one
            else if test $real_path != $relative_path; and __symnav_is_absolute "$relative_path"
                printf '%s' "$relative_path\n$real_path" | fzf --height '2' | read -l selection
                commandline -f repaint
                if test -z "$selection"
                    printf '%s' $current_token
                else if test "$selection" = "$relative_path"
                    printf '%s' $relative_path
                else
                    printf '%s' $real_path
                end
            else
                printf '%s' $current_token
            end
        #
        # Symlink mode
        #
        case "symlink"
            printf '%s' $relative_path
        #
        # In case something else is set we just return current_token
        #
        case *
            printf '%s' $current_token
    end
end
