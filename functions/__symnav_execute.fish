function __symnav_execute
    __symnav_initialize
    set -l current_buffer (commandline --current-buffer)

    if test -n $current_buffer; and not __symnav_is_pwd

        # Parse the command line and replace symlinks such as 'fooCmd ../'
        __symnav_parse

        if test $symnav_substitute_PWD -eq 1
            commandline --replace (string replace --all '$PWD' '$symnav_pwd' (commandline --current-buffer))
        end

        test $symnav_execute_substitution -eq 0
        and test $current_buffer != (commandline --current-buffer)
        and return
    end

    commandline -f execute
end


