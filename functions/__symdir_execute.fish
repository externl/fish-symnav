function __symdir_execute
    __symdir_initialize
    set -l current_buffer (commandline --current-buffer)

    if test -n $current_buffer; and not __symdir_is_pwd

        # Parse the command line and replace symlinks such as 'fooCmd ../'
        __symdir_parse

        if test $symdir_substitute_PWD -eq 1
            commandline --replace (string replace --all '$PWD' '$symdir_pwd' (commandline --current-buffer))
        end

        test $symdir_execute_substitution -eq 0
            and test $current_buffer != (commandline --current-buffer)
            and return
    end

    commandline -f execute
end


