set -q symnav_initialized          ; or set symnav_initialized 0
set -q symnav_lazy_initialize      ; or set symnav_lazy_initialize 0
set -q symnav_pwd                  ; or set symnav_pwd (test (realpath "$HOME") = "$PWD"; and echo "$HOME"; or echo "$PWD")
set -q symnav_prompt_pwd           ; or set symnav_prompt_pwd 1
set -q symnav_fish_prompt          ; or set symnav_fish_prompt 1
set -q symnav_fix_function_list    ; or set symnav_fix_function_list 'prompt_pwd' 'fish_prompt'
set -q symnav_substitution_mode    ; or set symnav_substitution_mode 'symlink'
set -q symnav_substitute_PWD       ; or set symnav_substitute_PWD 1
set -q symnav_execute_substitution ; or set symnav_execute_substitution 0

function __symnav_initialize
    test $symnav_initialized -eq 1
    and return

    # Check that if 'ask' mode is set that the required dependencies are available
    __symnav_validate_substitution_mode

    # Check that symnav bindings are installed
    test $symnav_lazy_initialize -eq 1
    and set -l bind_check 'bind'
    or set -l bind_check 'functions fish_user_key_bindings'
    if status --is-interactive
        if test (eval $bind_check | grep __symnav_execute | wc -l) -eq 0
            echo "symnav: execution bindings may not be installed" 1>&2
        end
        if test (eval $bind_check | grep __symnav_complete | wc -l) -eq 0
            echo "symnav: completion bindings may not be installed" 1>&2
        end
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

    for func in $symnav_fix_function_list $symnav_fix_function_user_list
        __symnav_fix_function $func
    end

    set symnav_initialized 1
end

# Parses func for '$PWD', 'realhome' and replaces updates accordingly.
function __symnav_fix_function --arg func
    if not functions -q $func
        status --is-interactive
        and test $symnav_initialized -eq 0
        and test $symnav_lazy_initialize -eq 0
        and echo "symnav: Function $func does not exist" 1>&2
        return
    end
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

# In case another function changed the working directory, check if the current path
# resolves to PWD, if not just use PWD
# Load during initialization so that the --on-variable hook is loaded by Fish
function __symnav_pwd_handler --on-variable PWD
    if not __symnav_is_realpath
        set symnav_pwd "$PWD"
    end
end

test $symnav_lazy_initialize -eq 0
and __symnav_initialize
