function __symdir_execute

    # if commandline --paging-mode
    #     return
    # end

    __symdir_initialize
    if not __symdir_is_pwd
        set -l cmd (commandline --tokenize)[1]
        set -l replacer "__symdir_replace_$cmd"
        if functions --query "$replacer"
            eval "$replacer"
        else
            eval __symdir_replace
        end
    end
    commandline -f execute
end
