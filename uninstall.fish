# If the user has change their mode than this will not work.
# It also does not work if 'default' is used in place of a variable
set -l symnav_bind_mode default

bind -M $symnav_bind_mode \n execute
bind -M $symnav_bind_mode \r execute
bind -M $symnav_bind_mode \t complete

for shadow_function in (functions --all | grep __symnav_shadow_)
    set -l function_name (string split __symnav_shadow_ $shadow_function)[2]
    set -l fish_function "__symnav_fish_$function_name"

    functions --erase $function_name
    if functions --query $fish_function
        functions --copy $fish_function $function_name
        functions --erase $fish_function
    end
    functions --erase $shadow_function
end

for func in (functions --all | grep __symnav)
    functions --erase $func
end

set -e symnav_initialized
set -e symnav_pwd
