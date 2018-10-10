set -q symnav_initialized          ; or set symnav_initialized 0
set -q symnav_lazy_initialize      ; or set symnav_lazy_initialize 1
set -q symnav_pwd                  ; or set symnav_pwd (test (realpath "$HOME") = "$PWD"; and echo "$HOME"; or echo "$PWD")
set -q symnav_prompt_pwd           ; or set symnav_prompt_pwd 1
set -q symnav_fish_prompt          ; or set symnav_fish_prompt 1
set -q symnav_substitution_mode    ; or set symnav_substitution_mode 'symlink'
set -q symnav_substitute_PWD       ; or set symnav_substitute_PWD 1
set -q symnav_execute_substitution ; or set symnav_execute_substitution 1

function __symnav_initialize
    test $symnav_initialized -eq 1
    and return

    # Check that if 'ask' mode is set that the required dependencies are available
    __symnav_validate_substitution_mode

    # Check that symnav bindings are installed. Lazy initializations are called after setup so the bind
    # command is available. By default we scan the 'fish_user_key_bindings' function

    # test $symnav_lazy_initialize -eq 1
    # and set -l bind_check 'bind'
    # or set -l bind_check 'functions fish_user_key_bindings'
    # if status --is-interactive
    #     if test (eval $bind_check | grep __symnav_execute | wc -l) -eq 0
    #         __symnav_msg "execution bindings may not be installed"
    #     end
    #     if test (eval $bind_check | grep __symnav_complete | wc -l) -eq 0
    #         __symnav_msg "completion bindings may not be installed"
    #     end
    # end

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

    if set -q symnav_user_fix_function_list
        __symnav_msg "symnav_user_fix_function_list is deprecated and will be removed soon"
    end

    # Configuration for some popular themes
    set -l theme_functions
    # - pure
    set theme_functions $theme_functions 'fish_title' '__parse_current_folder'
    # - bobthefish
    set theme_functions  $theme_functions '__bobthefish_prompt_dir'

    # filter functions that do not exist (theme not installed)
    for func in $theme_functions
        if not functions -q $func
            set -e theme_functions[(contains --index $func $theme_functions)]
        end
    end

    for func in 'prompt_pwd' 'fish_prompt' $theme_functions $symnav_modify_functions $symnav_user_fix_function_list
        __symnav_modify_function $func
    end

    set symnav_initialized 1
end

# Parses func for '$PWD', 'realhome' and replaces updates accordingly.
function __symnav_modify_function --arg func
    if not functions -q $func
        status --is-interactive
        and test $symnav_initialized -eq 0
        and test $symnav_lazy_initialize -eq 0
        and __symnav_msg "$func does not exist"
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
