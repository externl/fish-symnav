function __symdir_execute
    __symdir_initialize
    if not __symdir_is_pwd
        set -l cmd (commandline --tokenize)[1]
        set -l parser "__symdir_parse_$cmd"
        if functions --query "$parser"
            eval "$parser"
        else
            eval __symdir_parse
        end

        if test $symdir_rewrite_PWD -eq 1
            set -l buffer (commandline --current-buffer)
            commandline --replace (string replace --all '$PWD' '$symdir_pwd' $buffer)
        end
    end
    commandline -f execute
end
