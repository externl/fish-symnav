set -g symdir_initialized 0
set -q symdir_pwd                  ; or set -g symdir_pwd (pwd)
set -q symdir_prompt_pwd           ; or set -g symdir_prompt_pwd 1
set -q symdir_fish_prompt          ; or set -g symdir_fish_prompt 1
set -q symdir_substitution_mode    ; or set -g symdir_substitution_mode 'symlink'
set -q symdir_substitute_PWD       ; or set -g symdir_substitute_PWD 1
set -q symdir_execute_substitution ; or set -g symdir_execute_substitution 0

function __symdir_initialize
    test $symdir_initialized -eq 1
        and return

    # Check that if 'ask' mode is set that the required dependencies are available
    __symdir_validate_substitution_mode

    set -l symdir_shadow_funcs (functions --all | grep __symdir_shadow_)

    # Install all shadow functions. Fish functions are copied to __symdir_fish_$function_name
    for func in $symdir_shadow_funcs
        set -l function_name (string split '__symdir_shadow_' $func)[2]
        set -l fish_function "__symdir_fish_$function_name"
        if not functions --query $fish_function
            functions --copy cd $fish_function
        end
        functions --erase $function_name
        functions --copy $func $function_name
    end

    function __symdir_update_function_PWD --arg func
        if string match --quiet --regex '\$PWD' -- (functions $func)
            string split '\n' -- (functions $func | sed 's/$PWD/$symdir_pwd/' ) | source
        end
    end

    if test $symdir_prompt_pwd -eq 1
        __symdir_update_function_PWD 'prompt_pwd'
    end

    if test $symdir_fish_prompt -eq 1
        __symdir_update_function_PWD 'fish_prompt'
    end

    functions -e __symdir_update_function_PWD

    set symdir_initialized 1
end

function __symdir_debug
    echo "[symdir debug]" $argv 1>&2
end
