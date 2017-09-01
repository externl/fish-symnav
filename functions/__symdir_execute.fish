function __symdir_execute
    # Setup variables and install shadow functions
    __symdir_initialize

    set -l current_buffer (commandline --current-buffer)

    if test -n $current_buffer; and not __symdir_is_pwd
        set -l cmd (commandline --tokenize)[1]
        set -l parser "__symdir_parse_$cmd"
        if functions --query "$parser"
            eval "$parser"
        else
            eval __symdir_parse
        end

        if test $symdir_substitute_PWD -eq 1
            commandline --replace (string replace --all '$PWD' '$symdir_pwd' (commandline --current-buffer))
        end

        test $symdir_execute_substitution -eq 0
            and test $current_buffer != (commandline --current-buffer)
            and return
    end

    commandline -f execute
end
