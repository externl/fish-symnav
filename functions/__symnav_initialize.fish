set -q symnav_prompt_pwd           ; or set -g symnav_initialized 0
set -q symnav_pwd                  ; or set -g symnav_pwd (test (realpath "$HOME") = "$PWD"; and echo "$HOME"; or echo "$PWD")
set -q symnav_prompt_pwd           ; or set -g symnav_prompt_pwd 1
set -q symnav_fish_prompt          ; or set -g symnav_fish_prompt 1
set -q symnav_fix_function_list    ; or set -g symnav_fix_function_list 'prompt_pwd' 'fish_prompt' 'fish_title' '__parse_current_folder'
set -q symnav_substitution_mode    ; or set -g symnav_substitution_mode 'symlink'
set -q symnav_substitute_PWD       ; or set -g symnav_substitute_PWD 1
set -q symnav_execute_substitution ; or set -g symnav_execute_substitution 0

function __symnav_initialize
    test $symnav_initialized -eq 1
        and return

    # Check that if 'ask' mode is set that the required dependencies are available
    __symnav_validate_substitution_mode

    # Symnav requires the __symnav_complete and __symnav_execute (two of them) bindings to be installed
    if test (bind | grep __symnav | wc -l) -ne 3
        test (bind | grep __symnav_execute | wc -l) -ne 2
        and printf " [symnav] execution bindings are not installed\n"
        test (bind | grep __symnav_complete | wc -l) -ne 1
        and printf " [symnav] completion bindings are not installed\n"
    end

    # Install all shadow functions. Fish functions are copied to __symnav_fish_$function_name
    for func in (functions --all | grep __symnav_shadow_)
        set -l function_name (string split __symnav_shadow_ $func)[2]
        set -l fish_function __symnav_fish_$function_name

        # If the query fails then $function_name either a builtin or does not exist
        if functions --query $function_name
            functions --copy $function_name $fish_function
        end
        functions --erase $function_name
        functions --copy $func $function_name
    end

    function __symnav_fix_function --arg func
        functions --copy $func __symnav_fish_$func
        if string match --quiet --regex '\$PWD' -- (functions $func)
            string split '\n' -- (functions $func | sed 's/$PWD/$symnav_pwd/' ) | source
        end
        if string match --quiet --regex 'realhome ~' -- (functions $func)
            string split '\n' -- (functions $func | sed 's/realhome ~/realhome $HOME/' ) | source
        end
        # Copy to shadow function so that we can remove it in uninstall.fish
        functions --copy $func __symnav_shadow_$func
    end

    for func in $symnav_fix_function_list
        __symnav_fix_function $func
    end

    functions --erase __symnav_fix_function

    set symnav_initialized 1
end

# In case another function changed the working directory, check if the current path
# resolves to PWD, if not just use PWD
# Load during initialization so that the --on-variable hook is loaded by Fish
function __symnav_pwd_handler --on-variable PWD
    if not __symnav_is_realpath
        set symnav_pwd "$PWD"
    end
end
